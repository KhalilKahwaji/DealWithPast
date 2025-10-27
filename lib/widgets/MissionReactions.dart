// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Emoji reaction widget for missions
/// Allows users to react with emojis (like, love, celebrate, thinking, wow)
class MissionReactions extends StatefulWidget {
  final int missionId;
  final bool isCompact; // If true, shows condensed version for cards

  const MissionReactions({
    Key? key,
    required this.missionId,
    this.isCompact = false,
  }) : super(key: key);

  @override
  _MissionReactionsState createState() => _MissionReactionsState();
}

class _MissionReactionsState extends State<MissionReactions> {
  // Available reactions
  final List<ReactionType> _reactions = [
    ReactionType('👍', 'إعجاب'),
    ReactionType('❤️', 'حب'),
    ReactionType('🎉', 'احتفال'),
    ReactionType('🤔', 'تفكير'),
    ReactionType('😮', 'مذهل'),
  ];

  Map<String, int> _reactionCounts = {};
  String? _userReaction; // User's current reaction
  bool _showPicker = false;

  @override
  void initState() {
    super.initState();
    _loadReactions();
  }

  Future<void> _loadReactions() async {
    final prefs = await SharedPreferences.getInstance();

    // Load reaction counts for this mission
    final countsJson = prefs.getString('mission_${widget.missionId}_reactions');
    if (countsJson != null) {
      setState(() {
        _reactionCounts = Map<String, int>.from(json.decode(countsJson));
      });
    }

    // Load user's reaction
    final userReaction = prefs.getString('mission_${widget.missionId}_user_reaction');
    if (userReaction != null) {
      setState(() {
        _userReaction = userReaction;
      });
    }
  }

  Future<void> _saveReactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'mission_${widget.missionId}_reactions',
      json.encode(_reactionCounts),
    );
    if (_userReaction != null) {
      await prefs.setString(
        'mission_${widget.missionId}_user_reaction',
        _userReaction!,
      );
    } else {
      await prefs.remove('mission_${widget.missionId}_user_reaction');
    }
  }

  void _toggleReaction(String emoji) {
    setState(() {
      // Remove previous reaction if exists
      if (_userReaction != null) {
        _reactionCounts[_userReaction!] = (_reactionCounts[_userReaction!] ?? 1) - 1;
        if (_reactionCounts[_userReaction!]! <= 0) {
          _reactionCounts.remove(_userReaction!);
        }
      }

      // Toggle new reaction
      if (_userReaction == emoji) {
        // Remove reaction if clicking same emoji
        _userReaction = null;
      } else {
        // Add new reaction
        _userReaction = emoji;
        _reactionCounts[emoji] = (_reactionCounts[emoji] ?? 0) + 1;
      }

      _showPicker = false;
    });

    _saveReactions();

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _userReaction == null ? 'تم إزالة التفاعل' : 'تم إضافة التفاعل $emoji',
          style: const TextStyle(fontFamily: 'Tajawal'),
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return _buildCompactView();
    } else {
      return _buildFullView();
    }
  }

  Widget _buildCompactView() {
    // Show only top 3 reactions with counts
    final topReactions = _reactionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (topReactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < topReactions.take(3).length; i++)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(topReactions[i].key, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '${topReactions[i].value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3A3534),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFullView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reaction counts display
        if (_reactionCounts.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _reactionCounts.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0E8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _userReaction == entry.key
                        ? const Color(0xFF5A7C59)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(entry.key, style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      '${entry.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3A3534),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

        const SizedBox(height: 12),

        // Add reaction button
        GestureDetector(
          onTap: () => setState(() => _showPicker = !_showPicker),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF5A7C59).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF5A7C59),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _showPicker ? Icons.close : Icons.add_reaction_outlined,
                  size: 20,
                  color: const Color(0xFF5A7C59),
                ),
                const SizedBox(width: 8),
                Text(
                  _showPicker ? 'إغلاق' : (_userReaction == null ? 'أضف تفاعل' : 'غيّر تفاعلك'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5A7C59),
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ),

        // Reaction picker
        if (_showPicker)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _reactions.map((reaction) {
                final isSelected = _userReaction == reaction.emoji;
                return GestureDetector(
                  onTap: () => _toggleReaction(reaction.emoji),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5A7C59).withOpacity(0.2)
                          : const Color(0xFFF5F0E8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF5A7C59)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            reaction.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reaction.label,
                            style: const TextStyle(
                              fontSize: 8,
                              color: Color(0xFF3A3534),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class ReactionType {
  final String emoji;
  final String label;

  ReactionType(this.emoji, this.label);
}
