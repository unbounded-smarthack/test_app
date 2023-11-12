import 'package:flutter/material.dart';
import 'package:mobileui/services/activities_service.dart';

import '../services/profileService.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Activity> activities = [
    Activity(distance: 16.5, elevationGain: 167, elevationLoss: 120, duration: 240),
    Activity(distance: 12.3, elevationGain: 124, elevationLoss: 187, duration: 160),
  ];

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
          Expanded(child: Column(
            children: [
              Text("Activities",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child:
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${activities[index].distance.toString()} km',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${activities[index].duration.toString()} min',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      )
                                    ),
                                  ]
                                )
                              ),
                              Text(
                                '${activities[index].elevationGain.toString()} m',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                )
                              )
                            ]
                          )
                        )
                    );
                  },
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
