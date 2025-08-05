import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _donationController;
  late Animation<double> _donationAnimation;
  final int targetDonationAmount = 5000;
  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _donationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Create the animation that goes from 1 to target amount
    _donationAnimation =
        Tween<double>(begin: 1.0, end: targetDonationAmount.toDouble()).animate(
          CurvedAnimation(parent: _donationController, curve: Curves.easeInOut),
        );

    // Start the animation when the screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _donationController.forward();
    });
  }

  @override
  void dispose() {
    _donationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Welcome Card
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          // Stats Grid
          _buildStatsGrid(),
          const SizedBox(height: 20),
          // Rewards Section
          _buildRewardsSection(),
          const SizedBox(height: 20),
          // Share Referral Section
          _buildShareReferralSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Alex!',
              style: TextStyle(
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

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          title: 'Referral Code',
          value: 'alex2025',
          icon: Icons.qr_code_2_rounded,
          color: Colors.orangeAccent,
        ),
        _buildAnimatedDonationCard(),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha((0.15 * 255).toInt()),
              child: Icon(icon, color: color, size: 28),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDonationCard() {
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
              child: Icon(
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
              animation: _donationAnimation,
              builder: (context, child) {
                return Text(
                  '₹${_donationAnimation.value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
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
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    );
  }

  Widget _buildShareReferralSection() {
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
                    onTap: () => _showQRCodeDialog(),
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
                          const Text(
                            'alex2025',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _shareReferralCode(),
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

  void _shareReferralCode() {
    const String referralCode = 'alex2025';
    const String shareText =
        '🎉 Join me on Shecan and start making a difference! '
        'Use my referral code: $referralCode '
        'to get started. Together we can create positive impact! '
        '\n\nDownload the app now and let\'s change the world together! 💪';

    SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: 'Join me on Shecan - Referral Code: $referralCode',
      ),
    );
  }

  void _showQRCodeDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder:
          (
            BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation,
          ) {
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
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: RepaintBoundary(
                          key: _qrKey,
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: QrImageView(
                              data: 'https://shecan.app/referral/alex2025',
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
                            Navigator.of(context).pop();
                            _shareQRCode();
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

  Future<void> _shareQRCode() async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preparing QR code for sharing...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Capture the QR code as image
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Get temporary directory
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName =
            'qr_code_alex2025_${DateTime.now().millisecondsSinceEpoch}.png';
        final File file = await File(
          '${tempDir.path}/$fileName',
        ).writeAsBytes(pngBytes);

        const String referralCode = 'alex2025';
        const String appUrl = 'https://shecan.app/referral/alex2025';
        const String shareText =
            '🎉 Scan to join the team and spreading happiness!\n\n'
            'Use my referral code: $referralCode\n'
            'Or visit: $appUrl\n\n'
            'Together we can create positive impact!\n'
            'Download the Shecan app and let\'s change the world together! 💪';

        // Share the image file along with text
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: shareText,
            subject: 'Join my team - Scan QR Code or use: $referralCode',
          ),
        );
      }
    } catch (e) {
      // Fallback to text-only sharing if image capture fails
      const String referralCode = 'alex2025';
      const String appUrl = 'https://shecan.app/referral/alex2025';
      const String shareText =
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
}
