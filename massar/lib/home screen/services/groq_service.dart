import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/trip_plan_model.dart';

class GroqService {
  final Dio _dio = Dio();

  static final String _apiKey = dotenv.env["GROQ_KEY"]!;
  static const String _endpoint =
      "https://api.groq.com/openai/v1/chat/completions";
  static const String _model = "llama-3.1-8b-instant";

  Options get _options => Options(headers: {
        "Authorization": "Bearer $_apiKey",
        "Content-Type": "application/json",
      });

  Future<String> _chat({
    required List<Map<String, String>> messages,
    double temperature = 0.7,
  }) async {
    final response = await _dio.post(
      _endpoint,
      options: _options,
      data: {
        "model": _model,
        "temperature": temperature,
        "messages": messages,
      },
    );

    return response.data["choices"][0]["message"]["content"]
        .toString()
        .trim();
  }

  Future<List<String>> getAIDestinations({
    required int budget,
    required String origin,
    List<String> excludeCities = const [],
    String? tripType,
  }) async {
    final excludeText = excludeCities.isNotEmpty
        ? " Do not suggest airports for these cities: ${excludeCities.join(', ')}."
        : "";

    final tripTypeHint = switch (tripType) {
      'Tour Package' =>
        ' Focus on destinations with rich cultural heritage, famous landmarks, and guided tour opportunities.',
      'Budget Package' =>
        ' Focus on budget-friendly destinations where the budget goes far — affordable flights and low-cost accommodation.',
      'Trip Package' =>
        ' Focus on diverse leisure and adventure destinations ideal for short getaways and varied experiences.',
      _ => '',
    };

    final text = await _chat(
      temperature: 1.2,
      messages: [
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
              "Budget: $budget EGP. Origin airport: $origin.$excludeText$tripTypeHint",
        },
      ],
    );

    print("Raw Groq response: \"$text\"");

    const stopwords = {
  'THE','AND','FOR','ARE','BUT','NOT','YOU','ALL',
  'CAN','HER','WAS','ONE','OUR','OUT','DAY','GET',
  'HAS','HIM','HIS','HOW','MAN','NEW','NOW','OLD',
  'SEE','TWO','WAY','WHO','BOY','DID','ITS','LET',
  'PUT','SAY','SHE','TOO','USE','YES','YET','SUR',
  'EGP','USD','EUR','GBP','AED','SAR','KWD','QAR',
  'JPY','CNY','INR','TRY','MAD','NGN','KES','ZAR',
  'APX','APP','EST','ETA','ETD','INT','LOC','MIN',
  'MAX','PER','REF','TBD','TBC','VIA',
};

    final destinations = RegExp(r'\b[A-Za-z]{3}\b')
        .allMatches(text)
        .map((m) => m.group(0)!.toUpperCase())
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

  Future<String?> getTicketPrice({
    required String origin,
    required String destination,
  }) async {
    try {
      final text = await _chat(
        temperature: 0.2,
        messages: [
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
            "content":
                "Economy one-way ticket price from $origin to $destination airport.",
          },
        ],
      );

      final price =
          int.tryParse(RegExp(r'\d+').firstMatch(text)?.group(0) ?? "");

      if (price != null && price > 0) {
        return "\$$price";
      }
    } catch (_) {}

    return null;
  }

  Future<TripPlanModel?> generateTripPlan({
    required String cityName,
    required String countryName,
    required int budget,
  }) async {
    try {
      final raw = await _chat(
        temperature: 0.4,
        messages: [
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
      );

      final jsonStr = raw
          .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
          .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
          .trim();

      return TripPlanModel.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );
    } catch (e) {
      print("generateTripPlan error: $e");
      return null;
    }
  }

  Future<List<dynamic>> generateExpensePlan({
    required String cityName,
    required String countryName,
    required int days,
  }) async {
    try {
      final raw = await _chat(
        temperature: 0.5,
        messages: [
          {
            "role": "system",
            "content":
                "You are a travel expense planner. Reply ONLY with valid JSON. "
                "Do not use markdown or code fences."
          },
          {
            "role": "user",
            "content": """
            Generate a realistic expense schedule for a tourist.

            City: $cityName
            Country: $countryName
            Trip Duration: $days days

            Return ONLY this JSON format:

            [
              {
                "day":1,
                "place":"Eiffel Tower",
                "entryFee":200,
                "transport":200,
                "total":400
              }
            ]

            Rules:

            - Generate 2-3 attractions per day.
            - Prices must be in EGP.
            - total = entryFee + transport.
            - Use real tourist attractions.
            - Return ONLY JSON.
            """
          }
        ],
      );

      final jsonString = raw
          .replaceAll(RegExp(r'^```json\s*', multiLine: true), '')
          .replaceAll(RegExp(r'^```\s*', multiLine: true), '')
          .trim();

      return jsonDecode(jsonString) as List<dynamic>;
    } catch (e) {
      print("generateExpensePlan error: $e");
      return [];
    }
  }
}