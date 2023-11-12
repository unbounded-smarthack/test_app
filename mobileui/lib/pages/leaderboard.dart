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
        value.forEach((element) {
          usersLeaderboard.add(element);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Leaderboard",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: FutureBuilder(
          future: LeaderboardService().getLeaderboard(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            print(snapshot.data);
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  IconData crownIcon = Icons.person; // Default icon

                  if (index == 0) {
                    // Gold crown for the first position
                    crownIcon = Icons.star;
                  } else if (index == 1) {
                    // Silver crown for the second position
                    crownIcon = Icons.star;
                  } else if (index == 2) {
                    // Bronze crown for the third position
                    crownIcon = Icons.star;
                  }
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child:
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  crownIcon,
                                  color: (index == 0) ? Colors.yellow : (index == 1) ? Colors.grey : (index == 2) ? Colors.brown : Colors.black,
                                ),
                              ),
                            const SizedBox(width: 16.0),
                            Expanded(child: Text(
                              snapshot.data![index].first_name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            )),
                            Text(
                              '${snapshot.data![index].experience.toString()} XP',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
      ),
        ),],
    );
  }
}