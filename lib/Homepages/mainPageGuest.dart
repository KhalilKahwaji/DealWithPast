import 'package:flutter/material.dart';
import 'package:interactive_map/Gallery/Gallery.dart';
import 'package:interactive_map/My%20Stories/addStoryGuest.dart';
import 'package:interactive_map/Timeline/timeline.dart';
import 'package:interactive_map/ContactUs.dart';
import 'package:interactive_map/Map/map.dart';
import 'package:interactive_map/Homepages/home_page.dart';
import 'package:interactive_map/widgets/app_bottom_nav.dart';

class WelcomePageGuest extends StatelessWidget {
  const WelcomePageGuest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // RTL: first entry renders on the RIGHT (Home)
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
        builder: (goTo, indexOf) => const MapPage(),
      ),
      TabSpec(
        id: AppTab.gallery,
        icon: Icons.photo_library_outlined,
        title: "عرض الروايات",
        builder: (goTo, indexOf) => const Gallery(),
      ),
      TabSpec(
        id: AppTab.timeline,
        icon: Icons.timeline,
        title: "الجدول الزمني",
        builder: (goTo, indexOf) => const Timeline(),
      ),
      TabSpec(
        id: AppTab.addStory,
        icon: Icons.edit_outlined,
        title: "أضف رواية",
        builder: (goTo, indexOf) => AddStoryGuest(),
      ),
      TabSpec(
        id: AppTab.contact,
        icon: Icons.contact_page,
        title: "تواصل معنا",
        builder: (goTo, indexOf) => const ContactUs(),
      ),
    ];

    return AppBottomNavScaffold(
      tabs: tabs,
      initialTab: AppTab.home, // show Home (far right)
    );
  }
}
