// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CelebrationPopup extends StatefulWidget {
  final String title;
  final String message;
  final String? badgeIcon;
  final int? points;
  final Color accentColor;
  final VoidCallback? onDismiss;

  const CelebrationPopup({
    Key? key,
    required this.title,
    required this.message,
    this.badgeIcon,
    this.points,
    this.accentColor = const Color(0xFF5A7C59),
    this.onDismiss,
  }) : super(key: key);

  @override
  State<CelebrationPopup> createState() => _CelebrationPopupState();

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? badgeIcon,
    int? points,
    Color accentColor = const Color(0xFF5A7C59),
    VoidCallback? onDismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationPopup(
        title: title,
        message: message,
        badgeIcon: badgeIcon,
        points: points,
        accentColor: accentColor,
        onDismiss: onDismiss,
      ),
    );
  }
}

class _CelebrationPopupState extends State<CelebrationPopup>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Confetti controller
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    // Animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    // Auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _dismiss() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onDismiss?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 3.14 / 2, // Down
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.1,
            shouldLoop: false,
            colors: [
              Color(0xFF5A7C59),
              Color(0xFFD4AF37),
              Color(0xFF8B5A5A),
              Color(0xFFE8A99C),
            ],
          ),
        ),

        // Dialog
        Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0E8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge/Icon
                      if (widget.badgeIcon != null)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: widget.accentColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.badgeIcon!,
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.celebration,
                          size: 80,
                          color: widget.accentColor,
                        ),

                      const SizedBox(height: 20),

                      // Title
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: Color(0xFF3A3534),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      // Message
                      Text(
                        widget.message,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      // Points (if any)
                      if (widget.points != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFD4AF37).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Color(0xFFD4AF37), width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Color(0xFFD4AF37), size: 24),
                              SizedBox(width: 8),
                              Text(
                                '+${widget.points} نقطة',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                  color: Color(0xFFD4AF37),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 25),

                      // Close button
                      TextButton(
                        onPressed: _dismiss,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          backgroundColor: widget.accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          'رائع!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
