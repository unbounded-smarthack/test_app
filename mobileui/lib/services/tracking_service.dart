import 'dart:convert';

import '../const.dart';
import 'package:http/http.dart' as http;

class TrackingService {
  Future registerActivity(double distance, double elevationGain, double elevationLoss, int? duration) async {
    return http.post(Uri.parse("${API_URL}/api/activities/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Authorization
          'Authorization': 'Token ${TOKEN}'
        },
        body: jsonEncode({
          "distance": distance / 1000,
          "elevation_gain": elevationGain,
          "elevation_loss": elevationLoss,
          "duration": duration ?? 0,
        }), );
  }
}