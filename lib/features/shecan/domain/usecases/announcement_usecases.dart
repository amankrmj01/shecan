import '../../data/models/announcement/announcement_model.dart';
import '../entities/announcement_entity.dart';
import '../repositories/announcement/announcement_repository.dart';

class GetAnnouncementsUseCase {
  final AnnouncementRepository repository;

  GetAnnouncementsUseCase({required this.repository});

  Future<List<AnnouncementEntity>> call() async {
    final models = await repository.getAnnouncements();
    return models.map((model) => AnnouncementEntity.fromModel(model)).toList();
  }
}

class GetNewAnnouncementsUseCase {
  final AnnouncementRepository repository;

  GetNewAnnouncementsUseCase({required this.repository});

  Future<List<AnnouncementEntity>> call() async {
    final models = await repository.getNewAnnouncements();
    return models.map((model) => AnnouncementEntity.fromModel(model)).toList();
  }
}

class GetAnnouncementByIdUseCase {
  final AnnouncementRepository repository;

  GetAnnouncementByIdUseCase({required this.repository});

  Future<AnnouncementEntity?> call(String id) async {
    final model = await repository.getAnnouncementById(id);
    return model != null ? AnnouncementEntity.fromModel(model) : null;
  }
}

class MarkAnnouncementAsReadUseCase {
  final AnnouncementRepository repository;

  MarkAnnouncementAsReadUseCase({required this.repository});

  Future<void> call(String id) async {
    await repository.markAnnouncementAsRead(id);
  }
}

class MarkAllAnnouncementsAsReadUseCase {
  final AnnouncementRepository repository;

  MarkAllAnnouncementsAsReadUseCase({required this.repository});

  Future<void> call() async {
    await repository.markAllAnnouncementsAsRead();
  }
}

class GetUnreadCountUseCase {
  final AnnouncementRepository repository;

  GetUnreadCountUseCase({required this.repository});

  Future<int> call() async {
    return await repository.getUnreadCount();
  }
}

class GetAnnouncementsByTypeUseCase {
  final AnnouncementRepository repository;

  GetAnnouncementsByTypeUseCase({required this.repository});

  Future<List<AnnouncementEntity>> call(AnnouncementType type) async {
    final models = await repository.getAnnouncements();
    final filteredModels = models.where((model) => model.type == type).toList();
    return filteredModels
        .map((model) => AnnouncementEntity.fromModel(model))
        .toList();
  }
}

class GetAnnouncementsByPriorityUseCase {
  final AnnouncementRepository repository;

  GetAnnouncementsByPriorityUseCase({required this.repository});

  Future<List<AnnouncementEntity>> call(AnnouncementPriority priority) async {
    final models = await repository.getAnnouncements();
    final filteredModels = models
        .where((model) => model.priority == priority)
        .toList();
    return filteredModels
        .map((model) => AnnouncementEntity.fromModel(model))
        .toList();
  }
}
