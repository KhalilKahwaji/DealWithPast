// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:place_picker/place_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Repos/MissionRepo.dart';
import '../Repos/UserRepo.dart';

class CreateMissionPage extends StatefulWidget {
  final String? token;

  const CreateMissionPage({Key? key, this.token}) : super(key: key);

  @override
  _CreateMissionPageState createState() => _CreateMissionPageState();
}

class _CreateMissionPageState extends State<CreateMissionPage> {
  final _formKey = GlobalKey<FormState>();
  final MissionRepo _missionRepo = MissionRepo();
  final UserRepo _userRepo = UserRepo();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Form values
  String? _selectedType; // 'social' or 'personal'
  String? _selectedDifficulty; // 'easy', 'medium', 'hard'
  String? _selectedPeriod; // decade tag
  LocationResult? _selectedLocation;
  int _descriptionLength = 0;
  bool _isSubmitting = false;

  final List<Map<String, String>> _missionTypes = [
    {'value': 'social', 'label': 'اجتماعية'},
    {'value': 'personal', 'label': 'شخصية'},
  ];

  final List<Map<String, String>> _difficultyLevels = [
    {'value': 'easy', 'label': 'سهل'},
    {'value': 'medium', 'label': 'متوسط'},
    {'value': 'hard', 'label': 'صعب'},
  ];

  final List<String> _periods = [
    'التسعينات (1990-1999)',
    'الثمانينات (1980-1989)',
    'السبعينات (1970-1979)',
    'الستينات (1960-1969)',
    'الخمسينات (1950-1959)',
  ];

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {
        _descriptionLength = _descriptionController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    try {
      LocationResult? result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlacePicker(
            "AIzaSyA9gDM3gcQQZqWNuaDkT0u6EEQnWq4bR1w",
            displayLocation: const LatLng(33.8938, 35.5018),
          ),
        ),
      );

      if (result != null) {
        setState(() {
          _selectedLocation = result;
        });
      }
    } catch (e) {
      print('Error picking location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء اختيار الموقع')),
      );
    }
  }

  Future<void> _submitMission() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول لإنشاء مهمة')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Get user credentials and profile photo
      final currentUser = FirebaseAuth.instance.currentUser;
      final username = currentUser?.email ?? '';
      final password = ''; // TODO: Handle authentication properly
      final photoUrl = currentUser?.photoURL;

      final missionData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedType,
        'difficulty': _selectedDifficulty,
        'decade_tag': _selectedPeriod,
        'latitude': _selectedLocation?.latLng?.latitude,
        'longitude': _selectedLocation?.latLng?.longitude,
        'address': _selectedLocation?.formattedAddress,
        'goal_count': 10, // Default goal
        'mission_type': 'visit', // Default type
        'creator_avatar': photoUrl, // Google profile photo
      };

      final response = await _missionRepo.createMission(
        missionData,
        username ?? '',
        password,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تم إرسال المهمة للمراجعة. سيتم إخطارك عند الموافقة عليها (عادة خلال 24 ساعة)',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: Color(0xFF5A7C59),
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error creating mission: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء إنشاء المهمة')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text(
          'إنشاء مهمة جديدة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Mission icon
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF8B4513),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.track_changes, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Info box
              _buildInfoBox(),
              const SizedBox(height: 24),
              // Mission title
              _buildFieldLabel('عنوان المهمة', required: true),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hint: 'أعط المهمة عنواناً واضحاً وجذاباً',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال عنوان المهمة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Mission description
              _buildFieldLabel('وصف المهمة', required: true),
              const SizedBox(height: 8),
              _buildMultilineTextField(
                controller: _descriptionController,
                hint: 'اشرح الهدف من المهمة ونوع القصص المطلوبة...',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال وصف المهمة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Mission type
              _buildFieldLabel('نوع المهمة', required: true, icon: Icons.people),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _selectedType,
                hint: 'اختر نوع المهمة',
                items: _missionTypes
                    .map((type) => DropdownMenuItem(
                          value: type['value'],
                          child: Text(
                            type['label']!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontFamily: 'Tajawal'),
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value),
                validator: (value) => value == null ? 'الرجاء اختيار نوع المهمة' : null,
              ),
              const SizedBox(height: 20),
              // Difficulty level
              _buildFieldLabel('مستوى الصعوبة', required: true, icon: Icons.speed),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _selectedDifficulty,
                hint: 'اختر مستوى الصعوبة',
                items: _difficultyLevels
                    .map((level) => DropdownMenuItem(
                          value: level['value'],
                          child: Text(
                            level['label']!,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontFamily: 'Tajawal'),
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedDifficulty = value),
                validator: (value) => value == null ? 'الرجاء اختيار مستوى الصعوبة' : null,
              ),
              const SizedBox(height: 20),
              // Time period
              _buildFieldLabel('الفترة الزمنية', required: true, icon: Icons.calendar_today),
              const SizedBox(height: 8),
              _buildDropdown<String>(
                value: _selectedPeriod,
                hint: 'اختر الفترة الزمنية',
                items: _periods
                    .map((period) => DropdownMenuItem(
                          value: period,
                          child: Text(
                            period,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontFamily: 'Tajawal'),
                          ),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedPeriod = value),
                validator: (value) => value == null ? 'الرجاء اختيار الفترة الزمنية' : null,
              ),
              const SizedBox(height: 20),
              // Location
              _buildFieldLabel('الموقع', required: true, icon: Icons.location_on),
              const SizedBox(height: 8),
              _buildLocationPicker(),
              const SizedBox(height: 40),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  onPressed: _isSubmitting ? null : _submitMission,
                  color: const Color(0xFF4CAF50),
                  disabledColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                  child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
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
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1A3A3534), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            child: Text(
              'أنشئ مهمة لجمع قصص حول موضوع أو فترة زمنية محددة. ساعد المجتمع على الحفاظ على الذكريات المهمة.',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Tajawal',
                height: 1.5,
              ),
            ),
          ),
          SizedBox(width: 12),
          Text('🌲', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool required = false, IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (required) ...[
          const Text(
            '*',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3A3534),
            fontFamily: 'Tajawal',
          ),
        ),
        if (icon != null) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: const Color(0xFF3A3534)),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF3A3534),
        fontFamily: 'Tajawal',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Tajawal'),
        filled: true,
        fillColor: const Color(0xFFF5F0E8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: validator,
    );
  }

  Widget _buildMultilineTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      maxLength: 500,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF3A3534),
        fontFamily: 'Tajawal',
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Tajawal'),
        filled: true,
        fillColor: const Color(0xFFF5F0E8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
        counterText: '$_descriptionLength حرف',
        counterStyle: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
          fontFamily: 'Tajawal',
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F0E8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Tajawal'),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildLocationPicker() {
    return GestureDetector(
      onTap: _pickLocation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0E8),
          borderRadius: BorderRadius.circular(12),
          border: _selectedLocation == null
            ? Border.all(color: Colors.transparent)
            : Border.all(color: const Color(0xFF4CAF50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            Expanded(
              child: Text(
                _selectedLocation?.formattedAddress ?? 'اختر الموقع',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 15,
                  color: _selectedLocation == null ? Colors.grey.shade400 : const Color(0xFF3A3534),
                  fontFamily: 'Tajawal',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
