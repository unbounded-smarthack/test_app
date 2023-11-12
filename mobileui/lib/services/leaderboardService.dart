//class to handle leaderboard service
//should have a getLeaderboard method that returns the list of all users:

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../const.dart';

class LeaderboardService {
  Future<List<User>> getLeaderboard() async {
    return http.get(Uri.parse("${API_URL}/api/leaderboard/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Authorization
          'Authorization': 'Token ${TOKEN}'
        },
       ).then((value) {
          List<User> users = [];
          if (value.statusCode == 200) {
            var data = jsonDecode(value.body);
            for (var i = 0; i < data.length; i++) {
              users.add(User(
                first_name: data[i]['first_name'],
                last_name: data[i]['last_name'],
                experience: data[i]['experience_gained'] ?? 0,
              ));
            }
          }
          print(users);
          return users;
        });
  }
}

class User {
  final String first_name;
  final String last_name;
  int experience;

  User({
    required this.first_name,
    required this.last_name,
    required this.experience,
  });
}