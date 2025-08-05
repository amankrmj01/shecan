class UserEntity {
  final String id;
  final String name;
  final String avatar;
  final int points;
  final String email;
  final String password;

  const UserEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.points,
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.points == points &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, avatar, points, email, password);
  }
}
