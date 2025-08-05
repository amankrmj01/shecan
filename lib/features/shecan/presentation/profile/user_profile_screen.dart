import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/theme_service.dart';
import 'cubit/user_profile_cubit.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserProfileCubit>()..loadUserProfile(),
      child: const _UserProfileView(),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  const _UserProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
      ),
      body: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UserProfileLoggedOut) {
            context.goNamed('login');
          }
        },
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<UserProfileCubit>().loadUserProfile(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is UserProfileLoaded) {
            return _UserProfileContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _UserProfileContent extends StatelessWidget {
  final UserProfileLoaded state;

  const _UserProfileContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserProfileCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // User Profile Card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurple[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // User Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        'https://api.dicebear.com/9.x/initials/png?seed=${Uri.encodeComponent(state.user.name)}&size=400',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    state.user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // User Email
                  Text(
                    state.user.email,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),

                  // Points Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.stars,
                          color: Colors.deepPurple,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${state.user.score} Points',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Settings Section
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Theme Setting
                  _buildSettingTile(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: _getThemeModeString(state.themeMode),
                    onTap: () => _showThemeDialog(context, cubit),
                  ),

                  const Divider(),

                  // Notifications Setting
                  _buildSettingTile(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: state.notificationsEnabled
                        ? 'Enabled'
                        : 'Disabled',
                    onTap: () => _toggleNotifications(context, cubit),
                    trailing: Switch(
                      value: state.notificationsEnabled,
                      onChanged: (value) =>
                          _toggleNotifications(context, cubit),
                      activeColor: Colors.deepPurple,
                    ),
                  ),

                  const Divider(),

                  // Privacy Setting
                  _buildSettingTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy',
                    subtitle: 'Manage your privacy settings',
                    onTap: () => _showPrivacySettings(context),
                  ),

                  const Divider(),

                  // Help & Support
                  _buildSettingTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () => _showHelpSupport(context),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleLogout(context, cubit),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getThemeModeString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light Mode';
      case AppThemeMode.dark:
        return 'Dark Mode';
      case AppThemeMode.system:
        return 'System Mode';
    }
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.deepPurple, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showThemeDialog(BuildContext context, UserProfileCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Choose Theme',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              cubit,
              'Light Mode',
              Icons.light_mode,
              AppThemeMode.light,
            ),
            _buildThemeOption(
              context,
              cubit,
              'Dark Mode',
              Icons.dark_mode,
              AppThemeMode.dark,
            ),
            _buildThemeOption(
              context,
              cubit,
              'System Mode',
              Icons.settings,
              AppThemeMode.system,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    UserProfileCubit cubit,
    String title,
    IconData icon,
    AppThemeMode mode,
  ) {
    final isSelected = (cubit.state as UserProfileLoaded).themeMode == mode;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.deepPurple : Colors.grey),
      title: Text(title),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.deepPurple)
          : null,
      onTap: () {
        cubit.updateTheme(mode);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title selected'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  void _toggleNotifications(BuildContext context, UserProfileCubit cubit) {
    cubit.toggleNotifications();
    final newState = cubit.state as UserProfileLoaded;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newState.notificationsEnabled
              ? 'Notifications enabled'
              : 'Notifications disabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings - Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support - Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleLogout(BuildContext context, UserProfileCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.logout();
              Navigator.pop(dialogContext); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
