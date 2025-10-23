// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Gallery/galleryTile.dart';
import 'Repos/StoryClass.dart';

// Convert the old Stateless GalleryView into a Stateful widget so we can
// keep UI state for filters.
class GalleryView extends StatefulWidget {
  final List<dynamic> stories; // List<Story>
  final dynamic token;
  const GalleryView(this.stories, this.token, {Key? key}) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  // Source of truth (all stories as loaded from disk)
  late final List<dynamic> _all;

  // What we render after applying filters / sorting
  late List<dynamic> _filtered;

  // UI state
  String _sortOrder = 'newest'; // 'newest' or 'oldest'
  String _decade = 'all'; // 'all' or '1950', '1960', ...
  late List<String> _availableDecades; // e.g. ['all', '1950', '1960', ...]

  @override
  void initState() {
    super.initState();
    _all = List<dynamic>.from(widget.stories);
    _availableDecades = _computeDecades(_all);
    _filtered = [];
    _applyFilters();
  }

  // Extract a 4-digit year from Story.event_date; returns null if not found
  int? _yearOf(dynamic s) {
    try {
      final String raw = (s as Story).event_date;
      final match = RegExp(r'(\d{4})').firstMatch(raw);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
    } catch (_) {}
    return null;
  }

  // Build a list of decades present in the data (e.g., ['all', '1950', '1960'])
  List<String> _computeDecades(List<dynamic> items) {
    final years = items.map(_yearOf).where((y) => y != null).cast<int>().toList();
    if (years.isEmpty) return ['all'];
    years.sort();
    final minDecade = (years.first ~/ 10) * 10;
    final maxDecade = (years.last ~/ 10) * 10;
    final decs = <String>['all'];
    for (int d = minDecade; d <= maxDecade; d += 10) {
      decs.add(d.toString());
    }
    return decs;
  }

  void _applyFilters() {
    List<dynamic> list = List<dynamic>.from(_all);

    // Filter by decade
    if (_decade != 'all') {
      final int d = int.parse(_decade);
      list = list.where((s) {
        final y = _yearOf(s);
        return y != null && y >= d && y < d + 10;
      }).toList();
    }

    // Sort by year (fallback: keep original order if year not found)
    list.sort((a, b) {
      final ya = _yearOf(a);
      final yb = _yearOf(b);
      if (ya == null && yb == null) return 0;
      if (ya == null) return 1;
      if (yb == null) return -1;
      final cmp = ya.compareTo(yb);
      return _sortOrder == 'newest' ? -cmp : cmp;
    });

    setState(() => _filtered = list);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Arabic layout
      child: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        padding: EdgeInsets.only(top: 12),
        child: Column(
          children: [
            // Header + Filters row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Screen title
                  Text(
                    "عرض الروايات",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  // Filters: Sort + Decade
                  Row(
                    children: [
                      Expanded(
                        child: _SortDropdown(
                          value: _sortOrder,
                          onChanged: (v) {
                            _sortOrder = v!;
                            _applyFilters();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _DecadeDropdown(
                          value: _decade,
                          decades: _availableDecades,
                          onChanged: (v) {
                            _decade = v!;
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // List
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  return GalleryTile(_filtered[index], widget.token);
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// --- UI pieces --------------------------------------------------------------

class _SortDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const _SortDropdown({required this.value, required this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          // This controls what is shown when the dropdown is CLOSED
          selectedItemBuilder: (ctx) => [
            _closedChip(), // for 'oldest'
            _closedChip(), // for 'newest'
          ],
          items: const [
            DropdownMenuItem(
              value: 'oldest',
              child: Text('من الأقدم إلى الأحدث'),
            ),
            DropdownMenuItem(
              value: 'newest',
              child: Text('من الأحدث إلى الأقدم'),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _closedChip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // RTL friendly
      children: const [
        Icon(Icons.filter_list, size: 18),
        SizedBox(width: 6),
        Text('فرز'),
      ],
    );
  }
}


class _DecadeDropdown extends StatelessWidget {
  final String value;
  final List<String> decades;
  final ValueChanged<String?> onChanged;
  const _DecadeDropdown(
      {required this.value, required this.decades, required this.onChanged, Key? key})
      : super(key: key);

  String _labelOf(String v) {
    if (v == 'all') return 'جميع العقود';
    return '${int.parse(v)}s'; // 1940s, 1950s, ...
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: decades
              .map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(_labelOf(d)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
