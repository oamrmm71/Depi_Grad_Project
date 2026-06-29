import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageService {
  final Dio _dio = Dio();

  static final String _apiKey = dotenv.env["UNSPLASH_KEY"]!;
  static const String _fallbackImage =
      "https://images.unsplash.com/photo-1507525428034-b723cf961d3e";

  Future<String> getPlaceImage({
    required String cityName,
    required String countryName,
  }) async {
    final query = countryName.isNotEmpty ? "$cityName $countryName" : cityName;
    try {
      final response = await _dio.get(
        "https://api.unsplash.com/search/photos",
        queryParameters: {
          "query": query,
          "client_id": _apiKey,
          "per_page": 1,
        },
      );
      final results = response.data["results"];
      if (results != null && (results as List).isNotEmpty) {
        return results.first["urls"]["regular"] as String;
      }
    } catch (_) {}
    return _fallbackImage;
  }
}
