import 'package:flutter/material.dart';
import 'package:mobileui/services/geolocation.dart';

class GeolocationRecord {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  GeolocationRecord({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

class TrackingPage extends StatefulWidget {
  TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  List<GeolocationRecord> geolocationRecords = [];

  // Get Every 1 second geolocation

  // Add to geolocationRecords
  void _incrementCounter() {
    setState(() {
      GeolocationService().determinePosition().then((value) {
        geolocationRecords.add(GeolocationRecord(
          latitude: value.latitude,
          longitude: value.longitude,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("test"),
      ),
      body: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: _incrementCounter,
                child: const Text("Get Geolocation"),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
        itemBuilder: geolocationRecords.isEmpty
                  ? (context, index) => const ListTile(title: Text("No data"))
                  : (context, index) => ListTile(
                        title: Text(geolocationRecords[index].latitude.toString()),
                      ),
      ),
              ),
            ],
          )),
    );
  }
}
