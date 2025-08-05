import '../../../data/models/announcement/announcement_model.dart';

abstract class AnnouncementRepository {
  Future<List<AnnouncementModel>> getAnnouncements();

  Future<List<AnnouncementModel>> getNewAnnouncements();

  Future<AnnouncementModel?> getAnnouncementById(String id);

  Future<void> markAnnouncementAsRead(String id);

  Future<void> markAllAnnouncementsAsRead();

  Future<int> getUnreadCount();
}
