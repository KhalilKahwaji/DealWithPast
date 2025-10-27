import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interactive_map/Homepages/home_page.dart';
import 'package:interactive_map/Map/map.dart';
import 'package:interactive_map/Gallery/Gallery.dart';
import 'package:interactive_map/widgets/app_bottom_nav.dart';
import 'package:interactive_map/Missions/missions.dart';
import 'package:interactive_map/profilePage.dart' show Profile;
import 'package:interactive_map/Repos/UserRepo.dart';
import 'package:interactive_map/services/NotificationService.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key); // SDK-safe

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Get JWT token using current user's credentials
        final userRepo = UserRepo();
        final email = currentUser.email?.split('@')[0] ?? '';
        final uid = currentUser.uid;

        final token = await userRepo.AuthenticateOther(email, uid);

        if (token != false && token != null) {
          // Start notification polling service
          final notificationService = NotificationService();
          notificationService.startPolling(
            token: token.toString(),
            intervalSeconds: 60, // Poll every 60 seconds
          );

          print('✅ Notification polling started');
        }
      }
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  @override
  void dispose() {
    // Stop polling when leaving the page
    NotificationService().stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <TabSpec>[
      TabSpec(
        id: AppTab.home,
        icon: Icons.home_outlined,
        title: "الرئيسية",
        builder: (goTo, indexOf) => HomePage(goTo: goTo),
      ),
      TabSpec(
        id: AppTab.map,
        icon: Icons.map_outlined,
        title: "الخريطة",
        builder: (goTo, indexOf) => const MapPage(),
      ),
      TabSpec(
        id: AppTab.gallery,
        icon: Icons.photo_library_outlined,
        title: "القصص",
        builder: (goTo, indexOf) => const Gallery(),
      ),
      TabSpec(
        id: AppTab.missions,
        icon: Icons.emoji_events_outlined,
        title: "المهام",
        builder: (goTo, indexOf) => const MissionsPage(),
      ),
      TabSpec(
        id: AppTab.profile,
        icon: Icons.person_outline,
        title: "الملف",
        builder: (goTo, indexOf) => Profile(null),
      ),
    ];

    return AppBottomNavScaffold(
      tabs: tabs,
      initialTab: AppTab.home,
    );
  }
}
