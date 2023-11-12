import 'dart:convert';

import 'package:http/http.dart' as http;

import '../const.dart';

class Activity {
  double distance;
  double elevationGain;
  double elevationLoss;
  int? duration;

  Activity({
    required this.distance,
    required this.elevationGain,
    required this.elevationLoss,
    this.duration,
  });
}

class ActivitiesService {
  Future getActivities() async {
    return [];
    // return http.get(Uri.parse("${API_URL}/api/activities/"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       // Authorization
    //       'Authorization': 'Token ${TOKEN}'
    //     }).then((value) => {
    //       if (value.statusCode == 200)
    //         {
    //           List<Activity> activities = [];
    //           for (var activity in jsonDecode(value.body))
    //             {
    //               activities.add(Activity(
    //                 distance: activity["distance"],
    //                 elevationGain: activity["elevation_gain"],
    //                 elevationLoss: activity["elevation_loss"],
    //                 duration: activity["duration"],
    //               ))
    //             };
    //           return activities;
    //         }
    //       else
    //         {
    //           throw Exception("Failed to load activities");
    //         }
    //     });
  }
}