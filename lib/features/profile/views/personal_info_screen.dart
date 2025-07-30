import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/views/select_home_location.dart';
import 'package:breezodriver/features/profile/viewmodels/driver_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/common_textfield.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// For picking images from gallery/camera
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


// import 'select_location_screen.dart';

class PersonalProfileDetailsScreen extends StatefulWidget {
  const PersonalProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalProfileDetailsScreen> createState() => _PersonalProfileDetailsScreenState();
}

class _PersonalProfileDetailsScreenState extends State<PersonalProfileDetailsScreen> {
  // Text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _currentAddressController = TextEditingController();
  final _permanentAddressController = TextEditingController();

  final _aadharCardNumberController = TextEditingController();

  // Gender dropdown
  final List<String> _genders = ['Male', 'Female', 'Other'];
  String? _selectedGender;

  // Avatar image
  XFile? _pickedImage;

  // Add loading state
  bool _isLoading = true;

  // Add a flag to track edit mode
  bool _isEditMode = false;

  /// Picks an image from camera or gallery
  Future<void> _pickImage() async {
    // Only allow picking image in edit mode
    if (!_isEditMode) return;
    
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  /// Determines if all fields are filled (for enabling the Continue button).
  bool get isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _alternatePhoneController.text.trim().isNotEmpty &&
        _currentAddressController.text.trim().isNotEmpty &&
        _permanentAddressController.text.trim().isNotEmpty &&
        _selectedGender != null;
  }

  void _onContinuePressed() {
    if (!isFormValid || !_isEditMode) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile completed for: ${_nameController.text}')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const SelectLocationScreen(isFromAllAddress: false),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Convert gender to API format (m/f/o)
    String genderCode = 'o';
    if (_selectedGender == 'Male') {
      genderCode = 'm';
    } else if (_selectedGender == 'Female') {
      genderCode = 'f';
    }

    final driverViewModel = Provider.of<DriverViewModel>(
      context,
      listen: false,
    );
    final success = await driverViewModel.saveProfile(
      name: _nameController.text,
      email: _emailController.text.trim(),
      gender: genderCode,
      profilePic: null,
      aadharNumber: _aadharCardNumberController.text,
      licenseNumber: '',
      experienceYears: 0,
      contractStartDate: DateTime.now(),
    );

    setState(() {
      _isLoading = false;
      if (success) {
        // _isEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save profile')));
      }
    });
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _alternatePhoneController.dispose();
    _currentAddressController.dispose();
    _permanentAddressController.dispose();
    _aadharCardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Purple background
      backgroundColor: AppColors.secondary700,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back, color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Your Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: _toggleEditMode,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: _isEditMode ? AppColors.secondary700 : Colors.grey),
                              borderRadius: BorderRadius.circular(14),
                              color: _isEditMode ? AppColors.secondary700.withOpacity(0.1) : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isEditMode ? Icons.check : Icons.edit_outlined,
                                  size: 16,
                                  color: _isEditMode ? AppColors.secondary700 : Colors.grey, 
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isEditMode ? 'Done' : 'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _isEditMode ? AppColors.secondary700 : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Avatar + Camera/Gallery icon
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Circle avatar for picked image or placeholder
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                _pickedImage == null
                                    ? null
                                    : FileImage(
                                      File(_pickedImage!.path),
                                    ),
                            child:
                                _pickedImage == null
                                    ? Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey.shade600,
                                    )
                                    : null,
                          ),
                          // Small camera icon in a circle - only visible in edit mode
                          if (_isEditMode)
                            InkWell(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Name field
                      CommonTextField(
                        label: 'Name',
                        hintText: 'Enter your name',
                        controller: _nameController,
                        enabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      CommonTextField(
                        label: 'Company Email-ID',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),

                      // Job Role field
                      CommonTextField(
                        label: 'Alternate Phone Number',
                        hintText: 'Enter your alternate phone number',
                        controller: _alternatePhoneController,
                        enabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),

                      // Gender dropdown
                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8.0,
                        children:
                            _genders.map((String gender) {
                              return ChoiceChip(
                                label: Text(
                                  gender,
                                  style: TextStyle(
                                    color:
                                        _selectedGender == gender
                                            ? Colors.white
                                            : Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                showCheckmark: false,
                                selected: _selectedGender == gender,
                                selectedColor: AppColors.secondary700,
                                backgroundColor: Colors.white,
                                onSelected: (bool selected) {
                                  if (!_isEditMode) return;
                                  setState(() {
                                    _selectedGender = selected ? gender : null;
                                  });
                                },
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color:
                                        _selectedGender == gender
                                            ? AppColors.secondary700
                                            : Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                                disabledColor: Colors.grey.shade100,
                                // Disable the chip when not in edit mode
                                // enabled: _isEditMode,
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Current Address field
                      CommonTextField(
                        label: 'Current Address',
                        hintText: 'Enter your current address',
                        controller: _currentAddressController,
                        enabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),

                      // Permanent Address field
                      CommonTextField(
                        label: 'Permanent Address',
                        hintText: 'Enter your permanent address',
                        controller: _permanentAddressController,
                        enabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                      ),

                      // Continue button - only visible in edit mode
                      if (_isEditMode)
                        SizedBox(
                          width: double.infinity,
                          child: CommonButton(
                            label: 'Continue',
                            isActive: isFormValid,
                            onPressed: _onContinuePressed,
                          ),
                        ),
                      // Add bottom padding so the button is clear of keyboard
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
