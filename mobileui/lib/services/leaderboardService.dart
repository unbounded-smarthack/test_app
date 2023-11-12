//class to handle leaderboard service
//should have a getLeaderboard method that returns the list of all users:

class LeaderboardService {
  Future<List<User>> getLeaderboard() async {
        User user1 = User(
          firstName: "John",
          lastName: "Doe",
          experience: 100,
        );

        User user2 = User(
          firstName: "Jane",
          lastName: "Doe",
          experience: 200,
        );

        User user3 = User(
          firstName: "John",
          lastName: "Smith",
          experience: 300,
        );

        User user4 = User(
          firstName: "Jane",
          lastName: "Smith",
          experience: 400,
        );

        User user5 = User(
          firstName: "John",
          lastName: "Doe",
          experience: 500,
        );

        return [user1, user2, user3, user4, user5];
    }
  }

class User {
  final String firstName;
  final String lastName;
  int experience;

  User({
    required this.firstName,
    required this.lastName,
    required this.experience,
  });
}