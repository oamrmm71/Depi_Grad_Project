import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class CountryService {
  final Dio _dio = Dio();
  Map<String, String>? _codeMap;

  Future<Map<String, String>> _loadCodeMap() async {
    _codeMap ??= Map<String, String>.from(
      jsonDecode(
        await rootBundle.loadString('lib/assets/country_codes.json'),
      ) as Map,
    );
    return _codeMap!;
  }

  Future<String> resolveCountryName(String countryCode) async {
    if (countryCode.isEmpty) return "";
    final code = countryCode.toUpperCase();
    try {
      final response =
          await _dio.get("https://restcountries.com/v3.1/alpha/$code");
      if (response.data is List && (response.data as List).isNotEmpty) {
        final country =
            (response.data as List).first as Map<String, dynamic>;
        final name = country["name"]?["common"]?.toString().trim();
        if (name != null && name.isNotEmpty) return name;
      }
    } catch (_) {}
    final map = await _loadCodeMap();
    return map[code] ?? code;
  }
}
