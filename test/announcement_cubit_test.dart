import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shecan/features/shecan/data/models/announcement/announcement_model.dart';
import 'package:shecan/features/shecan/domain/entities/announcement/announcement_entity.dart';
import 'package:shecan/features/shecan/domain/usecases/announcement/announcement_usecases.dart';
import 'package:shecan/features/shecan/presentation/announcement/cubit/announcement_cubit.dart';
import 'package:shecan/features/shecan/presentation/announcement/cubit/announcement_state.dart';

// Mock classes
class MockGetAnnouncementsUseCase extends Mock
    implements GetAnnouncementsUseCase {}

class MockGetNewAnnouncementsUseCase extends Mock
    implements GetNewAnnouncementsUseCase {}

class MockGetAnnouncementByIdUseCase extends Mock
    implements GetAnnouncementByIdUseCase {}

class MockMarkAnnouncementAsReadUseCase extends Mock
    implements MarkAnnouncementAsReadUseCase {}

class MockMarkAllAnnouncementsAsReadUseCase extends Mock
    implements MarkAllAnnouncementsAsReadUseCase {}

class MockGetUnreadCountUseCase extends Mock implements GetUnreadCountUseCase {}

class MockGetAnnouncementsByTypeUseCase extends Mock
    implements GetAnnouncementsByTypeUseCase {}

class MockGetAnnouncementsByPriorityUseCase extends Mock
    implements GetAnnouncementsByPriorityUseCase {}

void main() {
  group('AnnouncementCubit', () {
    late AnnouncementCubit cubit;
    late MockGetAnnouncementsUseCase mockGetAnnouncementsUseCase;
    late MockGetNewAnnouncementsUseCase mockGetNewAnnouncementsUseCase;
    late MockGetAnnouncementByIdUseCase mockGetAnnouncementByIdUseCase;
    late MockMarkAnnouncementAsReadUseCase mockMarkAnnouncementAsReadUseCase;
    late MockMarkAllAnnouncementsAsReadUseCase
    mockMarkAllAnnouncementsAsReadUseCase;
    late MockGetUnreadCountUseCase mockGetUnreadCountUseCase;
    late MockGetAnnouncementsByTypeUseCase mockGetAnnouncementsByTypeUseCase;
    late MockGetAnnouncementsByPriorityUseCase
    mockGetAnnouncementsByPriorityUseCase;

    // Test data
    final testAnnouncements = [
      AnnouncementEntity(
        id: '1',
        title: 'Test Announcement 1',
        message: 'Test message 1',
        createdAt: DateTime.now(),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      ),
      AnnouncementEntity(
        id: '2',
        title: 'Test Announcement 2',
        message: 'Test message 2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isNew: false,
        iconName: 'star',
        colorHex: '#FFC107',
        type: AnnouncementType.achievement,
        priority: AnnouncementPriority.medium,
      ),
    ];

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(AnnouncementType.feature);
      registerFallbackValue(AnnouncementPriority.medium);
    });

    setUp(() {
      mockGetAnnouncementsUseCase = MockGetAnnouncementsUseCase();
      mockGetNewAnnouncementsUseCase = MockGetNewAnnouncementsUseCase();
      mockGetAnnouncementByIdUseCase = MockGetAnnouncementByIdUseCase();
      mockMarkAnnouncementAsReadUseCase = MockMarkAnnouncementAsReadUseCase();
      mockMarkAllAnnouncementsAsReadUseCase =
          MockMarkAllAnnouncementsAsReadUseCase();
      mockGetUnreadCountUseCase = MockGetUnreadCountUseCase();
      mockGetAnnouncementsByTypeUseCase = MockGetAnnouncementsByTypeUseCase();
      mockGetAnnouncementsByPriorityUseCase =
          MockGetAnnouncementsByPriorityUseCase();

      cubit = AnnouncementCubit(
        getAnnouncementsUseCase: mockGetAnnouncementsUseCase,
        getNewAnnouncementsUseCase: mockGetNewAnnouncementsUseCase,
        getAnnouncementByIdUseCase: mockGetAnnouncementByIdUseCase,
        markAnnouncementAsReadUseCase: mockMarkAnnouncementAsReadUseCase,
        markAllAnnouncementsAsReadUseCase:
            mockMarkAllAnnouncementsAsReadUseCase,
        getUnreadCountUseCase: mockGetUnreadCountUseCase,
        getAnnouncementsByTypeUseCase: mockGetAnnouncementsByTypeUseCase,
        getAnnouncementsByPriorityUseCase:
            mockGetAnnouncementsByPriorityUseCase,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is AnnouncementInitial', () {
      expect(cubit.state, const AnnouncementInitial());
    });

    group('loadAnnouncements', () {
      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementLoading, AnnouncementLoaded] when successful',
        build: () {
          when(
            () => mockGetAnnouncementsUseCase.call(),
          ).thenAnswer((_) async => testAnnouncements);
          when(
            () => mockGetUnreadCountUseCase.call(),
          ).thenAnswer((_) async => 1);
          return cubit;
        },
        act: (cubit) => cubit.loadAnnouncements(),
        expect: () => [
          const AnnouncementLoading(),
          AnnouncementLoaded(announcements: testAnnouncements, unreadCount: 1),
        ],
        verify: (_) {
          verify(() => mockGetAnnouncementsUseCase.call()).called(1);
          verify(() => mockGetUnreadCountUseCase.call()).called(1);
        },
      );

      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementLoading, AnnouncementError] when fails',
        build: () {
          when(
            () => mockGetAnnouncementsUseCase.call(),
          ).thenThrow(Exception('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.loadAnnouncements(),
        expect: () => [
          const AnnouncementLoading(),
          const AnnouncementError(message: 'Exception: Network error'),
        ],
      );
    });

    group('refreshAnnouncements', () {
      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementRefreshing, AnnouncementLoaded] when refreshing from loaded state',
        build: () {
          when(
            () => mockGetAnnouncementsUseCase.call(),
          ).thenAnswer((_) async => testAnnouncements);
          when(
            () => mockGetUnreadCountUseCase.call(),
          ).thenAnswer((_) async => 1);
          return cubit;
        },
        seed: () => AnnouncementLoaded(
          announcements: testAnnouncements,
          unreadCount: 1,
        ),
        act: (cubit) => cubit.refreshAnnouncements(),
        expect: () => [
          AnnouncementRefreshing(announcements: testAnnouncements),
          AnnouncementLoaded(announcements: testAnnouncements, unreadCount: 1),
        ],
      );
    });

    group('markAsRead', () {
      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementMarkingAsRead, AnnouncementLoading, AnnouncementLoaded] when successful',
        build: () {
          when(
            () => mockMarkAnnouncementAsReadUseCase.call(any()),
          ).thenAnswer((_) async {});
          when(
            () => mockGetAnnouncementsUseCase.call(),
          ).thenAnswer((_) async => testAnnouncements);
          when(
            () => mockGetUnreadCountUseCase.call(),
          ).thenAnswer((_) async => 0);
          return cubit;
        },
        seed: () => AnnouncementLoaded(
          announcements: testAnnouncements,
          unreadCount: 1,
        ),
        act: (cubit) => cubit.markAsRead('1'),
        expect: () => [
          AnnouncementMarkingAsRead(
            announcements: testAnnouncements,
            announcementId: '1',
          ),
          const AnnouncementLoading(),
          AnnouncementLoaded(announcements: testAnnouncements, unreadCount: 0),
        ],
        verify: (_) {
          verify(() => mockMarkAnnouncementAsReadUseCase.call('1')).called(1);
        },
      );
    });

    group('markAllAsRead', () {
      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementRefreshing, AnnouncementLoading, AnnouncementLoaded] when successful',
        build: () {
          when(
            () => mockMarkAllAnnouncementsAsReadUseCase.call(),
          ).thenAnswer((_) async {});
          when(
            () => mockGetAnnouncementsUseCase.call(),
          ).thenAnswer((_) async => testAnnouncements);
          when(
            () => mockGetUnreadCountUseCase.call(),
          ).thenAnswer((_) async => 0);
          return cubit;
        },
        seed: () => AnnouncementLoaded(
          announcements: testAnnouncements,
          unreadCount: 1,
        ),
        act: (cubit) => cubit.markAllAsRead(),
        expect: () => [
          AnnouncementRefreshing(announcements: testAnnouncements),
          const AnnouncementLoading(),
          AnnouncementLoaded(announcements: testAnnouncements, unreadCount: 0),
        ],
        verify: (_) {
          verify(() => mockMarkAllAnnouncementsAsReadUseCase.call()).called(1);
        },
      );
    });

    group('filterByType', () {
      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementLoading, AnnouncementLoaded] with filtered announcements',
        build: () {
          final filteredAnnouncements = [
            testAnnouncements.first,
          ]; // Only feature type
          when(
            () => mockGetAnnouncementsByTypeUseCase.call(any()),
          ).thenAnswer((_) async => filteredAnnouncements);
          when(
            () => mockGetUnreadCountUseCase.call(),
          ).thenAnswer((_) async => 1);
          return cubit;
        },
        act: (cubit) => cubit.filterByType(AnnouncementType.feature),
        expect: () => [
          const AnnouncementLoading(),
          AnnouncementLoaded(
            announcements: [testAnnouncements.first],
            unreadCount: 1,
          ),
        ],
      );
    });

    group('filterByPriority', () {
      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementLoading, AnnouncementLoaded] with filtered announcements',
        build: () {
          final filteredAnnouncements = [
            testAnnouncements.first,
          ]; // Only high priority
          when(
            () => mockGetAnnouncementsByPriorityUseCase.call(any()),
          ).thenAnswer((_) async => filteredAnnouncements);
          when(
            () => mockGetUnreadCountUseCase.call(),
          ).thenAnswer((_) async => 1);
          return cubit;
        },
        act: (cubit) => cubit.filterByPriority(AnnouncementPriority.high),
        expect: () => [
          const AnnouncementLoading(),
          AnnouncementLoaded(
            announcements: [testAnnouncements.first],
            unreadCount: 1,
          ),
        ],
      );
    });

    group('loadNewAnnouncements', () {
      blocTest<AnnouncementCubit, AnnouncementState>(
        'emits [AnnouncementLoading, AnnouncementLoaded] with only new announcements',
        build: () {
          final newAnnouncements = [
            testAnnouncements.first,
          ]; // Only new announcements
          when(
            () => mockGetNewAnnouncementsUseCase.call(),
          ).thenAnswer((_) async => newAnnouncements);
          when(
            () => mockGetUnreadCountUseCase.call(),
          ).thenAnswer((_) async => 1);
          return cubit;
        },
        act: (cubit) => cubit.loadNewAnnouncements(),
        expect: () => [
          const AnnouncementLoading(),
          AnnouncementLoaded(
            announcements: [testAnnouncements.first],
            unreadCount: 1,
          ),
        ],
      );
    });

    group('getAnnouncementById', () {
      test('returns announcement when found', () async {
        when(
          () => mockGetAnnouncementByIdUseCase.call('1'),
        ).thenAnswer((_) async => testAnnouncements.first);

        final result = await cubit.getAnnouncementById('1');

        expect(result, testAnnouncements.first);
        verify(() => mockGetAnnouncementByIdUseCase.call('1')).called(1);
      });

      test('returns null when not found', () async {
        when(
          () => mockGetAnnouncementByIdUseCase.call('999'),
        ).thenAnswer((_) async => null);

        final result = await cubit.getAnnouncementById('999');

        expect(result, isNull);
      });

      test('returns null when exception occurs', () async {
        when(
          () => mockGetAnnouncementByIdUseCase.call('1'),
        ).thenThrow(Exception('Not found'));

        final result = await cubit.getAnnouncementById('1');

        expect(result, isNull);
      });
    });

    test('reset emits AnnouncementInitial', () {
      cubit.emit(
        AnnouncementLoaded(announcements: testAnnouncements, unreadCount: 1),
      );

      cubit.reset();

      expect(cubit.state, const AnnouncementInitial());
    });
  });

  group('AnnouncementEntity', () {
    test('should create entity from model correctly', () {
      final model = AnnouncementModel(
        id: '1',
        title: 'Test',
        message: 'Test message',
        createdAt: DateTime.now(),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      );

      final entity = AnnouncementEntity.fromModel(model);

      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.message, model.message);
      expect(entity.isNew, model.isNew);
      expect(entity.type, model.type);
      expect(entity.priority, model.priority);
    });

    test('should convert entity to model correctly', () {
      final entity = AnnouncementEntity(
        id: '1',
        title: 'Test',
        message: 'Test message',
        createdAt: DateTime.now(),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      );

      final model = entity.toModel();

      expect(model.id, entity.id);
      expect(model.title, entity.title);
      expect(model.message, entity.message);
      expect(model.isNew, entity.isNew);
      expect(model.type, entity.type);
      expect(model.priority, entity.priority);
    });

    test('should create copy with updated values', () {
      final original = AnnouncementEntity(
        id: '1',
        title: 'Original',
        message: 'Original message',
        createdAt: DateTime.now(),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      );

      final updated = original.copyWith(title: 'Updated', isNew: false);

      expect(updated.title, 'Updated');
      expect(updated.isNew, false);
      expect(updated.message, 'Original message'); // Should remain unchanged
      expect(updated.id, '1'); // Should remain unchanged
    });

    test('should have correct equality behavior', () {
      final entity1 = AnnouncementEntity(
        id: '1',
        title: 'Test',
        message: 'Test message',
        createdAt: DateTime.now(),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      );

      final entity2 = AnnouncementEntity(
        id: '1',
        title: 'Different Title',
        message: 'Different message',
        createdAt: DateTime.now(),
        isNew: false,
        iconName: 'star',
        colorHex: '#FFC107',
        type: AnnouncementType.achievement,
        priority: AnnouncementPriority.low,
      );

      final entity3 = AnnouncementEntity(
        id: '2',
        title: 'Test',
        message: 'Test message',
        createdAt: DateTime.now(),
        isNew: true,
        iconName: 'share',
        colorHex: '#2196F3',
        type: AnnouncementType.feature,
        priority: AnnouncementPriority.high,
      );

      expect(entity1, entity2); // Same ID
      expect(entity1, isNot(entity3)); // Different ID
      expect(entity1.hashCode, entity2.hashCode); // Same hash for same ID
    });
  });
}
