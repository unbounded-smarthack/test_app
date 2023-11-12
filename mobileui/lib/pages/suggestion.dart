import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileui/services/profileService.dart';

import '../services/suggestionService.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  List<Trail> trails = [];

  void _getSuggestedTrails() {
    setState(() {
      SuggestionService().getTrails().then((value) {
        value.forEach((element) {
          trails.add(element);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getSuggestedTrails();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            "Suggestions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
            Container(
              child: FutureBuilder(
                future: ProfileService().getProfileDetails(),
                builder: (BuildContext context, AsyncSnapshot<ProfileDetails> snapshot) {
                  if(snapshot.hasData) {
                    return Text(
                      "Your current XP: ${snapshot.data!.experience}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const Text(
                      "Loading...",
                      textAlign: TextAlign.center,
                    );
                  }
                }
              )
            ),
            Expanded(
            child: FutureBuilder(
              future: SuggestionService().getTrails(),
              builder: (BuildContext context, AsyncSnapshot<List<Trail>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
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
                                        snapshot.data![index].trailname,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data![index].distance.toString()} km',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        )
                                      ),
                                    ]
                                  )
                                ),
                                Text(
                                  '${snapshot.data![index].experience.toString()} XP',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  )
                                )
                              ]
                            )
                          )

                      );
                    },
                  );
                } else {
                  return const Text(
                    "Loading...",
                    textAlign: TextAlign.center,
                  );
                }
              },
            )
          )
        ],
      ),
    );
  }
}
