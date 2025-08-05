import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/announcement/announcement_model.dart';
import '../../../domain/entities/announcement_entity.dart';
import '../../../domain/usecases/announcement_usecases.dart';
import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final GetAnnouncementsUseCase getAnnouncementsUseCase;
  final GetNewAnnouncementsUseCase getNewAnnouncementsUseCase;
  final GetAnnouncementByIdUseCase getAnnouncementByIdUseCase;
  final MarkAnnouncementAsReadUseCase markAnnouncementAsReadUseCase;
  final MarkAllAnnouncementsAsReadUseCase markAllAnnouncementsAsReadUseCase;
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final GetAnnouncementsByTypeUseCase getAnnouncementsByTypeUseCase;
  final GetAnnouncementsByPriorityUseCase getAnnouncementsByPriorityUseCase;

  AnnouncementCubit({
    required this.getAnnouncementsUseCase,
    required this.getNewAnnouncementsUseCase,
    required this.getAnnouncementByIdUseCase,
    required this.markAnnouncementAsReadUseCase,
    required this.markAllAnnouncementsAsReadUseCase,
    required this.getUnreadCountUseCase,
    required this.getAnnouncementsByTypeUseCase,
    required this.getAnnouncementsByPriorityUseCase,
  }) : super(const AnnouncementInitial());

  Future<void> loadAnnouncements() async {
    try {
      emit(const AnnouncementLoading());

      final announcements = await getAnnouncementsUseCase();
      final unreadCount = await getUnreadCountUseCase();

      emit(
        AnnouncementLoaded(
          announcements: announcements,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> refreshAnnouncements() async {
    try {
      // Show refreshing state with current data
      if (state is AnnouncementLoaded) {
        final currentState = state as AnnouncementLoaded;
        emit(AnnouncementRefreshing(announcements: currentState.announcements));
      }

      final announcements = await getAnnouncementsUseCase();
      final unreadCount = await getUnreadCountUseCase();

      emit(
        AnnouncementLoaded(
          announcements: announcements,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> markAsRead(String announcementId) async {
    try {
      if (state is AnnouncementLoaded) {
        final currentState = state as AnnouncementLoaded;
        emit(
          AnnouncementMarkingAsRead(
            announcements: currentState.announcements,
            announcementId: announcementId,
          ),
        );
      }

      await markAnnouncementAsReadUseCase(announcementId);

      // Reload announcements to reflect the change
      await loadAnnouncements();
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      if (state is AnnouncementLoaded) {
        final currentState = state as AnnouncementLoaded;
        emit(AnnouncementRefreshing(announcements: currentState.announcements));
      }

      await markAllAnnouncementsAsReadUseCase();

      // Reload announcements to reflect the change
      await loadAnnouncements();
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> filterByType(AnnouncementType type) async {
    try {
      emit(const AnnouncementLoading());

      final announcements = await getAnnouncementsByTypeUseCase(type);
      final unreadCount = await getUnreadCountUseCase();

      emit(
        AnnouncementLoaded(
          announcements: announcements,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> filterByPriority(AnnouncementPriority priority) async {
    try {
      emit(const AnnouncementLoading());

      final announcements = await getAnnouncementsByPriorityUseCase(priority);
      final unreadCount = await getUnreadCountUseCase();

      emit(
        AnnouncementLoaded(
          announcements: announcements,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<void> loadNewAnnouncements() async {
    try {
      emit(const AnnouncementLoading());

      final newAnnouncements = await getNewAnnouncementsUseCase();
      final unreadCount = await getUnreadCountUseCase();

      emit(
        AnnouncementLoaded(
          announcements: newAnnouncements,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(AnnouncementError(message: e.toString()));
    }
  }

  Future<AnnouncementEntity?> getAnnouncementById(String id) async {
    try {
      return await getAnnouncementByIdUseCase(id);
    } catch (e) {
      return null;
    }
  }

  void reset() {
    emit(const AnnouncementInitial());
  }
}
