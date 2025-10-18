import 'package:flutter/material.dart';

class GuestProfilePage extends StatelessWidget {
  const GuestProfilePage({Key? key}) : super(key: key); // SDK-safe

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 64),
            const SizedBox(height: 16),
            const Text('سجّل الدخول لعرض ملفك الشخصي',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: navigate to your existing sign-in flow
                // Navigator.pushNamed(context, '/signin');
              },
              icon: const Icon(Icons.login),
              label: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}
