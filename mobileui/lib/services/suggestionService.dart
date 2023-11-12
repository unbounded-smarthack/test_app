//class to handle suggestion service

class SuggestionService {

  Future<int> getXp() async {
    return 891;
  }

  Future<List<Trail>> getTrails() async {
  Trail trail1 = Trail(
    trailname: "Trail 1",
    distance: 1.0,
    elevationGain: 1.0,
    elevationLoss: 1.0,
    experience: 1,
    estimatedDuration: 1,
  );

  Trail trail2 = Trail(
    trailname: "Trail 2",
    distance: 2.0,
    elevationGain: 2.0,
    elevationLoss: 2.0,
    experience: 2,
    estimatedDuration: 2,
  );

  Trail trail3 = Trail(
    trailname: "Trail 3",
    distance: 3.0,
    elevationGain: 3.0,
    elevationLoss: 3.0,
    experience: 3,
    estimatedDuration: 3,
  );

  Trail trail4 = Trail(
    trailname: "Trail 4",
    distance: 4.0,
    elevationGain: 4.0,
    elevationLoss: 4.0,
    experience: 4,
    estimatedDuration: 4,
  );

  return [trail1, trail2, trail3, trail4];
  }
}

class Trail {
  final String trailname;
  final double distance;
  final double elevationGain;
  final double elevationLoss;
  final int experience;
  final int estimatedDuration;

  Trail({
    required this.trailname,
    required this.distance,
    required this.elevationGain,
    required this.elevationLoss,
    required this.experience,
    required this.estimatedDuration,
  });
}
