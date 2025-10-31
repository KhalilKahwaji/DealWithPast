// Achievement-style success dialog after creating a mission
// Shows mission summary with sharing options

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionSuccessDialog extends StatelessWidget {
  final String missionTitle;
  final String location;
  final String period;
  final int missionId;

  const MissionSuccessDialog({
    Key? key,
    required this.missionTitle,
    required this.location,
    required this.period,
    required this.missionId,
  }) : super(key: key);

  String _buildDeepLink() {
    // Deep link format: https://dwp.world/mission/{id}
    // Will open app if installed, otherwise web
    return 'https://dwp.world/mission/$missionId';
  }

  String _buildShareMessage() {
    // Personal & descriptive message (Question 3 - Option B)
    return 'I created a mission to collect stories about "$missionTitle" from $period.\nShare your memories with us!\nDownload DealWithPast: ${_buildDeepLink()}';
  }

  Future<void> _shareToWhatsApp(BuildContext context) async {
    final message = Uri.encodeComponent(_buildShareMessage());
    final url = 'whatsapp://send?text=$message';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        if (context.mounted) Navigator.pop(context);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('WhatsApp not installed')),
          );
        }
      }
    } catch (e) {
      print('Error sharing to WhatsApp: $e');
    }
  }

  Future<void> _shareToFacebook(BuildContext context) async {
    final link = Uri.encodeComponent(_buildDeepLink());
    final url = 'https://www.facebook.com/sharer/sharer.php?u=$link';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        if (context.mounted) Navigator.pop(context);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open Facebook')),
          );
        }
      }
    } catch (e) {
      print('Error sharing to Facebook: $e');
    }
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _buildDeepLink()));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link copied to clipboard'),
          backgroundColor: Color(0xFF5A7C59),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _nativeShare(BuildContext context) async {
    // Using url_launcher as fallback - you can replace with share_plus package
    final message = _buildShareMessage();
    await Clipboard.setData(ClipboardData(text: message));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message copied - paste to share anywhere'),
          backgroundColor: Color(0xFF5A7C59),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A7C59).withOpacity(0.1),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Achievement Badge
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5A7C59),
                    Color(0xFF8B5A5A),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF5A7C59).withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.emoji_events,
                size: 50,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 24),

            // Success Message
            Text(
              'Mission Created Successfully!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: Color(0xFF3A3534),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16),

            // Mission Title
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFF5F0E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                missionTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Tajawal',
                  color: Color(0xFF3A3534),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 12),

            // Location & Period (one line)
            Text(
              '$location | $period',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Tajawal',
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 28),

            // Share prompt
            Text(
              'Share your mission to start collecting stories!',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Tajawal',
                color: Color(0xFF3A3534),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 20),

            // Share Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // WhatsApp
                _buildShareButton(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: Color(0xFF25D366),
                  onTap: () => _shareToWhatsApp(context),
                ),

                // Facebook
                _buildShareButton(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  color: Color(0xFF1877F2),
                  onTap: () => _shareToFacebook(context),
                ),

                // Copy Link
                _buildShareButton(
                  icon: Icons.link,
                  label: 'Copy',
                  color: Color(0xFF8B5A5A),
                  onTap: () => _copyLink(context),
                ),

                // Native Share
                _buildShareButton(
                  icon: Icons.share,
                  label: 'Share',
                  color: Color(0xFF5A7C59),
                  onTap: () => _nativeShare(context),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Close button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Tajawal',
                color: Color(0xFF3A3534),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Static method to show the dialog
  static Future<void> show(
    BuildContext context, {
    required String missionTitle,
    required String location,
    required String period,
    required int missionId,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MissionSuccessDialog(
        missionTitle: missionTitle,
        location: location,
        period: period,
        missionId: missionId,
      ),
    );
  }
}
