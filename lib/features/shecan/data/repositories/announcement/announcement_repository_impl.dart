import '../../datasources/announcement/announcement_data_source.dart';
import '../../models/announcement/announcement_model.dart';
import '../../../domain/repositories/announcement/announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementDataSource localDataSource;
  final AnnouncementDataSource? remoteDataSource;

  AnnouncementRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      // Try to fetch from remote first, fallback to local
      if (remoteDataSource != null) {
        return await remoteDataSource!.getAnnouncements();
      }
      return await localDataSource.getAnnouncements();
    } catch (e) {
      // If remote fails, use local data source
      return await localDataSource.getAnnouncements();
    }
  }

  @override
  Future<List<AnnouncementModel>> getNewAnnouncements() async {
    try {
      if (remoteDataSource != null) {
        return await remoteDataSource!.getNewAnnouncements();
      }
      return await localDataSource.getNewAnnouncements();
    } catch (e) {
      return await localDataSource.getNewAnnouncements();
    }
  }

  @override
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    try {
      if (remoteDataSource != null) {
        return await remoteDataSource!.getAnnouncementById(id);
      }
      return await localDataSource.getAnnouncementById(id);
    } catch (e) {
      return await localDataSource.getAnnouncementById(id);
    }
  }

  @override
  Future<void> markAnnouncementAsRead(String id) async {
    try {
      // Try to update remote first
      if (remoteDataSource != null) {
        await remoteDataSource!.markAnnouncementAsRead(id);
      }
      // Always update local
      await localDataSource.markAnnouncementAsRead(id);
    } catch (e) {
      // If remote fails, still update local
      await localDataSource.markAnnouncementAsRead(id);
    }
  }

  @override
  Future<void> markAllAnnouncementsAsRead() async {
    try {
      if (remoteDataSource != null) {
        await remoteDataSource!.markAllAnnouncementsAsRead();
      }
      await localDataSource.markAllAnnouncementsAsRead();
    } catch (e) {
      await localDataSource.markAllAnnouncementsAsRead();
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final announcements = await getNewAnnouncements();
      return announcements.length;
    } catch (e) {
      return 0;
    }
  }
}
