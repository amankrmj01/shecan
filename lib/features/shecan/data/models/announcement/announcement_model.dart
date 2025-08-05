import 'package:flutter/material.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isNew;
  final String iconName;
  final String colorHex;
  final AnnouncementType type;
  final AnnouncementPriority priority;

  const AnnouncementModel({
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

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isNew: json['is_new'] as bool? ?? false,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      type: AnnouncementType.fromString(json['type'] as String),
      priority: AnnouncementPriority.fromString(json['priority'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'is_new': isNew,
      'icon_name': iconName,
      'color_hex': colorHex,
      'type': type.value,
      'priority': priority.value,
    };
  }

  // Helper methods to get UI components
  IconData get icon {
    switch (iconName) {
      case 'share':
        return Icons.share;
      case 'leaderboard':
        return Icons.leaderboard;
      case 'build':
        return Icons.build;
      case 'star':
        return Icons.star;
      case 'notification':
        return Icons.notifications;
      case 'update':
        return Icons.update;
      case 'security':
        return Icons.security;
      case 'gift':
        return Icons.card_giftcard;
      default:
        return Icons.announcement;
    }
  }

  Color get color {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    }
  }

  AnnouncementModel copyWith({
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
    return AnnouncementModel(
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
}

enum AnnouncementType {
  feature('feature'),
  maintenance('maintenance'),
  update('update'),
  achievement('achievement'),
  promotion('promotion'),
  system('system');

  const AnnouncementType(this.value);

  final String value;

  static AnnouncementType fromString(String value) {
    return AnnouncementType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AnnouncementType.system,
    );
  }
}

enum AnnouncementPriority {
  low('low'),
  medium('medium'),
  high('high'),
  urgent('urgent');

  const AnnouncementPriority(this.value);

  final String value;

  static AnnouncementPriority fromString(String value) {
    return AnnouncementPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => AnnouncementPriority.medium,
    );
  }
}
