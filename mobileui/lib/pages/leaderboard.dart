import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/leaderboardService.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<User> usersLeaderboard = [];

  //get leaderboard using service:
  void _getLeaderboard() {
    setState(() {
      LeaderboardService().getLeaderboard().then((value) {
        usersLeaderboard = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          TextButton(
            onPressed: _getLeaderboard,
            child: const Text("Get Leaderboard"),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemBuilder: usersLeaderboard.isEmpty
                  ? (context, index) => const ListTile(title: Text("No data"))
                  : (context, index) =>
                  ListTile(
                    title: Text(usersLeaderboard[index].firstName.toString()),
                  ),
              itemCount: usersLeaderboard.length,
            ),
          ),
        ],
      ),
    );
  }
}