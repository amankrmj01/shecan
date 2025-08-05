import '../data/models/announcement/announcement_model.dart';
import '../domain/repositories/announcement/announcement_repository.dart';

class AnnouncementService {
  final AnnouncementRepository _repository;

  AnnouncementService(this._repository);

  Future<List<AnnouncementModel>> getAllAnnouncements() async {
    return await _repository.getAnnouncements();
  }

  Future<List<AnnouncementModel>> getNewAnnouncements() async {
    return await _repository.getNewAnnouncements();
  }

  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    return await _repository.getAnnouncementById(id);
  }

  Future<void> markAsRead(String id) async {
    await _repository.markAnnouncementAsRead(id);
  }

  Future<void> markAllAsRead() async {
    await _repository.markAllAnnouncementsAsRead();
  }

  Future<int> getUnreadCount() async {
    return await _repository.getUnreadCount();
  }

  Future<List<AnnouncementModel>> getAnnouncementsByType(
    AnnouncementType type,
  ) async {
    final announcements = await getAllAnnouncements();
    return announcements
        .where((announcement) => announcement.type == type)
        .toList();
  }

  Future<List<AnnouncementModel>> getAnnouncementsByPriority(
    AnnouncementPriority priority,
  ) async {
    final announcements = await getAllAnnouncements();
    return announcements
        .where((announcement) => announcement.priority == priority)
        .toList();
  }

  Future<List<AnnouncementModel>> getUrgentAnnouncements() async {
    return await getAnnouncementsByPriority(AnnouncementPriority.urgent);
  }
}
