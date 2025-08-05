class LeaderboardEntity {
  final String id;
  final String name;
  final String avatar;
  final int points;
  final int rank;
  final bool isCurrentUser;

  const LeaderboardEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.points,
    required this.rank,
    required this.isCurrentUser,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaderboardEntity &&
        other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.points == points &&
        other.rank == rank &&
        other.isCurrentUser == isCurrentUser;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, avatar, points, rank, isCurrentUser);
  }
}
