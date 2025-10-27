import 'package:flutter/material.dart';
import 'package:interactive_map/theme/colors.dart';
import 'NotificationBellIcon.dart';

/// Stable identifiers for tabs (use these everywhere)
enum AppTab {
  home,
  map,
  gallery,
  missions,
  profile,
}

/// One spec per tab. `builder` gets:
/// - goTo(AppTab) to jump to any tab by ID (no indices!)
/// - indexOf(AppTab) in case a child still needs the raw index.
class TabSpec {
  final AppTab id;
  final IconData icon;
  final String title;
  final Widget Function(
      void Function(AppTab) goTo, int Function(AppTab) indexOf) builder;

  const TabSpec({
    required this.id,
    required this.icon,
    required this.title,
    required this.builder,
  });
}

/// A reusable scaffold with:
/// - Light AppBar using AppColors
/// - BottomNavigationBar (first item renders on RIGHT in RTL)
/// - Overlay vertical dividers (do not break tap areas)
class AppBottomNavScaffold extends StatefulWidget {
  final List<TabSpec> tabs;
  final AppTab initialTab;

  const AppBottomNavScaffold({
    Key? key,
    required this.tabs,
    required this.initialTab,
  }) : super(key: key);

  @override
  State<AppBottomNavScaffold> createState() => _AppBottomNavScaffoldState();
}

class _AppBottomNavScaffoldState extends State<AppBottomNavScaffold> {

  late int _currentIndex = 0;

  int _indexOf(AppTab id) => widget.tabs.indexWhere((t) => t.id == id);
  void _goTo(AppTab id) => setState(() => _currentIndex = _indexOf(id));

  @override
  Widget build(BuildContext context) {
    final current = widget.tabs[_currentIndex];

    // 1) Clean BottomNavigationBar (icons only, labels hidden, stable sizes)
    final bar = BottomNavigationBar(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.muted,
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 24),
      items: [
        for (final t in widget.tabs)
          BottomNavigationBarItem(label: "", icon: Icon(t.icon)),
      ],
    );

    // 2) Wrap in SafeArea(top:false) so iOS home-indicator padding doesn't push icons upward
    final barWithSafeArea = SafeArea(top: false, child: bar);

    final dividersOverlay = Positioned.fill(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, c) {
            final count = widget.tabs.length;
            if (count <= 1) return const SizedBox.shrink();
            final spacing = c.maxWidth / count;

            // Draw exactly (count - 1) dividers, aligned RTL so the first segment
            // corresponds to the RIGHTMOST tab (Home). We place each divider on
            // the *left* edge of that segment — i.e., between items.
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: List.generate(count - 1, (i) {
                  return SizedBox(
                    width: spacing,
                    child: Align(
                      alignment:
                          Alignment.centerLeft, // left edge of each segment
                      child: Container(
                        width: 1,
                        height: 28,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.grey, Colors.black],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          current.title,
          style: const TextStyle(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        automaticallyImplyLeading: false,
        actions: const [
          NotificationBellIcon(),
          SizedBox(width: 8),
        ],
      ),
      body: current.builder(_goTo, _indexOf),
      bottomNavigationBar: Stack(children: [barWithSafeArea, dividersOverlay]),
      backgroundColor: AppColors.background,
    );
  }
}
