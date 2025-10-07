import 'package:flutter/material.dart';
import 'package:interactive_map/Gallery/Gallery.dart';
import 'package:interactive_map/Timeline/timeline.dart';
import 'package:interactive_map/ContactUs.dart';
import 'package:interactive_map/Map/map.dart';
import 'package:interactive_map/profilePage.dart' show Profile;
import 'package:interactive_map/Homepages/home_page.dart';
import 'package:interactive_map/widgets/app_bottom_nav.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
        title: "الخارطه",
        builder: (goTo, indexOf) => MapPage(),
      ),
      TabSpec(
        id: AppTab.gallery,
        icon: Icons.photo_library_outlined,
        title: "عرض الروايات",
        builder: (goTo, indexOf) => Gallery(),
      ),
      TabSpec(
        id: AppTab.timeline,
        icon: Icons.timeline,
        title: "الجدول الزمني",
        builder: (goTo, indexOf) => Timeline(),
      ),
      TabSpec(
        id: AppTab.profile,
        icon: Icons.person,
        title: "الحساب الشخصي",
        builder: (goTo, indexOf) => Profile(null),
      ),
      TabSpec(
        id: AppTab.contact,
        icon: Icons.contact_support,
        title: "تواصل معنا",
        builder: (goTo, indexOf) => ContactUs(),
      ),
    ];

    return AppBottomNavScaffold(
      tabs: tabs,
      initialTab: AppTab.home, // show Home (far right)
    );
  }
}
