// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/entities/localization_item.dart';
import 'package:place_picker/place_picker.dart';
import 'package:location/location.dart' as locationPerm;
import '../Repos/MissionRepo.dart';

class CreateMissionModal extends StatefulWidget {
  final String? token;
  final String? username;
  final String? password;

  const CreateMissionModal({
    Key? key,
    this.token,
    this.username,
    this.password,
  }) : super(key: key);

  @override
  _CreateMissionModalState createState() => _CreateMissionModalState();
}

class _CreateMissionModalState extends State<CreateMissionModal> {
  final _formKey = GlobalKey<FormState>();
  final MissionRepo _missionRepo = MissionRepo();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fromYearController = TextEditingController();
  final TextEditingController _toYearController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedType;
  String? _selectedDifficulty;
  int _descriptionLength = 0;
  bool _isSubmitting = false;

  // Location
  double? _lat;
  double? _lng;
  bool _serviceEnabled = false;
  locationPerm.PermissionStatus _permissionGranted = locationPerm.PermissionStatus.denied;
  final location = locationPerm.Location();

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() => _descriptionLength = _descriptionController.text.length);
    });
    _checkLocationPermission();
  }

  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locationPerm.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }
  }

  void _showPlacePicker() async {
    if (_permissionGranted != locationPerm.PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى السماح بالوصول إلى الموقع'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      LocationResult result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PlacePicker(
            "AIzaSyB5IXP-SANsluLrgaAgmqp70kNlHeCa-ps",
            displayLocation: LatLng(_lat ?? 33.8938, _lng ?? 35.5018),
            localizationItem: LocalizationItem(
              languageCode: "ar_lb",
              tapToSelectLocation: "اختر هذا المكان",
              findingPlace: "تفتيش...",
              nearBy: "اماكن مجاورة",
            ),
          ),
        ),
      );

      setState(() {
        _locationController.text = result.city?.name ?? result.formattedAddress ?? 'موقع محدد';
        _lat = result.latLng?.latitude;
        _lng = result.latLng?.longitude;
      });
    } catch (e) {
      print('Error picking location: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _fromYearController.dispose();
    _toYearController.dispose();
    _locationController.dispose();
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
                    // Period (from/to years)
                    _buildLabel('الفترة الزمنية', required: true, icon: Icons.calendar_today),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'إلى سنة',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Tajawal',
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _toYearController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontFamily: 'Tajawal', fontSize: 15),
                                decoration: _inputDecoration('1999'),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'مطلوب';
                                  final year = int.tryParse(v);
                                  if (year == null || year < 1900 || year > 2100) {
                                    return 'سنة غير صحيحة';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'من سنة',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Tajawal',
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: _fromYearController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontFamily: 'Tajawal', fontSize: 15),
                                decoration: _inputDecoration('1990'),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'مطلوب';
                                  final year = int.tryParse(v);
                                  if (year == null || year < 1900 || year > 2100) {
                                    return 'سنة غير صحيحة';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Location picker
                    _buildLabel('الموقع', required: true, icon: Icons.location_on),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: _showPlacePicker,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8DCC8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.location_on, color: Color(0xFF8B5A5A)),
                            Expanded(
                              child: Text(
                                _locationController.text.isEmpty ? 'اختر الموقع' : _locationController.text,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _locationController.text.isEmpty ? Colors.grey.shade600 : Color(0xFF3A3534),
                                  fontFamily: 'Tajawal',
                                ),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
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

    // Validate year range
    final fromYear = int.parse(_fromYearController.text);
    final toYear = int.parse(_toYearController.text);
    if (fromYear > toYear) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('سنة البداية يجب أن تكون أقل من أو تساوي سنة النهاية'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate location
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى اختيار الموقع'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Prepare mission data
      final missionData = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _selectedType,
        'difficulty': _selectedDifficulty,
        'period_from': fromYear,
        'period_to': toYear,
        'lat': _lat,
        'lng': _lng,
      };

      // TODO: Replace with actual logged-in user credentials
      // Currently using admin credentials as temporary fallback
      // Should be updated to pass user's username and password (uid) from login
      final username = widget.username ?? 'admin';
      final password = widget.password ?? 'Admin_12345';

      // Call API
      await _missionRepo.createMission(
        missionData,
        username,
        password,
      );

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إنشاء المهمة بنجاح'),
            backgroundColor: Color(0xFF5A7C59),
          ),
        );
      }
    } catch (e) {
      print('Error creating mission: $e');
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء إنشاء المهمة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
