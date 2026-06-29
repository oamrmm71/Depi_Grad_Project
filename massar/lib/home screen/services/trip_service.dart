import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TripService {
  final Dio dio = Dio();

  static final String aerodataBoxApiKey = dotenv.env["AERODATABOX_KEY"]!;
  static final String unsplashApiKey = dotenv.env["UNSPLASH_KEY"]!;
  static final String groqApiKey = dotenv.env["GROQ_KEY"]!;

  /// Cache airport lookups for the lifetime of this TripService instance.
  /// Same IATA codes get suggested repeatedly across searches (DXB, CDG, IST,
  /// etc.), so this avoids burning API quota re-fetching airport details you
  /// already have.
  final Map<String, Map<String, dynamic>> _airportDetailsCache = {};

  /// Cache the full departures list per origin+window for the lifetime of this
  /// TripService instance. The departures list does NOT depend on the
  /// destination, so re-querying it for every single destination was
  /// multiplying API calls for no reason and made rate limiting far worse than
  /// necessary. (FIX #3 — bonus inefficiency)
  final Map<String, List<dynamic>> _departuresCache = {};

  String _toLocalApiTimestamp(DateTime utc) {
    return "${utc.year}-"
        "${utc.month.toString().padLeft(2, '0')}-"
        "${utc.day.toString().padLeft(2, '0')}T"
        "${utc.hour.toString().padLeft(2, '0')}:00";
  }

  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year}";
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  // ---------------------------------------------------------------------------
  // Generic retry-with-backoff wrapper for AeroDataBox calls.
  // ---------------------------------------------------------------------------
  Future<Response> _aeroDataBoxGet(
    String url, {
    Map<String, dynamic>? queryParameters,
    int maxRetries = 4,
  }) async {
    int attempt = 0;
    final rand = Random();

    while (true) {
      try {
        final response = await dio.get(
          url,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              "X-RapidAPI-Key": aerodataBoxApiKey,
              "X-RapidAPI-Host": "aerodatabox.p.rapidapi.com",
            },
          ),
        );
        return response;
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final isRateLimited = status == 429;
        final isServerError = status != null && status >= 500;

        attempt++;
        if ((isRateLimited || isServerError) && attempt <= maxRetries) {
          final retryAfterHeader =
              e.response?.headers.value('retry-after');
          int waitMs;
          if (retryAfterHeader != null) {
            final seconds = int.tryParse(retryAfterHeader);
            waitMs = seconds != null ? seconds * 1000 : 1500 * attempt;
          } else {
            // Exponential backoff with jitter: ~1.5 s, 3 s, 6 s, 12 s …
            waitMs =
                (1500 * pow(2, attempt - 1)).toInt() + rand.nextInt(400);
          }

          print(
            "AeroDataBox request rate limited/server error (status=$status). "
            "Retry attempt $attempt/$maxRetries after ${waitMs}ms. URL=$url",
          );

          await Future.delayed(Duration(milliseconds: waitMs));
          continue;
        }

        if (isRateLimited) {
          print(
            "=== AERODATABOX 429 - QUOTA/RATE LIMIT DETAILS ===\n"
            "URL: $url\n"
            "Response headers: ${e.response?.headers.map}\n"
            "Response body: ${e.response?.data}\n"
            "===================================================",
          );
        } else {
          print(
            "AeroDataBox request failed permanently. status=$status "
            "message=${e.message} data=${e.response?.data} URL=$url",
          );
        }
        rethrow;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // FIX #1 + FIX #3
  //
  // FIX #1 — AeroDataBox rejects any window longer than 12 hours with HTTP 400
  // ("The requested period of time must not be more than 12 hours in
  // duration"). The old code passed windowDays * 24 hours as a single request,
  // so EVERY flight lookup returned a 400 and we always fell back to placeholder
  // data — not a rate-limit problem at all.
  //
  // The fix: split the full window into ≤12-hour chunks, call the API once per
  // chunk, and merge the results.
  //
  // FIX #3 — The departures list does not depend on the destination. Fetching
  // it once per origin (and caching) instead of once per destination eliminates
  // 5× redundant API calls.
  // ---------------------------------------------------------------------------
  Future<List<dynamic>> _fetchDeparturesForOrigin({
    required String origin,
    required int windowDays,
  }) async {
    final cacheKey = "$origin:$windowDays";
    final cached = _departuresCache[cacheKey];
    if (cached != null) {
      print("_fetchDeparturesForOrigin: cache hit for $cacheKey");
      return cached;
    }

    final now = DateTime.now().toUtc();
    final totalHours = windowDays * 24;

    // AeroDataBox hard limit: window must be ≤ 12 hours.
    const chunkHours = 12;

    final allDepartures = <dynamic>[];

    for (int offset = 0; offset < totalHours; offset += chunkHours) {
      final chunkStart = now.add(Duration(hours: offset));
      final chunkEnd = now.add(
        Duration(hours: min(offset + chunkHours, totalHours)),
      );

      // Guard against a degenerate zero-length final chunk.
      if (!chunkEnd.isAfter(chunkStart)) continue;

      final from = _toLocalApiTimestamp(chunkStart);
      final until = _toLocalApiTimestamp(chunkEnd);

      try {
        final response = await _aeroDataBoxGet(
          "https://aerodatabox.p.rapidapi.com/flights/airports/iata/$origin/$from/$until",
          queryParameters: {
            "withLeg": true,
            "direction": "Departure",
            "withCancelled": false,
            "withCodeshared": true,
            "withCargo": false,
            "withPrivate": false,
          },
        );

        final departures = response.data["departures"] as List? ?? [];
        print(
          "_fetchDeparturesForOrigin: chunk $from → $until returned "
          "${departures.length} departure(s) for $origin",
        );
        allDepartures.addAll(departures);
      } catch (e) {
        // One missing chunk should not kill the whole search.
        print(
          "Skipping departures chunk $from → $until for $origin due to error: $e",
        );
      }

      // Small inter-chunk delay to stay under per-second/minute rate limits.
      if (offset + chunkHours < totalHours) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    print(
      "_fetchDeparturesForOrigin: $origin total departures fetched over "
      "$windowDays day(s): ${allDepartures.length}",
    );

    _departuresCache[cacheKey] = allDepartures;
    return allDepartures;
  }

  Future<Map<String, dynamic>> getFlightData({
    required String origin,
    required String destination,
    int windowDays = 7,
  }) async {
    // Uses the cached, chunked departures list — no repeated API calls.
    final departures = await _fetchDeparturesForOrigin(
      origin: origin,
      windowDays: windowDays,
    );

    if (departures.isEmpty) {
      throw Exception("No departures found from $origin");
    }

    final matchingFlights = departures.where((flight) {
      final arrivalCode =
          flight["arrival"]?["airport"]?["iata"]?.toString();
      return arrivalCode == destination;
    }).toList();

    if (matchingFlights.isEmpty) {
      throw Exception("No flights from $origin to $destination in window");
    }

    final flight = matchingFlights.first;

    final depTimeRaw =
        flight["departure"]?["scheduledTimeLocal"]?.toString();
    final arrTimeRaw =
        flight["arrival"]?["scheduledTimeLocal"]?.toString();

    final depDt = depTimeRaw != null ? DateTime.tryParse(depTimeRaw) : null;
    final arrDt = arrTimeRaw != null ? DateTime.tryParse(arrTimeRaw) : null;

    return {
      "flightCompany": flight["airline"]?["name"] ?? "Unknown Airline",
      "flightCode": flight["number"] ?? "N/A",
      "takeoffAirport":
          flight["departure"]?["airport"]?["name"] ?? origin,
      "destinationAirport":
          flight["arrival"]?["airport"]?["name"] ?? destination,
      "takeoffTime": depDt != null ? _formatTime(depDt) : "TBD",
      "destinationTime": arrDt != null ? _formatTime(arrDt) : "TBD",
      "departureDate": depDt != null ? _formatDate(depDt) : "",
      "arrivalDate": arrDt != null ? _formatDate(arrDt) : "",
      "takeoffCityName":
          flight["departure"]?["airport"]?["municipalityName"] ?? origin,
      "destinationCityName":
          flight["arrival"]?["airport"]?["municipalityName"] ?? destination,
      "destinationCountryCode":
          flight["arrival"]?["airport"]?["countryCode"]?.toString() ?? "",
    };
  }

  Future<Map<String, dynamic>> _lookupAirportBySearch(String iata) async {
    final response = await _aeroDataBoxGet(
      "https://aerodatabox.p.rapidapi.com/airports/search/term",
      queryParameters: {"q": iata, "limit": "10"},
    );

    final items = response.data["items"] as List? ?? [];
    final code = iata.toUpperCase();

    for (final item in items) {
      if (item is Map && item["iata"]?.toString().toUpperCase() == code) {
        return Map<String, dynamic>.from(item);
      }
    }

    if (items.isNotEmpty && items.first is Map) {
      return Map<String, dynamic>.from(items.first as Map);
    }

    throw Exception("Airport not found for $iata");
  }

  String _extractCountryCode(Map<String, dynamic> data) {
    final direct = data["countryCode"]?.toString().trim();
    if (direct != null && direct.isNotEmpty) return direct;

    final country = data["country"];
    if (country is Map) {
      for (final key in ["code", "iso2", "alpha2", "countryCode"]) {
        final value = country[key]?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    return "";
  }

  String? _extractCountryNameFromData(Map<String, dynamic> data) {
    final country = data["country"];
    if (country is! Map) return null;

    final name = country["name"];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    if (name is Map) {
      for (final key in ["common", "en", "official"]) {
        final value = name[key]?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    for (final key in ["commonName", "fullName"]) {
      final value = country[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }

    return null;
  }

  Future<Map<String, dynamic>> getAirportDetails(String iata) async {
    final code = iata.toUpperCase();

    final cached = _airportDetailsCache[code];
    if (cached != null) {
      return cached;
    }

    Map<String, dynamic> data;

    try {
      final response = await _aeroDataBoxGet(
        "https://aerodatabox.p.rapidapi.com/airports/iata/$iata",
      );
      data = Map<String, dynamic>.from(response.data as Map);
    } catch (e) {
      print(
        "getAirportDetails: direct lookup failed for $iata ($e), "
        "trying search fallback",
      );
      data = await _lookupAirportBySearch(iata);
    }

    var cityName = data["municipalityName"]?.toString().trim() ?? "";

    if (cityName.isEmpty) {
      cityName = _cityFromAirportName(
        data["shortName"]?.toString() ??
            data["name"]?.toString() ??
            "",
      );
    }

    if (cityName.isEmpty) cityName = iata;

    final countryCode = _extractCountryCode(data);
    final countryNameFromApi = _extractCountryNameFromData(data);
    final countryName =
        (countryNameFromApi != null && countryNameFromApi.isNotEmpty)
            ? countryNameFromApi
            : await _resolveCountryName(countryCode);

    final result = {
      "cityName": cityName,
      "countryName": countryName,
      "countryCode": countryCode,
    };

    _airportDetailsCache[code] = result;
    return result;
  }

  String _cityFromAirportName(String airportName) {
    return airportName
        .replaceAll(
          RegExp(
            r'\s*(International|Intl\.?|Regional|Municipal|Airport|Air Base|Airfield)\s*',
            caseSensitive: false,
          ),
          ' ',
        )
        .trim();
  }

  Future<String> _resolveCountryName(String countryCode) async {
    if (countryCode.isEmpty) return "";

    final code = countryCode.toUpperCase();
    final cached = _countryCodeNames[code];
    if (cached != null) return cached;

    try {
      final response = await dio.get(
        "https://restcountries.com/v3.1/alpha/$code",
      );

      if (response.data is List &&
          (response.data as List).isNotEmpty) {
        final country =
            (response.data as List).first as Map<String, dynamic>;
        final name = country["name"]?["common"]?.toString().trim();
        if (name != null && name.isNotEmpty) return name;
      }
    } catch (_) {}

    return code;
  }

  static const Map<String, String> _countryCodeNames = {
    'AE': 'United Arab Emirates',
    'AT': 'Austria',
    'AU': 'Australia',
    'BE': 'Belgium',
    'BG': 'Bulgaria',
    'BR': 'Brazil',
    'CA': 'Canada',
    'CH': 'Switzerland',
    'CN': 'China',
    'CY': 'Cyprus',
    'CZ': 'Czechia',
    'DE': 'Germany',
    'DK': 'Denmark',
    'EG': 'Egypt',
    'ES': 'Spain',
    'FI': 'Finland',
    'FR': 'France',
    'GB': 'United Kingdom',
    'GR': 'Greece',
    'HR': 'Croatia',
    'HU': 'Hungary',
    'ID': 'Indonesia',
    'IE': 'Ireland',
    'IN': 'India',
    'IT': 'Italy',
    'JP': 'Japan',
    'KE': 'Kenya',
    'KR': 'South Korea',
    'KW': 'Kuwait',
    'LB': 'Lebanon',
    'MA': 'Morocco',
    'MX': 'Mexico',
    'MY': 'Malaysia',
    'NG': 'Nigeria',
    'NL': 'Netherlands',
    'NO': 'Norway',
    'OM': 'Oman',
    'PH': 'Philippines',
    'PL': 'Poland',
    'PT': 'Portugal',
    'QA': 'Qatar',
    'RO': 'Romania',
    'RU': 'Russia',
    'SA': 'Saudi Arabia',
    'SE': 'Sweden',
    'SG': 'Singapore',
    'TH': 'Thailand',
    'TR': 'Turkey',
    'US': 'United States',
    'VN': 'Vietnam',
    'ZA': 'South Africa',
  };

  Future<Map<String, dynamic>> getPlaceData({
    required String cityName,
    required String countryName,
  }) async {
    final searchQuery =
        countryName.isNotEmpty ? "$cityName $countryName" : cityName;

    final imageResponse = await dio.get(
      "https://api.unsplash.com/search/photos",
      queryParameters: {
        "query": searchQuery,
        "client_id": unsplashApiKey,
        "per_page": 1,
      },
    );

    final imageResults = imageResponse.data["results"];

    final imageUrl =
        (imageResults != null && imageResults.isNotEmpty)
            ? imageResults.first["urls"]["regular"]
            : "https://images.unsplash.com/photo-1507525428034-b723cf961d3e";

    return {"locationImage": imageUrl};
  }

  Future<List<String>> getAIDestinations({
    required int budget,
    required String origin,
    List<String> excludeCities = const [],
  }) async {
    final excludeText = excludeCities.isNotEmpty
        ? " Do not suggest airports for these cities: ${excludeCities.join(', ')}."
        : "";

    final response = await dio.post(
      "https://api.groq.com/openai/v1/chat/completions",
      options: Options(
        headers: {
          "Authorization": "Bearer $groqApiKey",
          "Content-Type": "application/json",
        },
      ),
      data: {
        "model": "llama-3.1-8b-instant",
        "temperature": 1.2,
        "messages": [
          {
            "role": "system",
            // Stricter prompt: no prose, no currency codes, no explanation.
            "content":
                "You must respond with ONLY 5 airport IATA codes separated "
                "by commas, nothing else. No explanation, no currency codes, "
                "no airport names, no punctuation besides commas. "
                "Example output: DXB,CDG,AMS,IST,SIN"
          },
          {
            "role": "user",
            "content":
                "Budget: $budget EGP. Origin airport: $origin.$excludeText"
          }
        ],
      },
    );

    final text = response.data["choices"][0]["message"]["content"]
        .toString()
        .trim();

    print("Raw Groq response: \"$text\"");

    // Scan for any standalone 3-letter token anywhere in the response.
    // This handles cases like "Sure! DXB, CDG, AMS…" or codes separated
    // by newlines/spaces instead of commas.
    final candidateTokens = RegExp(r'\b[A-Za-z]{3}\b')
        .allMatches(text)
        .map((m) => m.group(0)!.toUpperCase())
        .toList();

    // ---------------------------------------------------------------------------
    // FIX #2 — Currency codes (EGP, USD, EUR, …) were NOT in the original
    // stopword set, so when the AI added prose like "1 000 000 EGP (≈ 40 000
    // USD)" those tokens passed the filter and were treated as destination IATA
    // codes, burning real API quota on garbage lookups.
    // ---------------------------------------------------------------------------
    const stopwords = {
      // Common English words
      'THE', 'AND', 'FOR', 'ARE', 'BUT', 'NOT', 'YOU', 'ALL',
      'CAN', 'HER', 'WAS', 'ONE', 'OUR', 'OUT', 'DAY', 'GET',
      'HAS', 'HIM', 'HIS', 'HOW', 'MAN', 'NEW', 'NOW', 'OLD',
      'SEE', 'TWO', 'WAY', 'WHO', 'BOY', 'DID', 'ITS', 'LET',
      'PUT', 'SAY', 'SHE', 'TOO', 'USE', 'YES', 'YET', 'SUR',
      // Currency / unit codes the model mentions when explaining the budget.
      // FIX #2: these were missing before.
      'EGP', 'USD', 'EUR', 'GBP', 'AED', 'SAR', 'KWD', 'QAR',
      'JPY', 'CNY', 'INR', 'TRY', 'MAD', 'NGN', 'KES', 'ZAR',
      // Other common non-IATA tokens that appear in prose
      'APX', 'APP', 'EST', 'ETA', 'ETD', 'INT', 'LOC', 'MIN',
      'MAX', 'PER', 'REF', 'TBD', 'TBC', 'VIA',
    };

    final destinations = candidateTokens
        .where((e) => RegExp(r'^[A-Z]{3}$').hasMatch(e))
        .where((e) => !stopwords.contains(e))
        .where((e) => e != origin.toUpperCase())
        .toSet() // de-dupe
        .toList();

    print("Generated destinations: $destinations");

    if (destinations.isEmpty) {
      throw Exception(
        "Could not parse any IATA codes from Groq response: \"$text\"",
      );
    }

    return destinations;
  }

  Map<String, dynamic> _placeholderFlightData({
    required String origin,
    required String destination,
    required Map<String, dynamic> airportDetails,
  }) {
    final seed = DateTime.now().millisecondsSinceEpoch;
    final departure = DateTime.now().add(Duration(days: 3 + (seed % 6)));
    final arrival =
        departure.add(Duration(days: 3 + ((seed ~/ 7) % 6)));

    return {
      "flightCompany": "Unknown Airline",
      "flightCode": "N/A",
      "takeoffAirport": origin,
      "destinationAirport": destination,
      "takeoffTime": _formatTime(departure),
      "destinationTime": _formatTime(arrival),
      "departureDate": _formatDate(departure),
      "arrivalDate": _formatDate(arrival),
      "takeoffCityName": origin,
      "destinationCityName": airportDetails["cityName"],
      "destinationCountryCode":
          airportDetails["countryCode"]?.toString() ?? "",
    };
  }

  Future<String> _resolveTripCountryName({
    required Map<String, dynamic> airportDetails,
    required Map<String, dynamic> flightData,
  }) async {
    final fromAirport =
        airportDetails["countryName"]?.toString().trim() ?? "";
    if (fromAirport.isNotEmpty) return fromAirport;

    final fromFlight =
        flightData["destinationCountryCode"]?.toString().trim() ?? "";
    if (fromFlight.isNotEmpty) return _resolveCountryName(fromFlight);

    final fromAirportCode =
        airportDetails["countryCode"]?.toString().trim() ?? "";
    if (fromAirportCode.isNotEmpty) {
      return _resolveCountryName(fromAirportCode);
    }

    return "";
  }

  Future<List<Map<String, dynamic>>> getTripSuggestions({
    required String origin,
    required int budget,
    List<String> excludeCities = const [],
  }) async {
    final destinations = await getAIDestinations(
      budget: budget,
      origin: origin,
      excludeCities: excludeCities,
    );

    const maxDestinationsToQuery = 5;
    final cappedDestinations =
        destinations.take(maxDestinationsToQuery).toList();

    final excluded = excludeCities.map((c) => c.toLowerCase()).toSet();
    List<Map<String, dynamic>> trips = [];

    for (final destination in cappedDestinations) {
      try {
        // Small inter-destination delay to avoid hitting per-second limits.
        if (trips.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 600));
        }

        final airportDetails = await getAirportDetails(destination);
        final cityName =
            airportDetails["cityName"]?.toString() ?? destination;

        if (excluded.contains(cityName.toLowerCase())) {
          print("Skipping $destination ($cityName) — in excludeCities list");
          continue;
        }

        Map<String, dynamic> flightData;
        bool usedFallback = false;

        try {
          flightData = await getFlightData(
            origin: origin,
            destination: destination,
          );
        } catch (e) {
          print(
            "getFlightData failed for $origin → $destination, "
            "using placeholder. Reason: $e",
          );
          usedFallback = true;
          flightData = _placeholderFlightData(
            origin: origin,
            destination: destination,
            airportDetails: airportDetails,
          );
        }

        final countryName = await _resolveTripCountryName(
          airportDetails: airportDetails,
          flightData: flightData,
        );

        final placeData = await getPlaceData(
          cityName: cityName,
          countryName: countryName,
        );

        // Ensure dates are never empty (fall back to placeholder values).
        final placeholderDates = _placeholderFlightData(
          origin: origin,
          destination: destination,
          airportDetails: airportDetails,
        );

        trips.add({
          "cityName": cityName,
          "countryName": countryName,
          "tripBudget": "$budget EGP",
          "locationName": countryName,
          "locationImage": placeData["locationImage"],
          "departureDate":
              (flightData["departureDate"]?.toString().trim().isNotEmpty ??
                      false)
                  ? flightData["departureDate"]
                  : placeholderDates["departureDate"],
          "arrivalDate":
              (flightData["arrivalDate"]?.toString().trim().isNotEmpty ??
                      false)
                  ? flightData["arrivalDate"]
                  : placeholderDates["arrivalDate"],
          "flightCompany": flightData["flightCompany"],
          "flightCode": flightData["flightCode"],
          "takeoffCity": flightData["takeoffCityName"],
          "takeoffAirport": flightData["takeoffAirport"],
          "takeoffTime": flightData["takeoffTime"],
          "destinationCity": flightData["destinationCityName"],
          "destinationAirport": flightData["destinationAirport"],
          "destinationTime": flightData["destinationTime"],
          "isRealFlightData": !usedFallback,
          "fullTripPlan": "Trip plan will be generated soon",
          "tours": [
            {"name": "City Tour", "price": "1000 EGP"},
            {"name": "Museum Visit", "price": "500 EGP"},
          ],
        });

        excluded.add(cityName.toLowerCase());

        if (trips.length >= 5) break;
      } catch (e) {
        print("Failed to process destination $destination: $e");
      }
    }

    return trips;
  }
}