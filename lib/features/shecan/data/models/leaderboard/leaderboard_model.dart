import '../../../domain/entities/leaderboard/leaderboard_entity.dart';

class LeaderboardModel {
  final String name;
  final int score;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardModel({
    required this.name,
    required this.score,
    required this.rank,
    this.isCurrentUser = false,
  });

  LeaderboardEntity toEntity() {
    return LeaderboardEntity(
      id: rank.toString(),
      name: name,
      avatar: 'https://via.placeholder.com/50',
      points: score,
      rank: rank,
      isCurrentUser: isCurrentUser,
    );
  }

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      name: json['name'] as String,
      score: json['score'] as int,
      rank: json['rank'] as int,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'rank': rank,
      'isCurrentUser': isCurrentUser,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardModel &&
        other.name == name &&
        other.score == score &&
        other.rank == rank &&
        other.isCurrentUser == isCurrentUser;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        score.hashCode ^
        rank.hashCode ^
        isCurrentUser.hashCode;
  }

  @override
  String toString() {
    return 'LeaderboardModel(name: $name, score: $score, rank: $rank, isCurrentUser: $isCurrentUser)';
  }
}
