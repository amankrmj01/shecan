// lib/features/dashboard/presentation/screens/dashboard_screen.dart

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'cubit/dashboard_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit()..loadDashboardData(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        actions: [
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                return IconButton(
                  icon: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.deepPurple,
                    child: ClipOval(
                      child: Image.network(
                        state.userAvatarUrl,
                        width: 32,
                        height: 32,
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
                  onPressed: () => _showUserMenu(context),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildWelcomeCard(state.userName),
                const SizedBox(height: 20),
                _buildStatsGrid(state.referralCode, state.userScore),
                const SizedBox(height: 20),
                _buildRewardsSection(),
                const SizedBox(height: 20),
                _buildShareReferralSection(
                  context,
                  state.userName,
                  state.referralCode,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildWelcomeCard(String userName) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $userName!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep up the great work.',
              style: TextStyle(fontSize: 16, color: Colors.deepPurple[100]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(String referralCode, int donationAmount) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          title: 'Referral Code',
          value: referralCode,
          icon: Icons.qr_code_2_rounded,
          color: Colors.orangeAccent,
          onTap: () => _showQRCodeDialog(context, 'SheCan User', referralCode),
        ),
        _AnimatedDonationCard(donationAmount: donationAmount),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.15 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Rewards',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRewardCard(
                icon: Icons.star_rounded,
                label: 'Top Performer',
                unlocked: true,
              ),
              _buildRewardCard(
                icon: Icons.emoji_events_rounded,
                label: '₹10k Club',
                unlocked: false,
              ),
              _buildRewardCard(
                icon: Icons.local_fire_department_rounded,
                label: 'Streak Master',
                unlocked: false,
              ),
              _buildRewardCard(
                icon: Icons.group_add_rounded,
                label: 'Team Player',
                unlocked: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardCard({
    required IconData icon,
    required String label,
    required bool unlocked,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => _showRewardSnackbar(label, unlocked),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: unlocked ? Colors.white : Colors.grey[200],
          elevation: unlocked ? 2 : 0,
          child: Opacity(
            opacity: unlocked ? 1.0 : 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: unlocked ? Colors.amber : Colors.grey[500],
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: unlocked ? Colors.black87 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareReferralSection(
    BuildContext context,
    String userName,
    String referralCode,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.share, color: Colors.blue[600], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Share Referral',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Invite friends and earn rewards! Share your referral code with others.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        _showQRCodeDialog(context, userName, referralCode),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.qr_code_2,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              referralCode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _shareReferralCode(referralCode),
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareReferralCode(String referralCode) {
    const String shareText =
        '🎉 Join me on Shecan and start making a difference! '
        'Use my referral code: %s '
        'to get started. Together we can create positive impact! '
        '\n\nDownload the app now and let\'s change the world together! 💪';

    SharePlus.instance.share(
      ShareParams(
        text: shareText.replaceFirst('%s', referralCode),
        subject: 'Join me on Shecan - Referral Code: $referralCode',
      ),
    );
  }

  void _showQRCodeDialog(
    BuildContext context,
    String userName,
    String referralCode,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Scan to join the team and spreading happiness',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: RepaintBoundary(
                      key: _qrKey,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: QrImageView(
                          data: 'https://shecan.app/referral/$referralCode',
                          version: QrVersions.auto,
                          size: 200.0,
                          gapless: true,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _shareQRCode(userName, referralCode);
                      },
                      icon: const Icon(Icons.share, size: 20),
                      label: const Text('Share this QR code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  Future<void> _shareQRCode(String userName, String referralCode) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preparing QR code for sharing...'),
          duration: Duration(seconds: 1),
        ),
      );

      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName =
            'qr_code_${referralCode}_${DateTime.now().millisecondsSinceEpoch}.png';
        final File file = await File(
          '${tempDir.path}/$fileName',
        ).writeAsBytes(pngBytes);

        final String appUrl = 'https://shecan.app/referral/$referralCode';
        final String shareText =
            '🎉 Scan to join the team and spreading happiness!\n\n'
            'Use my referral code: $referralCode\n'
            'Or visit: $appUrl\n\n'
            'Together we can create positive impact!\n'
            'Download the Shecan app and let\'s change the world together! 💪';

        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: shareText,
            subject: 'Join my team - Scan QR Code or use: $referralCode',
          ),
        );
      }
    } catch (e) {
      final String appUrl = 'https://shecan.app/referral/$referralCode';
      final String shareText =
          '🎉 Scan to join the team and spreading happiness!\n\n'
          'Use my referral code: $referralCode\n'
          'Visit: $appUrl\n\n'
          'Together we can create positive impact!\n'
          'Download the Shecan app and let\'s change the world together! 💪';

      await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: 'Join my team - Referral Code: $referralCode',
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shared referral link as text'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showUserMenu(BuildContext context) {
    context.goNamed('profile');
  }

  void _showRewardSnackbar(String label, bool unlocked) {
    String message;
    switch (label) {
      case 'Top Performer':
        message = unlocked
            ? 'You earned this for being a top performer in donations and referrals.'
            : 'Reach ₹15,000 in donations and refer 10+ friends to unlock.';
        break;
      case '₹10k Club':
        message = unlocked
            ? 'You earned this for raising over ₹10,000 in donations.'
            : 'Raise ₹10,000 or more in total donations to unlock.';
        break;
      case 'Streak Master':
        message = unlocked
            ? 'You earned this for maintaining daily activity streaks.'
            : 'Maintain a 30-day daily login and activity streak to unlock.';
        break;
      case 'Team Player':
        message = unlocked
            ? 'You earned this for excellent teamwork and collaboration.'
            : 'Successfully collaborate on 5 team projects to unlock.';
        break;
      default:
        message = unlocked
            ? 'You have earned this reward for your outstanding contribution.'
            : 'Keep working towards your goals to unlock!';
    }

    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      snackBarAnimationStyle: AnimationStyle(
        curve: Curves.elasticOut,
        duration: const Duration(milliseconds: 800),
        reverseCurve: Curves.easeInBack,
        reverseDuration: const Duration(milliseconds: 300),
      ),
      SnackBar(
        content: Row(
          children: [
            Icon(
              unlocked ? Icons.check_circle : Icons.info_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: unlocked ? Colors.green[600] : Colors.orange[600],
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// Separate StatefulWidget for the animated card to manage its own state.
class _AnimatedDonationCard extends StatefulWidget {
  final int donationAmount;

  const _AnimatedDonationCard({required this.donationAmount});

  @override
  _AnimatedDonationCardState createState() => _AnimatedDonationCardState();
}

class _AnimatedDonationCardState extends State<_AnimatedDonationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: widget.donationAmount.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withAlpha((0.15 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.volunteer_activism_rounded,
                color: Colors.teal,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Donations Raised',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Text(
                  '₹${_animation.value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
