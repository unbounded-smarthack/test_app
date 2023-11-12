//class to handle profile service
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../const.dart';


class ProfileService {
Future<ProfileDetails> getProfileDetails() async {
    return http.get(Uri.parse("${API_URL}/api/user/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Authorization
          'Authorization': 'Token ${TOKEN}'
        },
        ).then((value) {
          print(value);
          if (value.statusCode == 200) {
            var data = jsonDecode(value.body);
            print(data['username']);
            return ProfileDetails(
              id: data['id'],
              username: data['username'],
              email: data['email'],
              first_name: data['first_name'],
              last_name: data['last_name'],
              experience: data['experience'],
            );
          }
          else {
            print("Error");
          }
          return ProfileDetails(
            id: 0,
            username: "",
            email: "",
            first_name: "",
            last_name: "",
            experience: 0,
          );
        });
  }

}

class ProfileDetails {
  int? id;
  String username;
  String email;
  String first_name;
  String last_name;
  int? experience;

  ProfileDetails({
    required this.id,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
    this.experience,
  });
}