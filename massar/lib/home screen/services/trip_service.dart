import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/trip_plan_model.dart';

class TripService {
  final Dio dio = Dio();

  static final String unsplashApiKey = dotenv.env["UNSPLASH_KEY"]!;
  static final String groqApiKey = dotenv.env["GROQ_KEY"]!;
  static final String airlabsKey = dotenv.env["AIRLABS_KEY"]!;

  static const String _airlabsBase = "https://airlabs.co/api/v9";

  final Map<String, Map<String, dynamic>> _airportDetailsCache = {};
  final Map<String, String?> _airlineNameCache = {};

  Future<Response> _airlabsGet(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final params = {"api_key": airlabsKey, ...?queryParameters};
    return dio.get("$_airlabsBase$path", queryParameters: params);
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

  Future<String?> _getAirlineName(String iataCode) async {
    if (iataCode.isEmpty) return null;
    if (_airlineNameCache.containsKey(iataCode)) {
      return _airlineNameCache[iataCode];
    }
    try {
      final response = await _airlabsGet(
        "/airlines",
        queryParameters: {"iata_code": iataCode},
      );
      final items = response.data["response"] as List? ?? [];
      if (items.isNotEmpty) {
        final name = items.first["name"]?.toString();
        _airlineNameCache[iataCode] = name;
        return name;
      }
    } catch (_) {}
    _airlineNameCache[iataCode] = null;
    return null;
  }

  Future<Map<String, dynamic>> getFlightData({
    required String origin,
    required String destination,
    int windowDays = 7,
  }) async {
    // /routes uses the static airline route database — works for any future
    // date, unlike /schedules which only shows today's live board.
    final response = await _airlabsGet(
      "/routes",
      queryParameters: {
        "dep_iata": origin,
        "arr_iata": destination,
      },
    );

    final routes = response.data["response"] as List? ?? [];
    if (routes.isEmpty) {
      throw Exception("No direct route from $origin to $destination");
    }

    final route = routes.first;

    final depTimeStr = route["dep_time"]?.toString(); // "HH:MM" local
    final arrTimeStr = route["arr_time"]?.toString(); // "HH:MM" local
    final durationMins =
        int.tryParse(route["duration"]?.toString() ?? "") ?? 0;

    // Parse operating days; default to daily if missing.
    final rawDays = route["days"];
    final opDays = (rawDays is List)
        ? rawDays.map((d) => d.toString().toLowerCase()).toSet()
        : <String>{"mon", "tue", "wed", "thu", "fri", "sat", "sun"};

    const weekdays = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

    // Walk forward from tomorrow until we hit an operating day.
    DateTime? nextDep;
    final now = DateTime.now();
    for (int i = 1; i <= windowDays + 7; i++) {
      final d = now.add(Duration(days: i));
      final dayName = weekdays[d.weekday - 1];
      if (opDays.contains(dayName)) {
        if (depTimeStr != null) {
          final parts = depTimeStr.split(':');
          final h = int.tryParse(parts[0]) ?? 0;
          final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
          nextDep = DateTime(d.year, d.month, d.day, h, m);
          break;
        }
      }
    }

    final arrDt = (nextDep != null && durationMins > 0)
        ? nextDep.add(Duration(minutes: durationMins))
        : null;

    final airlineIata = route["airline_iata"]?.toString() ?? "";
    final airlineName = await _getAirlineName(airlineIata);

    return {
      "flightCompany": airlineName,
      "flightCode": route["flight_iata"]?.toString(),
      "takeoffAirport": origin,
      "destinationAirport": destination,
      "takeoffTime": nextDep != null ? _formatTime(nextDep) : depTimeStr,
      "destinationTime": arrDt != null ? _formatTime(arrDt) : arrTimeStr,
      "departureDate": nextDep != null ? _formatDate(nextDep) : null,
      "arrivalDate": arrDt != null
          ? _formatDate(arrDt)
          : nextDep != null
              ? _formatDate(nextDep)
              : null,
      "takeoffCityName": origin,
      "destinationCityName": destination,
      "destinationCountryCode": "",
    };
  }

  // Strips common airport-name suffixes so "Dubai International Airport"
  // becomes "Dubai", "Singapore Changi Airport" becomes "Singapore Changi", etc.
  String _cityFromAirportName(String name) {
    return name
        .replaceAll(
          RegExp(
            r'\s*(International|Intl\.?|Regional|Municipal|Airport|'
            r'Air\s+Base|Airfield|Aeropuerto|Aéroport|Flughafen|Aeroporto)\s*',
            caseSensitive: false,
          ),
          ' ',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<Map<String, dynamic>> getAirportDetails(String iata) async {
    final code = iata.toUpperCase();
    final cached = _airportDetailsCache[code];
    if (cached != null) return cached;

    final response = await _airlabsGet(
      "/airports",
      queryParameters: {"iata_code": code},
    );

    final items = response.data["response"] as List? ?? [];
    if (items.isEmpty) throw Exception("Airport not found: $iata");

    final airport = items.first as Map;

    // AirLabs may use "city" or "city_name"; fall back to stripping the
    // airport name if neither is present.
    final rawCity = airport["city"]?.toString().trim() ??
        airport["city_name"]?.toString().trim() ??
        "";
    final airportName = airport["name"]?.toString().trim() ?? "";
    final cityName = rawCity.isNotEmpty
        ? rawCity
        : airportName.isNotEmpty
            ? _cityFromAirportName(airportName)
            : code;

    final countryCode = airport["country_code"]?.toString().trim() ?? "";

    // AirLabs sometimes returns the full country name directly — prefer it
    // over the extra restcountries.com round-trip.
    final rawCountryName = airport["country_name"]?.toString().trim() ??
        airport["country"]?.toString().trim() ??
        "";
    final countryName = rawCountryName.isNotEmpty
        ? rawCountryName
        : await _resolveCountryName(countryCode);

    final result = {
      "cityName": cityName.isNotEmpty ? cityName : code,
      "countryName": countryName,
      "countryCode": countryCode,
    };

    _airportDetailsCache[code] = result;
    return result;
  }

  static const Map<String, String> _countryCodeMap = {
    "AF": "Afghanistan", "AL": "Albania", "DZ": "Algeria", "AD": "Andorra",
    "AO": "Angola", "AG": "Antigua and Barbuda", "AR": "Argentina",
    "AM": "Armenia", "AU": "Australia", "AT": "Austria", "AZ": "Azerbaijan",
    "BS": "Bahamas", "BH": "Bahrain", "BD": "Bangladesh", "BB": "Barbados",
    "BY": "Belarus", "BE": "Belgium", "BZ": "Belize", "BJ": "Benin",
    "BT": "Bhutan", "BO": "Bolivia", "BA": "Bosnia and Herzegovina",
    "BW": "Botswana", "BR": "Brazil", "BN": "Brunei", "BG": "Bulgaria",
    "BF": "Burkina Faso", "BI": "Burundi", "CV": "Cape Verde",
    "KH": "Cambodia", "CM": "Cameroon", "CA": "Canada",
    "CF": "Central African Republic", "TD": "Chad", "CL": "Chile",
    "CN": "China", "CO": "Colombia", "KM": "Comoros", "CG": "Congo",
    "CD": "DR Congo", "CR": "Costa Rica", "HR": "Croatia", "CU": "Cuba",
    "CY": "Cyprus", "CZ": "Czech Republic", "DK": "Denmark", "DJ": "Djibouti",
    "DM": "Dominica", "DO": "Dominican Republic", "EC": "Ecuador",
    "EG": "Egypt", "SV": "El Salvador", "GQ": "Equatorial Guinea",
    "ER": "Eritrea", "EE": "Estonia", "SZ": "Eswatini", "ET": "Ethiopia",
    "FJ": "Fiji", "FI": "Finland", "FR": "France", "GA": "Gabon",
    "GM": "Gambia", "GE": "Georgia", "DE": "Germany", "GH": "Ghana",
    "GR": "Greece", "GD": "Grenada", "GT": "Guatemala", "GN": "Guinea",
    "GW": "Guinea-Bissau", "GY": "Guyana", "HT": "Haiti", "HN": "Honduras",
    "HU": "Hungary", "IS": "Iceland", "IN": "India", "ID": "Indonesia",
    "IR": "Iran", "IQ": "Iraq", "IE": "Ireland", "IL": "Israel",
    "IT": "Italy", "JM": "Jamaica", "JP": "Japan", "JO": "Jordan",
    "KZ": "Kazakhstan", "KE": "Kenya", "KI": "Kiribati", "KP": "North Korea",
    "KR": "South Korea", "KW": "Kuwait", "KG": "Kyrgyzstan", "LA": "Laos",
    "LV": "Latvia", "LB": "Lebanon", "LS": "Lesotho", "LR": "Liberia",
    "LY": "Libya", "LI": "Liechtenstein", "LT": "Lithuania", "LU": "Luxembourg",
    "MG": "Madagascar", "MW": "Malawi", "MY": "Malaysia", "MV": "Maldives",
    "ML": "Mali", "MT": "Malta", "MH": "Marshall Islands", "MR": "Mauritania",
    "MU": "Mauritius", "MX": "Mexico", "FM": "Micronesia", "MD": "Moldova",
    "MC": "Monaco", "MN": "Mongolia", "ME": "Montenegro", "MA": "Morocco",
    "MZ": "Mozambique", "MM": "Myanmar", "NA": "Namibia", "NR": "Nauru",
    "NP": "Nepal", "NL": "Netherlands", "NZ": "New Zealand", "NI": "Nicaragua",
    "NE": "Niger", "NG": "Nigeria", "MK": "North Macedonia", "NO": "Norway",
    "OM": "Oman", "PK": "Pakistan", "PW": "Palau", "PA": "Panama",
    "PG": "Papua New Guinea", "PY": "Paraguay", "PE": "Peru",
    "PH": "Philippines", "PL": "Poland", "PT": "Portugal", "QA": "Qatar",
    "RO": "Romania", "RU": "Russia", "RW": "Rwanda",
    "KN": "Saint Kitts and Nevis", "LC": "Saint Lucia",
    "VC": "Saint Vincent and the Grenadines", "WS": "Samoa",
    "SM": "San Marino", "ST": "Sao Tome and Principe", "SA": "Saudi Arabia",
    "SN": "Senegal", "RS": "Serbia", "SC": "Seychelles", "SL": "Sierra Leone",
    "SG": "Singapore", "SK": "Slovakia", "SI": "Slovenia",
    "SB": "Solomon Islands", "SO": "Somalia", "ZA": "South Africa",
    "SS": "South Sudan", "ES": "Spain", "LK": "Sri Lanka", "SD": "Sudan",
    "SR": "Suriname", "SE": "Sweden", "CH": "Switzerland", "SY": "Syria",
    "TW": "Taiwan", "TJ": "Tajikistan", "TZ": "Tanzania", "TH": "Thailand",
    "TL": "Timor-Leste", "TG": "Togo", "TO": "Tonga",
    "TT": "Trinidad and Tobago", "TN": "Tunisia", "TR": "Turkey",
    "TM": "Turkmenistan", "TV": "Tuvalu", "UG": "Uganda", "UA": "Ukraine",
    "AE": "United Arab Emirates", "GB": "United Kingdom",
    "US": "United States", "UY": "Uruguay", "UZ": "Uzbekistan",
    "VU": "Vanuatu", "VE": "Venezuela", "VN": "Vietnam", "YE": "Yemen",
    "ZM": "Zambia", "ZW": "Zimbabwe",
  };

  Future<String> _resolveCountryName(String countryCode) async {
    if (countryCode.isEmpty) return "";
    final code = countryCode.toUpperCase();
    try {
      final response =
          await dio.get("https://restcountries.com/v3.1/alpha/$code");
      if (response.data is List && (response.data as List).isNotEmpty) {
        final country =
            (response.data as List).first as Map<String, dynamic>;
        final name = country["name"]?["common"]?.toString().trim();
        if (name != null && name.isNotEmpty) return name;
      }
    } catch (_) {}
    return _countryCodeMap[code] ?? code;
  }

  Future<String?> getTicketPrice({
    required String origin,
    required String destination,
  }) async {
    try {
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
          "temperature": 0.2,
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a flight pricing assistant. Respond with ONLY a "
                  "single integer representing a realistic economy class "
                  "one-way ticket price in USD for the given route. "
                  "No text, no currency symbol, just the number.",
            },
            {
              "role": "user",
              "content": "Economy one-way ticket price from $origin to $destination airport.",
            },
          ],
        },
      );

      final text =
          response.data["choices"][0]["message"]["content"].toString().trim();
      final price = int.tryParse(RegExp(r'\d+').firstMatch(text)?.group(0) ?? "");
      if (price != null && price > 0) return "\$$price";
    } catch (_) {}
    return null;
  }

  Future<TripPlanModel?> generateTripPlan({
    required String cityName,
    required String countryName,
    required int budget,
  }) async {
    try {
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
          "temperature": 0.4,
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a travel planner. Respond ONLY with valid JSON and nothing else — "
                  "no markdown, no explanation, no code fences. "
                  "Use exactly this structure:\n"
                  '{"accommodations":[{"hotel_name":"...","location":"City, Country",'
                  '"room_type":"...","nights":3,"days":4,"price_per_night_egp":2000,'
                  '"total_egp":6000}],"attractions":[{"name":"...","fee_egp":200}]}\n'
                  "All prices in EGP. Use fee_egp 0 for free attractions.",
            },
            {
              "role": "user",
              "content":
                  "Plan a trip to $cityName, $countryName with a total budget of "
                  "$budget EGP. Include exactly 1 real hotel accommodation and 4-6 "
                  "popular tourist attractions with realistic prices.",
            },
          ],
        },
      );

      final raw =
          response.data["choices"][0]["message"]["content"].toString().trim();
      final jsonStr = raw
          .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
          .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
          .trim();

      return TripPlanModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (e) {
      print("generateTripPlan error: $e");
      return null;
    }
  }

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
            "content":
                "You must respond with ONLY 5 airport IATA codes separated "
                "by commas, nothing else. Choose destinations that have "
                "direct scheduled flights from the origin airport. "
                "No explanation, no currency codes, no airport names, "
                "no punctuation besides commas. "
                "Example output: DXB,CDG,AMS,IST,SIN",
          },
          {
            "role": "user",
            "content":
                "Budget: $budget EGP. Origin airport: $origin.$excludeText",
          },
        ],
      },
    );

    final text =
        response.data["choices"][0]["message"]["content"].toString().trim();

    print("Raw Groq response: \"$text\"");

    final candidateTokens = RegExp(r'\b[A-Za-z]{3}\b')
        .allMatches(text)
        .map((m) => m.group(0)!.toUpperCase())
        .toList();

    const stopwords = {
      'THE', 'AND', 'FOR', 'ARE', 'BUT', 'NOT', 'YOU', 'ALL',
      'CAN', 'HER', 'WAS', 'ONE', 'OUR', 'OUT', 'DAY', 'GET',
      'HAS', 'HIM', 'HIS', 'HOW', 'MAN', 'NEW', 'NOW', 'OLD',
      'SEE', 'TWO', 'WAY', 'WHO', 'BOY', 'DID', 'ITS', 'LET',
      'PUT', 'SAY', 'SHE', 'TOO', 'USE', 'YES', 'YET', 'SUR',
      'EGP', 'USD', 'EUR', 'GBP', 'AED', 'SAR', 'KWD', 'QAR',
      'JPY', 'CNY', 'INR', 'TRY', 'MAD', 'NGN', 'KES', 'ZAR',
      'APX', 'APP', 'EST', 'ETA', 'ETD', 'INT', 'LOC', 'MIN',
      'MAX', 'PER', 'REF', 'TBD', 'TBC', 'VIA',
    };

    final destinations = candidateTokens
        .where((e) => RegExp(r'^[A-Z]{3}$').hasMatch(e))
        .where((e) => !stopwords.contains(e))
        .where((e) => e != origin.toUpperCase())
        .toSet()
        .toList();

    print("Generated destinations: $destinations");

    if (destinations.isEmpty) {
      throw Exception(
          "Could not parse any IATA codes from Groq response: \"$text\"");
    }

    return destinations;
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
        if (trips.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 300));
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
          print("getFlightData failed for $origin → $destination: $e");
          usedFallback = true;
          flightData = {
            "flightCompany": null,
            "flightCode": null,
            "takeoffAirport": origin,
            "destinationAirport": destination,
            "takeoffTime": null,
            "destinationTime": null,
            "departureDate": null,
            "arrivalDate": null,
            "takeoffCityName": origin,
            "destinationCityName": cityName,
            "destinationCountryCode":
                airportDetails["countryCode"]?.toString() ?? "",
          };
        }

        final countryName = await _resolveTripCountryName(
          airportDetails: airportDetails,
          flightData: flightData,
        );

        final placeData = await getPlaceData(
          cityName: cityName,
          countryName: countryName,
        );

        final ticketPrice = await getTicketPrice(
          origin: origin,
          destination: destination,
        );

        Map<String, dynamic> returnFlightData = {
          "flightCompany": null,
          "flightCode": null,
          "departureDate": null,
          "arrivalDate": null,
          "takeoffTime": null,
          "destinationTime": null,
        };
        try {
          returnFlightData = await getFlightData(
            origin: destination,
            destination: origin,
          );
        } catch (_) {}

        final tripPlan = await generateTripPlan(
          cityName: cityName,
          countryName: countryName,
          budget: budget,
        );

        trips.add({
          "cityName": cityName,
          "countryName": countryName,
          "tripBudget": "$budget EGP",
          "locationName": countryName,
          "locationImage": placeData["locationImage"],
          "departureDate": flightData["departureDate"],
          "arrivalDate": flightData["arrivalDate"],
          "flightCompany": flightData["flightCompany"],
          "flightCode": flightData["flightCode"],
          "ticketPrice": ticketPrice,
          "takeoffCity": flightData["takeoffCityName"],
          "takeoffAirport": flightData["takeoffAirport"],
          "takeoffTime": flightData["takeoffTime"],
          "destinationCity": cityName,
          "destinationAirport": flightData["destinationAirport"],
          "destinationTime": flightData["destinationTime"],
          "returnFlightCompany": returnFlightData["flightCompany"],
          "returnFlightCode": returnFlightData["flightCode"],
          "returnDepartureDate": returnFlightData["departureDate"],
          "returnArrivalDate": returnFlightData["arrivalDate"],
          "returnTakeoffTime": returnFlightData["takeoffTime"],
          "returnDestinationTime": returnFlightData["destinationTime"],
          "isRealFlightData": !usedFallback,
          "fullTripPlan": "Trip plan will be generated soon",
          "tripPlan": tripPlan,
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
