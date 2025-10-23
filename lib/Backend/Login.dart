// lib/Backend/Login.dart
import 'dart:async';                           // TimeoutException
import 'package:flutter/foundation.dart';      // debugPrint
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException, User;

import 'auth.dart';
import 'package:interactive_map/Homepages/mainPage.dart'; // WelcomePage

class LoginPage extends StatefulWidget {
  final void Function(BuildContext, User)? onSuccess;
  const LoginPage({Key? key, this.onSuccess}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _busy = false;

  Future<void> _click() async {
    debugPrint('[LOGIN] click: user tapped Google login');
    if (mounted) setState(() => _busy = true);

    try {
      final user = await signInWithGoogle();
      if (user == null) {
        debugPrint('[LOGIN] cancelled / no user');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إلغاء تسجيل الدخول')),
          );
        }
        return;
      }

      debugPrint('[LOGIN] Firebase user OK: uid=${user.uid}, email=${user.email}');

      if (!mounted) return;
      if (widget.onSuccess != null) {
        widget.onSuccess!(context, user);
      } else {
        // Default: go to your main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('[LOGIN][FirebaseAuthException] ${e.code} ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل تسجيل الدخول: ${e.code}')),
        );
      }
    } on TimeoutException {
      debugPrint('[LOGIN][Timeout]');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('انتهت المهلة. تحقق من الاتصال.')),
        );
      }
    } catch (e) {
      debugPrint('[LOGIN][Exception] $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ غير متوقع')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تسجيل الدخول')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: _busy ? null : _click,
                    icon: const Icon(Icons.login),
                    label: const Text('تسجيل الدخول باستخدام Google'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'سنستخدم حساب Google للتحقق من الهوية ثم نربطه بحسابك على المنصة.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            if (_busy)
              Container(
                color: Colors.black.withOpacity(0.15),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 42, height: 42,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Legacy helper if other code still calls a top-level `click(context)`.
Future<void> click(BuildContext context) async {
  final state = context.findAncestorStateOfType<_LoginPageState>();
  if (state != null) {
    await state._click();
    return;
  }
  try {
    final user = await signInWithGoogle();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إلغاء تسجيل الدخول')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('فشل تسجيل الدخول: ${e.code}')),
    );
  } on TimeoutException {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('انتهت المهلة. تحقق من الاتصال.')),
    );
  } catch (_) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('حدث خطأ غير متوقع')),
    );
  }
}
