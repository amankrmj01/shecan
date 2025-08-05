import '../../../domain/entities/leaderboard/leaderboard_entity.dart';

class LeaderboardModel implements Comparable<LeaderboardModel> {
  final String name;
  final int score;
  final String email;
  final String password;

  const LeaderboardModel({
    required this.name,
    required this.score,
    required this.email,
    required this.password,
  });

  LeaderboardEntity toEntity() {
    return LeaderboardEntity(
      id: name.toLowerCase().replaceAll(' ', '_'),
      // Use name as unique ID
      name: name,
      avatar: 'https://via.placeholder.com/50',
      points: score,
      email: email,
      password: password,
    );
  }

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      name: json['name'] as String,
      score: json['score'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'score': score, 'email': email, 'password': password};
  }

  // Compare function for automatic sorting by score (highest first)
  @override
  int compareTo(LeaderboardModel other) {
    // Sort by score in descending order (highest score first)
    int scoreComparison = other.score.compareTo(score);

    // If scores are equal, sort alphabetically by name
    if (scoreComparison == 0) {
      return name.compareTo(other.name);
    }

    return scoreComparison;
  }

  // Helper method to get rank based on position in sorted list
  int getRankInList(List<LeaderboardModel> sortedList) {
    return sortedList.indexOf(this) + 1;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardModel &&
        other.name == name &&
        other.score == score &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return name.hashCode ^ score.hashCode ^ email.hashCode ^ password.hashCode;
  }

  @override
  String toString() {
    return 'LeaderboardModel(name: $name, score: $score, email: $email)';
  }
}
