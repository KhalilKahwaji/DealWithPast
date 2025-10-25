// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Repos/MissionRepo.dart';

class CreateMissionModal extends StatefulWidget {
  final String? token;

  const CreateMissionModal({Key? key, this.token}) : super(key: key);

  @override
  _CreateMissionModalState createState() => _CreateMissionModalState();
}

class _CreateMissionModalState extends State<CreateMissionModal> {
  final _formKey = GlobalKey<FormState>();
  final MissionRepo _missionRepo = MissionRepo();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedType;
  String? _selectedDifficulty;
  String? _selectedPeriod;
  int _descriptionLength = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() => _descriptionLength = _descriptionController.text.length);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Color(0xFFF5F0E8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: Color(0xFF3A3534)),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'إنشاء مهمة جديدة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Tajawal',
                    color: Color(0xFF3A3534),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(0xFF8B4513),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.track_changes, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Info box
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8DCC8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'أنشئ مهمة لجمع قصص حول موضوع أو فترة زمنية محددة. ساعد المجتمع على الحفاظ على الذكريات المهمة.',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('🌲', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Title
                    _buildLabel('عنوان المهمة', required: true),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 15),
                      decoration: _inputDecoration('أعط المهمة عنواناً واضحاً وجذاباً'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),
                    SizedBox(height: 20),
                    // Description
                    _buildLabel('وصف المهمة', required: true),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      maxLength: 500,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontFamily: 'Tajawal', fontSize: 15),
                      decoration: _inputDecoration('اشرح الهدف من المهمة ونوع القصص المطلوبة...').copyWith(
                        counterText: '$_descriptionLength حرف',
                        counterStyle: TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),
                    SizedBox(height: 20),
                    // Type
                    _buildLabel('نوع المهمة', required: true, icon: Icons.people),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: _inputDecoration('اختر نوع المهمة'),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(value: 'social', child: Text('اجتماعية', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Tajawal'))),
                        DropdownMenuItem(value: 'personal', child: Text('شخصية', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Tajawal'))),
                      ],
                      onChanged: (v) => setState(() => _selectedType = v),
                      validator: (v) => v == null ? 'مطلوب' : null,
                    ),
                    SizedBox(height: 20),
                    // Difficulty
                    _buildLabel('مستوى الصعوبة', required: true, icon: Icons.speed),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDifficulty,
                      decoration: _inputDecoration('اختر مستوى الصعوبة'),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(value: 'easy', child: Text('سهل', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Tajawal'))),
                        DropdownMenuItem(value: 'medium', child: Text('متوسط', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Tajawal'))),
                        DropdownMenuItem(value: 'hard', child: Text('صعب', textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Tajawal'))),
                      ],
                      onChanged: (v) => setState(() => _selectedDifficulty = v),
                      validator: (v) => v == null ? 'مطلوب' : null,
                    ),
                    SizedBox(height: 20),
                    // Period
                    _buildLabel('الفترة الزمنية', required: true, icon: Icons.calendar_today),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPeriod,
                      decoration: _inputDecoration('اختر الفترة الزمنية'),
                      isExpanded: true,
                      items: [
                        'التسعينات (1990-1999)',
                        'الثمانينات (1980-1989)',
                        'السبعينات (1970-1979)',
                      ].map((p) => DropdownMenuItem(value: p, child: Text(p, textAlign: TextAlign.right, style: TextStyle(fontFamily: 'Tajawal')))).toList(),
                      onChanged: (v) => setState(() => _selectedPeriod = v),
                      validator: (v) => v == null ? 'مطلوب' : null,
                    ),
                    SizedBox(height: 20),
                    // Location placeholder
                    _buildLabel('الموقع', required: true, icon: Icons.location_on),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8DCC8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          Text(
                            'اختر الموقع',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade600,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: _isSubmitting ? null : _submit,
                        color: Color(0xFF5A7C59),
                        disabledColor: Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'إنشاء المهمة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {bool required = false, IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (required) ...[
          Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
          SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Tajawal',
            color: Color(0xFF3A3534),
          ),
        ),
        if (icon != null) ...[
          SizedBox(width: 8),
          Icon(icon, size: 20, color: Color(0xFF3A3534)),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontFamily: 'Tajawal'),
      filled: true,
      fillColor: Color(0xFFE8DCC8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.all(16),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // TODO: Implement mission creation with API
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إنشاء المهمة بنجاح'),
          backgroundColor: Color(0xFF5A7C59),
        ),
      );
    }
  }
}
