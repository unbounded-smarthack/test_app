import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class GeolocationRecord {
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final DateTime timestamp;

  GeolocationRecord({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.timestamp,
  });
}

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  List<GeolocationRecord> geolocationRecords = [];
  bool isTracking = false;
  double distance = 0;
  double elevationGain = 0;
  double elevationLoss = 0;

  // Get Every 1 second geolocation
  // Add to geolocationRecords
  void start() {
    setState(() {
      isTracking = !isTracking;
    });
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (isTracking) {
          _getGeolocation();
      };
    });
  }

  void _getGeolocation() {
    setState(() {
      Location().getLocation().then((value) {
        GeolocationRecord currentLocation = GeolocationRecord(
          latitude: value.latitude,
          longitude: value.longitude,
          altitude: value.altitude,
          timestamp: DateTime.now(),
        );
        if (geolocationRecords.isEmpty) {
          geolocationRecords.add(currentLocation);
          return;
        }
        GeolocationRecord previousLocation = geolocationRecords.last;
        if (previousLocation.latitude != null &&
            previousLocation.longitude != null &&
            currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          double newDistance = Geolocator.distanceBetween(
            previousLocation.latitude!,
            previousLocation.longitude!,
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          if (newDistance < 20) return;

          distance += newDistance;
          geolocationRecords.add(currentLocation);
        }

        if (previousLocation.altitude == null ||
            currentLocation.altitude == null) {
          return;
        }
        if (previousLocation.altitude! > currentLocation.altitude!) {
          elevationLoss += previousLocation.altitude! - currentLocation.altitude!;
        } else {
          elevationGain += currentLocation.altitude! - previousLocation.altitude!;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
          child: Column(
            children: [
              TextButton(
                onPressed: start,
                child: Text(isTracking ? "Stop" : "Start", style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              Text("Distance: ${distance.round()}", style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              Text("Elevation Gain: ${elevationGain.round()}", style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              Text("Elevation Loss: ${elevationLoss.round()}", style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              Expanded(
                child: ListView.builder(
                  itemCount: geolocationRecords.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          "Lat: ${geolocationRecords[index].latitude} Long: ${geolocationRecords[index].longitude} Alt: ${geolocationRecords[index].altitude}"),
                      subtitle: Text(
                          "Timestamp: ${geolocationRecords[index].timestamp}"),
                    );
                  },
                ),
              ),
            ],
          ));
  }
}
