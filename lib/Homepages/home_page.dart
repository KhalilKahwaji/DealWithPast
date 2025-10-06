// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:interactive_map/theme/colors.dart';

/// Home page with sectioned layout (light mode).
/// Parent switches tabs by calling [onSelectIndex].
class HomePage extends StatefulWidget {
  final void Function(int index) onSelectIndex;
  /// If guest/signed-in add-story tab differs, override addStoryIndex from caller.
  final int addStoryIndex;

  const HomePage({
    Key? key,
    required this.onSelectIndex,
    this.addStoryIndex = 3, //TODO: placeholder, later go to add story page
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Carousel state
  final PageController _page = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  // Map state (purely for the snippet)
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _page.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            
            const SizedBox(height: 12),

            // Filters (tappable stubs for now)
            Row(
              children: [
                Expanded(child: _pill(context, 'قرأت مؤخرًا', Icons.history, () {
                  _stub('سيتم عرض ما قرأته مؤخرًا لاحقًا');
                  // Example route later: widget.onSelectIndex(4); // عرض الروايات
                })),
                const SizedBox(width: 12),
                Expanded(child: _pill(context, 'إعجاب', Icons.favorite_border, () {
                  _stub('سيتم عرض إعجاباتك لاحقًا');
                })),
              ],
            ),
            const SizedBox(height: 16),

            // Stories
            _sectionHeader(context, 'إقرأ الروايات', trailing: 'المزيد', onTapTrailing: () {
              widget.onSelectIndex(3); // jump to "عرض الروايات"
            }),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => _storyChip(
                  context,
                  title: i == 2 ? 'مقطع' : 'رواية',
                  onTap: () => widget.onSelectIndex(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Map snippet (real GoogleMap, gestures disabled, tap -> Map tab)
            _sectionHeader(context, 'استكشف الخريطة'),
            const SizedBox(height: 8),
            _mapSnippet(context, onTap: () => widget.onSelectIndex(4)),
            const SizedBox(height: 20),

            // Add your story
            _sectionHeader(context, 'أضف روايتك'),
            const SizedBox(height: 8),
            _bigActionCard(
              context,
              label: 'ابدأ كتابة روايتك',
              icon: Icons.edit_outlined,
              onTap: () => widget.onSelectIndex(widget.addStoryIndex),
            ),
            const SizedBox(height: 24),

            // Swipable carousel
            _carousel(context),
            const SizedBox(height: 24),

            // Leaderboard
            _sectionHeader(context, 'لائحة المتصدرين', trailing: 'المزيد', onTapTrailing: _stubMore),
            const SizedBox(height: 12),
            _leaderboardRow(context),
          ],
        ),
      ),
    );
  }

  // ------------ UI helpers ------------

  void _stub(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _stubMore() => _stub('سيتم عرض المزيد لاحقًا');

  Widget _pill(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.muted),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title,
      {String? trailing, VoidCallback? onTapTrailing}) {
    final t = Text(
      title,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
          ),
    );

    final trailingW = trailing == null
        ? const SizedBox.shrink()
        : InkWell(
            onTap: onTapTrailing,
            child: Text(
              trailing,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          );

    return Row(
      children: [
        Expanded(child: t),
        trailingW,
      ],
    );
  }

  Widget _storyChip(BuildContext context,
      {required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              boxShadow: AppColors.cardShadow,
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.card,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.auto_stories, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _mapSnippet(BuildContext context, {required VoidCallback onTap}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Real map snippet: gestures disabled so it doesn't fight ListView.
          SizedBox(
            height: 160,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(33.8886, 35.4955), // Beirut (example)
                zoom: 11.0,
              ),
              onMapCreated: (c) => _mapController = c,
              // Disable interactions in the snippet
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              // Optional: Lite mode (Android-only optimization)
              liteModeEnabled: true,
            ),
          ),
          // Tap overlay to navigate to the full Map tab
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ),
          // Subtle shadow/outline
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                ),
              ),
            ),
          ),
          // Centered label
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Text(
                    'استكشف الخريطة',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.text,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigActionCard(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carousel(BuildContext context) {
    final items = List<int>.generate(4, (i) => i);
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _page,
            itemCount: items.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (i) {
            final selected = i == _currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(
                selected ? Icons.circle : Icons.circle_outlined,
                size: 8,
                color: AppColors.muted,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _leaderboardRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _leaderTile(context)),
        const SizedBox(width: 12),
        Expanded(child: _leaderTile(context)),
        const SizedBox(width: 12),
        Expanded(child: _leaderTile(context)),
      ],
    );
  }

  Widget _leaderTile(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
    );
  }
}
