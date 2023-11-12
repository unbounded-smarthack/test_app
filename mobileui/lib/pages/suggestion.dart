import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            "Suggestion",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          FutureBuilder(
              future: SuggestionService().getXp(),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.hasData) {
                  return Text("Your current XP is: ${snapshot.data} ");
                } else {
                  return const Text(
                    "Loading...",
                    textAlign: TextAlign.center,
                  );
                }
              }),
        ],
      ),
    );
  }
}
