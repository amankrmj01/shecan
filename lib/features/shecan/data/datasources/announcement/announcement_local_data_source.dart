import '../../models/announcement/announcement_model.dart';
import 'announcement_data_source.dart';

class AnnouncementLocalDataSource implements AnnouncementDataSource {
  static final List<AnnouncementModel> _mockAnnouncements = [
    AnnouncementModel(
      id: '1',
      title: 'New Feature: Referral Sharing',
      message:
          'You can now share your referral code directly from the dashboard! Earn more rewards by inviting friends.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isNew: true,
      iconName: 'share',
      colorHex: '#2196F3',
      type: AnnouncementType.feature,
      priority: AnnouncementPriority.high,
    ),
    AnnouncementModel(
      id: '2',
      title: 'Leaderboard Update',
      message:
          'Weekly user has been reset. Keep contributing to climb to the top!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isNew: false,
      iconName: 'user',
      colorHex: '#FF9800',
      type: AnnouncementType.update,
      priority: AnnouncementPriority.medium,
    ),
    AnnouncementModel(
      id: '3',
      title: 'Maintenance Notice',
      message:
          'Scheduled maintenance will occur on Sunday 3 AM - 5 AM. App may be temporarily unavailable.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isNew: false,
      iconName: 'build',
      colorHex: '#F44336',
      type: AnnouncementType.maintenance,
      priority: AnnouncementPriority.urgent,
    ),
    AnnouncementModel(
      id: '4',
      title: 'Congratulations!',
      message:
          'You\'ve reached the Top Performer badge! Keep up the excellent work.',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isNew: false,
      iconName: 'star',
      colorHex: '#FFC107',
      type: AnnouncementType.achievement,
      priority: AnnouncementPriority.medium,
    ),
    AnnouncementModel(
      id: '5',
      title: 'Security Update',
      message:
          'We\'ve enhanced our security measures to better protect your account and data.',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      isNew: false,
      iconName: 'security',
      colorHex: '#4CAF50',
      type: AnnouncementType.update,
      priority: AnnouncementPriority.high,
    ),
    AnnouncementModel(
      id: '6',
      title: 'Holiday Promotion',
      message:
          'Special holiday rewards are now available! Complete tasks to earn bonus points.',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      isNew: false,
      iconName: 'gift',
      colorHex: '#E91E63',
      type: AnnouncementType.promotion,
      priority: AnnouncementPriority.medium,
    ),
  ];

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Sort by creation date (newest first)
    final sortedAnnouncements = List<AnnouncementModel>.from(
      _mockAnnouncements,
    );
    sortedAnnouncements.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return sortedAnnouncements;
  }

  @override
  Future<List<AnnouncementModel>> getNewAnnouncements() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _mockAnnouncements
        .where((announcement) => announcement.isNew)
        .toList();
  }

  @override
  Future<AnnouncementModel?> getAnnouncementById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _mockAnnouncements.firstWhere(
        (announcement) => announcement.id == id,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> markAnnouncementAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final index = _mockAnnouncements.indexWhere(
      (announcement) => announcement.id == id,
    );
    if (index != -1) {
      _mockAnnouncements[index] = _mockAnnouncements[index].copyWith(
        isNew: false,
      );
    }
  }

  @override
  Future<void> markAllAnnouncementsAsRead() async {
    await Future.delayed(const Duration(milliseconds: 200));

    for (int i = 0; i < _mockAnnouncements.length; i++) {
      _mockAnnouncements[i] = _mockAnnouncements[i].copyWith(isNew: false);
    }
  }

  // Additional helper methods for testing and development
  Future<void> addAnnouncement(AnnouncementModel announcement) async {
    _mockAnnouncements.insert(0, announcement);
  }

  Future<void> removeAnnouncement(String id) async {
    _mockAnnouncements.removeWhere((announcement) => announcement.id == id);
  }

  Future<int> getUnreadCount() async {
    return _mockAnnouncements
        .where((announcement) => announcement.isNew)
        .length;
  }
}
