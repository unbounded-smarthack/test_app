import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../components/elevation_chart.dart';
import '../services/tracking_service.dart';

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
  DateTime? startTracking = null;
  DateTime? currentTimestamp = null;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  double distance = 0;
  double elevationGain = 0;
  double elevationLoss = 0;
  bool finished = false;
  bool isLoading = false;
  int? xp = null;

  // Get Every 1 second geolocation
  // Add to geolocationRecords
  void start() {
    setState(() {
      startTracking = DateTime.now();
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTimestamp = DateTime.now();
        if (startTracking == null) {
          return;
        }
        int difference = currentTimestamp!.difference(startTracking!).inSeconds;
        hours = difference ~/ 3600;
        minutes = (difference - hours * 3600) ~/ 60;
        seconds = difference - hours * 3600 - minutes * 60;
      });
      if (startTracking != null) {
        _getGeolocation();
      }
    });
  }

  // Stop getting geolocation
  void stop() {
    setState(() {
      isLoading = true;
    });
    TrackingService().registerActivity(
        distance, elevationGain, elevationLoss, currentTimestamp?.difference(startTracking!).inMinutes
    ).then((value) {
        setState(() {
          isLoading = false;
        });
        if (value.statusCode == 201) {
          setState(() {
            finished = true;
            startTracking = null;
            xp = jsonDecode(value.body);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error'),
            ),
          );
        }
      });
    setState(() {

      isLoading = true;
    });
  }

  void reset() {
    setState(() {
      finished = false;
      hours = 0;
      minutes = 0;
      seconds = 0;
      distance = 0;
      elevationGain = 0;
      elevationLoss = 0;
      geolocationRecords = [];
    });
  }

  void _getGeolocation() {
    setState(() {
      Location().getLocation().then((value) {
        GeolocationRecord currentLocation = GeolocationRecord(
          latitude: value.latitude,
          longitude: value.longitude,
          altitude: (100 + Random().nextInt(10) - 3).toDouble(),
          timestamp: DateTime.now(),
        );
        if (geolocationRecords.isEmpty) {
          geolocationRecords.add(currentLocation);
          return;
        }
        GeolocationRecord previousLocation = geolocationRecords.last;
        double newDistance = Geolocator.distanceBetween(
          previousLocation.latitude!,
          previousLocation.longitude!,
          currentLocation.latitude!,
          currentLocation.longitude!
        );

        if (newDistance < 10) return;

        distance += newDistance;
        geolocationRecords.add(currentLocation);


        if (previousLocation.altitude == null ||
            currentLocation.altitude == null) {
          return;
        }
        if (previousLocation.altitude! > currentLocation.altitude!) {
          elevationLoss +=
              previousLocation.altitude! - currentLocation.altitude!;
        } else {
          elevationGain +=
              currentLocation.altitude! - previousLocation.altitude!;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(
      child: CircularProgressIndicator(),
    ) :
    Material(
        child: startTracking != null
            ? Column(
                children: [
                  ElevationChart(
                    // set index as axis value of x axis
                    spots: geolocationRecords
                        .asMap()
                        .map((index, value) => MapEntry(
                            index,
                            FlSpot(index.toDouble() + 1,
                                value.altitude != null ? value.altitude! : 0)))
                        .values
                        .toList(),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentTimestamp != null
                                ? "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}"
                                : "00:00:00",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.hiking,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${distance.round()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.north_east,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${elevationGain.round()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(
                                Icons.south_east,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${elevationLoss.round()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: OutlinedButton(
                      onPressed: stop,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        // border color
                        side: const BorderSide(
                            width: 3, color: Colors.deepPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Finish",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: finished
                    ? Column(
                        children: [
                          const Expanded(child: SizedBox()),
                          const Text("Congratulations!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("You have finished your hike!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1,
                                fontSize: 20,
                              )),
                          // Distance
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.hiking,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${distance.round()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Elevation Gain
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.north_east,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${elevationGain.round()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Icon(
                                Icons.south_east,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${elevationLoss.round()}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // XP
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${xp ?? 0} XP",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          TextButton(
                            onPressed: reset,
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: SizedBox()),
                          Container(
                            padding: const EdgeInsets.all(30),
                            child: const Column(
                              children: [
                                Text(
                                  "Start your hike",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 30,
                                  ),
                                ),
                                Text("NOW!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 70,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          TextButton(
                            onPressed: start,
                            child: const Text(
                              "Start",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
              ));
  }
}
