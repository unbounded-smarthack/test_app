//class to handle suggestion service
import '../const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuggestionService {

  Future<int> getXp() async {
    return 891;
  }

  Future<List<Trail>> getTrails() async {
    return http.get(Uri.parse("${API_URL}/api/suggestions/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Authorization
          'Authorization': 'Token ${TOKEN}'
        },
        ).then((value) {
          List<Trail> trails = [];
          if (value.statusCode == 200) {
            var data = jsonDecode(value.body);
            for (var i = 0; i < data.length; i++) {
              trails.add(Trail(
                trailname: data[i]['name'],
                distance: data[i]['distance'],
                elevationGain: data[i]['elevation_gain'],
                elevationLoss: data[i]['elevation_loss'],
                experience: data[i]['recommended_experience'],
                estimatedDuration: data[i]['estimated_duration'],
              ));
            }
          }
          print(trails);
          return trails;
        });
  }
}

class Trail {
  final String trailname;
  final double distance;
  final int elevationGain;
  final int elevationLoss;
  final int experience;
  final int estimatedDuration;

  Trail({
    required this.trailname,
    required this.distance,
    required this.elevationGain,
    required this.elevationLoss,
    required this.experience,
    required this.estimatedDuration,
  });
}
