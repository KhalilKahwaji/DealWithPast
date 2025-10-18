import 'package:flutter/material.dart';
import 'package:interactive_map/Homepages/home_page.dart';
import 'package:interactive_map/Map/map.dart';
import 'package:interactive_map/Gallery/Gallery.dart';
import 'package:interactive_map/widgets/app_bottom_nav.dart';
import 'package:interactive_map/Missions/missions.dart';
import 'package:interactive_map/profilePage.dart' show Profile;

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key); // SDK-safe

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
