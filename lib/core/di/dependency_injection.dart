import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/shecan/data/datasources/announcement/announcement_data_source.dart';
import '../../features/shecan/data/datasources/announcement/announcement_local_data_source.dart';
import '../../features/shecan/data/datasources/announcement/announcement_remote_data_source.dart';
import '../../features/shecan/data/datasources/user/user_datasource.dart';
import '../../features/shecan/data/repositories/announcement/announcement_repository_impl.dart';
import '../../features/shecan/data/repositories/user/user_repository.dart';
import '../../features/shecan/domain/repositories/announcement/announcement_repository.dart';
import '../../features/shecan/domain/repositories/user/user_repository.dart';
import '../../features/shecan/domain/usecases/announcement/announcement_usecases.dart';
import '../../features/shecan/domain/usecases/user/get_user_usecase.dart';
import '../../features/shecan/presentation/announcement/cubit/announcement_cubit.dart';
import '../../features/shecan/presentation/leaderboard/cubit/leaderboard_cubit.dart';
import '../../features/shecan/presentation/profile/cubit/user_profile_cubit.dart';
import '../../features/shecan/presentation/signup/cubit/signup_cubit.dart';
import '../../features/shecan/services/announcement_service.dart';
import '../services/theme_service.dart';
import '../services/user_session_service.dart';

final GetIt sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // External dependencies
    sl.registerLazySingleton<http.Client>(() => http.Client());

    // Data sources
    sl.registerLazySingleton<AnnouncementDataSource>(
      () => AnnouncementLocalDataSource(),
      instanceName: 'local',
    );

    // Uncomment this when you want to use remote data source
    // sl.registerLazySingleton<AnnouncementDataSource>(
    //   () => AnnouncementRemoteDataSource(
    //     client: sl<http.Client>(),
    //     baseUrl: 'https://your-api-url.com/api', // Replace with your actual API URL
    //   ),
    //   instanceName: 'remote',
    // );

    sl.registerLazySingleton<UserDataSource>(() => LocalUserDataSource());

    // Repository
    sl.registerLazySingleton<AnnouncementRepository>(
      () => AnnouncementRepositoryImpl(
        localDataSource: sl<AnnouncementDataSource>(instanceName: 'local'),
        // remoteDataSource: sl<AnnouncementDataSource>(instanceName: 'remote'), // Uncomment when using remote
      ),
    );

    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(dataSource: sl()),
    );

    // Services
    sl.registerLazySingleton<UserSessionService>(() => UserSessionService());
    sl.registerLazySingleton<ThemeService>(() => ThemeService());

    sl.registerLazySingleton<AnnouncementService>(
      () => AnnouncementService(sl<AnnouncementRepository>()),
    );

    // Use cases for Announcements
    sl.registerLazySingleton<GetAnnouncementsUseCase>(
      () => GetAnnouncementsUseCase(repository: sl()),
    );

    sl.registerLazySingleton<GetNewAnnouncementsUseCase>(
      () => GetNewAnnouncementsUseCase(repository: sl()),
    );

    sl.registerLazySingleton<GetAnnouncementByIdUseCase>(
      () => GetAnnouncementByIdUseCase(repository: sl()),
    );

    sl.registerLazySingleton<MarkAnnouncementAsReadUseCase>(
      () => MarkAnnouncementAsReadUseCase(repository: sl()),
    );

    sl.registerLazySingleton<MarkAllAnnouncementsAsReadUseCase>(
      () => MarkAllAnnouncementsAsReadUseCase(repository: sl()),
    );

    sl.registerLazySingleton<GetUnreadCountUseCase>(
      () => GetUnreadCountUseCase(repository: sl()),
    );

    sl.registerLazySingleton<GetAnnouncementsByTypeUseCase>(
      () => GetAnnouncementsByTypeUseCase(repository: sl()),
    );

    sl.registerLazySingleton<GetAnnouncementsByPriorityUseCase>(
      () => GetAnnouncementsByPriorityUseCase(repository: sl()),
    );

    // Use cases for Leaderboard
    sl.registerLazySingleton<GetUserUseCase>(
      () => GetUserUseCase(repository: sl()),
    );

    // Cubits
    sl.registerFactory<AnnouncementCubit>(
      () => AnnouncementCubit(
        getAnnouncementsUseCase: sl(),
        getNewAnnouncementsUseCase: sl(),
        getAnnouncementByIdUseCase: sl(),
        markAnnouncementAsReadUseCase: sl(),
        markAllAnnouncementsAsReadUseCase: sl(),
        getUnreadCountUseCase: sl(),
        getAnnouncementsByTypeUseCase: sl(),
        getAnnouncementsByPriorityUseCase: sl(),
      ),
    );

    sl.registerFactory<LeaderboardCubit>(
      () => LeaderboardCubit(getLeaderboardUseCase: sl()),
    );

    sl.registerFactory<SignupCubit>(() => SignupCubit(userDataSource: sl()));

    sl.registerFactory<UserProfileCubit>(
      () => UserProfileCubit(userSessionService: sl(), themeService: sl()),
    );
  }
}

Future<void> setupDependencyInjectionWithRemote(String apiBaseUrl) async {
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<AnnouncementDataSource>(
    () => AnnouncementLocalDataSource(),
    instanceName: 'local',
  );

  sl.registerLazySingleton<AnnouncementDataSource>(
    () => AnnouncementRemoteDataSource(
      client: sl<http.Client>(),
      baseUrl: apiBaseUrl,
    ),
    instanceName: 'remote',
  );

  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(
      localDataSource: sl<AnnouncementDataSource>(instanceName: 'local'),
      remoteDataSource: sl<AnnouncementDataSource>(instanceName: 'remote'),
    ),
  );

  // Services
  sl.registerLazySingleton<AnnouncementService>(
    () => AnnouncementService(sl<AnnouncementRepository>()),
  );
}

// Method to reset DI (useful for testing)
Future<void> resetDependencyInjection() async {
  await sl.reset();
}
