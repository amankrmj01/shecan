import 'package:equatable/equatable.dart';
import '../../../domain/entities/announcement_entity.dart';

abstract class AnnouncementState extends Equatable {
  const AnnouncementState();

  @override
  List<Object?> get props => [];
}

class AnnouncementInitial extends AnnouncementState {
  const AnnouncementInitial();
}

class AnnouncementLoading extends AnnouncementState {
  const AnnouncementLoading();
}

class AnnouncementLoaded extends AnnouncementState {
  final List<AnnouncementEntity> announcements;
  final int unreadCount;

  const AnnouncementLoaded({
    required this.announcements,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [announcements, unreadCount];

  AnnouncementLoaded copyWith({
    List<AnnouncementEntity>? announcements,
    int? unreadCount,
  }) {
    return AnnouncementLoaded(
      announcements: announcements ?? this.announcements,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class AnnouncementError extends AnnouncementState {
  final String message;

  const AnnouncementError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AnnouncementMarkingAsRead extends AnnouncementState {
  final List<AnnouncementEntity> announcements;
  final String announcementId;

  const AnnouncementMarkingAsRead({
    required this.announcements,
    required this.announcementId,
  });

  @override
  List<Object?> get props => [announcements, announcementId];
}

class AnnouncementRefreshing extends AnnouncementState {
  final List<AnnouncementEntity> announcements;

  const AnnouncementRefreshing({required this.announcements});

  @override
  List<Object?> get props => [announcements];
}
