import '../../../data/models/announcement/announcement_model.dart';

class AnnouncementEntity {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isNew;
  final String iconName;
  final String colorHex;
  final AnnouncementType type;
  final AnnouncementPriority priority;

  const AnnouncementEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isNew,
    required this.iconName,
    required this.colorHex,
    required this.type,
    required this.priority,
  });

  // Convert from model to entity
  factory AnnouncementEntity.fromModel(AnnouncementModel model) {
    return AnnouncementEntity(
      id: model.id,
      title: model.title,
      message: model.message,
      createdAt: model.createdAt,
      isNew: model.isNew,
      iconName: model.iconName,
      colorHex: model.colorHex,
      type: model.type,
      priority: model.priority,
    );
  }

  // Convert from entity to model
  AnnouncementModel toModel() {
    return AnnouncementModel(
      id: id,
      title: title,
      message: message,
      createdAt: createdAt,
      isNew: isNew,
      iconName: iconName,
      colorHex: colorHex,
      type: type,
      priority: priority,
    );
  }

  AnnouncementEntity copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isNew,
    String? iconName,
    String? colorHex,
    AnnouncementType? type,
    AnnouncementPriority? priority,
  }) {
    return AnnouncementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isNew: isNew ?? this.isNew,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      priority: priority ?? this.priority,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnouncementEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
