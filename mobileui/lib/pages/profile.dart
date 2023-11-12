import 'package:flutter/material.dart';
import '../services/profileService.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: ProfileService().getProfileDetails(),
              builder: (BuildContext context, AsyncSnapshot<ProfileDetails> snapshot) {
                if (snapshot.hasData) {
                  // Display user details
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue, // Add your desired color
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text("Username: ${snapshot.data!.username}"),
                      const SizedBox(height: 10),
                      Text(
                        "${snapshot.data!.experience} XP",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Display a loading indicator
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
