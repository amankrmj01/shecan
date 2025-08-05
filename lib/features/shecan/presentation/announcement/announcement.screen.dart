import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../data/models/announcement/announcement_model.dart';
import '../../domain/entities/announcement/announcement_entity.dart';
import 'cubit/announcement_cubit.dart';
import 'cubit/announcement_state.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnnouncementCubit>()..loadAnnouncements(),
      child: const _AnnouncementView(),
    );
  }
}

class _AnnouncementView extends StatelessWidget {
  const _AnnouncementView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        actions: [
          BlocBuilder<AnnouncementCubit, AnnouncementState>(
            builder: (context, state) {
              if (state is AnnouncementLoaded && state.unreadCount > 0) {
                return IconButton(
                  icon: Badge(
                    label: Text('${state.unreadCount}'),
                    child: const Icon(Icons.mark_email_read),
                  ),
                  onPressed: () =>
                      context.read<AnnouncementCubit>().markAllAsRead(),
                  tooltip: 'Mark all as read',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<AnnouncementCubit>().refreshAnnouncements(),
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) => _handleFilter(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Announcements'),
              ),
              const PopupMenuItem(value: 'new', child: Text('New Only')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'urgent',
                child: Text('Urgent Priority'),
              ),
              const PopupMenuItem(value: 'high', child: Text('High Priority')),
              const PopupMenuItem(
                value: 'medium',
                child: Text('Medium Priority'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'feature', child: Text('Features')),
              const PopupMenuItem(
                value: 'maintenance',
                child: Text('Maintenance'),
              ),
              const PopupMenuItem(
                value: 'achievement',
                child: Text('Achievements'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<AnnouncementCubit, AnnouncementState>(
        listener: (context, state) {
          if (state is AnnouncementError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () =>
                      context.read<AnnouncementCubit>().loadAnnouncements(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AnnouncementInitial || state is AnnouncementLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AnnouncementError) {
            return _buildErrorState(context, state.message);
          }

          if (state is AnnouncementLoaded) {
            return _buildLoadedState(context, state);
          }

          if (state is AnnouncementRefreshing) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<AnnouncementCubit>().refreshAnnouncements(),
              child: _buildAnnouncementsList(
                context,
                state.announcements,
                isRefreshing: true,
              ),
            );
          }

          if (state is AnnouncementMarkingAsRead) {
            return _buildAnnouncementsList(
              context,
              state.announcements,
              markingAsReadId: state.announcementId,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleFilter(BuildContext context, String filter) {
    final cubit = context.read<AnnouncementCubit>();

    switch (filter) {
      case 'all':
        cubit.loadAnnouncements();
        break;
      case 'new':
        cubit.loadNewAnnouncements();
        break;
      case 'urgent':
        cubit.filterByPriority(AnnouncementPriority.urgent);
        break;
      case 'high':
        cubit.filterByPriority(AnnouncementPriority.high);
        break;
      case 'medium':
        cubit.filterByPriority(AnnouncementPriority.medium);
        break;
      case 'feature':
        cubit.filterByType(AnnouncementType.feature);
        break;
      case 'maintenance':
        cubit.filterByType(AnnouncementType.maintenance);
        break;
      case 'achievement':
        cubit.filterByType(AnnouncementType.achievement);
        break;
    }
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<AnnouncementCubit>().loadAnnouncements(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, AnnouncementLoaded state) {
    if (state.announcements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No announcements yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for updates',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<AnnouncementCubit>().refreshAnnouncements(),
      child: _buildAnnouncementsList(context, state.announcements),
    );
  }

  Widget _buildAnnouncementsList(
    BuildContext context,
    List<AnnouncementEntity> announcements, {
    bool isRefreshing = false,
    String? markingAsReadId,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        final isMarkingThisAsRead = markingAsReadId == announcement.id;

        return Column(
          children: [
            _buildAnnouncementCard(
              context,
              announcement,
              isMarkingAsRead: isMarkingThisAsRead,
            ),
            if (index < announcements.length - 1) const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context,
    AnnouncementEntity announcement, {
    bool isMarkingAsRead = false,
  }) {
    // Convert entity to model for UI helpers
    final model = announcement.toModel();

    return GestureDetector(
      onTap: () {
        if (announcement.isNew && !isMarkingAsRead) {
          context.read<AnnouncementCubit>().markAsRead(announcement.id);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: model.color.withAlpha((0.15 * 255).toInt()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(model.icon, color: model.color, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    announcement.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (announcement.isNew)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  model.timeAgo,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(
                                      announcement.priority,
                                    ).withAlpha(50),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    announcement.priority.value.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getPriorityColor(
                                        announcement.priority,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    announcement.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isMarkingAsRead)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(AnnouncementPriority priority) {
    switch (priority) {
      case AnnouncementPriority.urgent:
        return Colors.red;
      case AnnouncementPriority.high:
        return Colors.orange;
      case AnnouncementPriority.medium:
        return Colors.blue;
      case AnnouncementPriority.low:
        return Colors.grey;
    }
  }
}
