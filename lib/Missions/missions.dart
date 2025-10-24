import 'package:flutter/material.dart';
import 'missions_list_tab.dart';
import 'achievements_tab.dart';
import 'legacy_tab.dart';

class MissionsPage extends StatefulWidget {
  final String? token;
  final int? userId;

  const MissionsPage({
    Key? key,
    this.token,
    this.userId,
  }) : super(key: key);

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // Light beige/cream background
      appBar: AppBar(
        title: const Text(
          'المهام والإنجازات',
          style: TextStyle(
            fontFamily: 'Baloo',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFC9A961), // Gold/tan color
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Baloo',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Baloo',
          ),
          tabs: const [
            Tab(text: 'المهام'),
            Tab(text: 'الإنجازات'),
            Tab(text: 'الإرث'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MissionsListTab(
            token: widget.token,
            userId: widget.userId,
          ),
          AchievementsTab(
            token: widget.token,
            userId: widget.userId,
          ),
          LegacyTab(
            token: widget.token,
            userId: widget.userId,
          ),
        ],
      ),
    );
  }
}
