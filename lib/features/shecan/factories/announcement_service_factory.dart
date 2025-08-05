import 'package:http/http.dart' as http;
import '../data/datasources/announcement/announcement_local_data_source.dart';
import '../data/datasources/announcement/announcement_remote_data_source.dart';
import '../data/repositories/announcement/announcement_repository_impl.dart';
import '../services/announcement_service.dart';

class AnnouncementServiceFactory {
  static AnnouncementService createWithLocalDataSource() {
    final localDataSource = AnnouncementLocalDataSource();
    final repository = AnnouncementRepositoryImpl(
      localDataSource: localDataSource,
    );
    return AnnouncementService(repository);
  }

  static AnnouncementService createWithRemoteDataSource({
    required String baseUrl,
    http.Client? httpClient,
  }) {
    final localDataSource = AnnouncementLocalDataSource();
    final remoteDataSource = AnnouncementRemoteDataSource(
      client: httpClient ?? http.Client(),
      baseUrl: baseUrl,
    );
    final repository = AnnouncementRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
    return AnnouncementService(repository);
  }

  static AnnouncementService createHybrid({
    required String baseUrl,
    http.Client? httpClient,
  }) {
    // This creates a service that uses remote data with local fallback
    return createWithRemoteDataSource(baseUrl: baseUrl, httpClient: httpClient);
  }
}
