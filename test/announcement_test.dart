import 'package:flutter_test/flutter_test.dart';
import 'package:shecan/features/shecan/data/datasources/announcement/announcement_local_data_source.dart';
import 'package:shecan/features/shecan/data/models/announcement/announcement_model.dart';
import 'package:shecan/features/shecan/factories/announcement_service_factory.dart';

void main() {
  group('AnnouncementService Tests', () {
    // ignore: unused_local_variable
    late AnnouncementLocalDataSource localDataSource;

    setUp(() {
      localDataSource = AnnouncementLocalDataSource();
    });

    test('should load announcements from local data source', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();

      // Act
      final announcements = await service.getAllAnnouncements();

      // Assert
      expect(announcements, isNotEmpty);
      expect(announcements.length, greaterThan(0));
      expect(announcements.first, isA<AnnouncementModel>());
    });

    test('should return new announcements only', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();

      // Act
      final newAnnouncements = await service.getNewAnnouncements();
      final allAnnouncements = await service.getAllAnnouncements();

      // Assert
      expect(
        newAnnouncements.length,
        lessThanOrEqualTo(allAnnouncements.length),
      );
      for (final announcement in newAnnouncements) {
        expect(announcement.isNew, isTrue);
      }
    });

    test('should mark announcement as read', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();
      final announcements = await service.getAllAnnouncements();
      final newAnnouncement = announcements.firstWhere((a) => a.isNew);

      // Act
      await service.markAsRead(newAnnouncement.id);
      final updatedAnnouncement = await service.getAnnouncementById(
        newAnnouncement.id,
      );

      // Assert
      expect(updatedAnnouncement?.isNew, isFalse);
    });

    test('should mark all announcements as read', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();

      // Act
      await service.markAllAsRead();
      final announcements = await service.getAllAnnouncements();

      // Assert
      for (final announcement in announcements) {
        expect(announcement.isNew, isFalse);
      }
    });

    test('should get correct unread count', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();
      final newAnnouncements = await service.getNewAnnouncements();

      // Act
      final unreadCount = await service.getUnreadCount();

      // Assert
      expect(unreadCount, equals(newAnnouncements.length));
    });

    test('should filter announcements by type', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();

      // Act
      final featureAnnouncements = await service.getAnnouncementsByType(
        AnnouncementType.feature,
      );

      // Assert
      for (final announcement in featureAnnouncements) {
        expect(announcement.type, equals(AnnouncementType.feature));
      }
    });

    test('should filter announcements by priority', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();

      // Act
      final urgentAnnouncements = await service.getUrgentAnnouncements();

      // Assert
      for (final announcement in urgentAnnouncements) {
        expect(announcement.priority, equals(AnnouncementPriority.urgent));
      }
    });

    test('should return null for non-existent announcement', () async {
      // Arrange
      final service = AnnouncementServiceFactory.createWithLocalDataSource();

      // Act
      final announcement = await service.getAnnouncementById('non-existent-id');

      // Assert
      expect(announcement, isNull);
    });
  });

  group('AnnouncementModel Tests', () {
    test('should create announcement model from JSON', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Announcement',
        'message': 'Test message',
        'created_at': '2025-08-05T10:00:00.000Z',
        'is_new': true,
        'icon_name': 'share',
        'color_hex': '#2196F3',
        'type': 'feature',
        'priority': 'high',
      };

      // Act
      final announcement = AnnouncementModel.fromJson(json);

      // Assert
      expect(announcement.id, equals('1'));
      expect(announcement.title, equals('Test Announcement'));
      expect(announcement.message, equals('Test message'));
      expect(announcement.isNew, isTrue);
      expect(announcement.iconName, equals('share'));
      expect(announcement.colorHex, equals('#2196F3'));
      expect(announcement.type, equals(AnnouncementType.feature));
      expect(announcement.priority, equals(AnnouncementPriority.high));
    });

    test('should convert announcement model to JSON', () {
      // Arrange
      final announcement = AnnouncementModel(
        id: '1',
        title: 'Test Announcement',
        message: 'Test message',
        createdAt: DateTime.parse('2025-08-05T10:00:00.000Z'),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      );

      // Act
      final json = announcement.toJson();

      // Assert
      expect(json['id'], equals('1'));
      expect(json['title'], equals('Test Announcement'));
      expect(json['message'], equals('Test message'));
      expect(json['is_new'], isTrue);
      expect(json['icon_name'], equals('share'));
      expect(json['color_hex'], equals('#2196F3'));
      expect(json['type'], equals('feature'));
      expect(json['priority'], equals('high'));
    });

    test('should calculate time ago correctly', () {
      // Arrange
      final now = DateTime.now();
      final announcement = AnnouncementModel(
        id: '1',
        title: 'Test',
        message: 'Test',
        createdAt: now.subtract(const Duration(hours: 2)),
        isNew: false,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.medium,
      );

      // Act
      final timeAgo = announcement.timeAgo;

      // Assert
      expect(timeAgo, contains('hours ago'));
    });

    test('should create copy with updated values', () {
      // Arrange
      final original = AnnouncementModel(
        id: '1',
        title: 'Original Title',
        message: 'Original Message',
        createdAt: DateTime.now(),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      );

      // Act
      final updated = original.copyWith(title: 'Updated Title', isNew: false);

      // Assert
      expect(updated.title, equals('Updated Title'));
      expect(updated.isNew, isFalse);
      expect(
        updated.message,
        equals('Original Message'),
      ); // Should remain unchanged
      expect(updated.id, equals('1')); // Should remain unchanged
    });
  });
}
