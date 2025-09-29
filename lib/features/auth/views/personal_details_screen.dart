import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/views/select_home_location.dart';
import 'package:breezodriver/features/profile/models/driver_model.dart';
import 'package:breezodriver/features/profile/viewmodels/driver_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/common_textfield.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// For picking images from gallery/camera
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


// import 'select_location_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {

  const PersonalDetailsScreen({
    Key? key
  }) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  // Text controllers
  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _driverExperienceController = TextEditingController();
  final _driverLicenceController = TextEditingController();
  final _aadharCardNumberController = TextEditingController();
  // Gender dropdown
  final List<String> _genders = ['Male', 'Female', 'Other'];
  String? _selectedGender;

  // Avatar image
  XFile? _pickedImage;

  // Loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });
    final driverViewModel = Provider.of<DriverViewModel>(context, listen: false);
    await driverViewModel.loadDriverData();
    if (driverViewModel.driverProfile != null) {
      final data = driverViewModel.driverProfile!;
      _nameController.text = data.name ?? '';
      _driverExperienceController.text = data.experienceYears.toString() ?? '';
      _driverLicenceController.text = data.licenseNumber ?? '';
      _aadharCardNumberController.text = data.aadharNumber ?? '';
      _dateOfBirthController.text = data.dateOfBirth.toLocal().toString().split(' ')[0];
      _emailController.text = data.email ?? '';
      _alternatePhoneController.text = data.alternatePhoneNum ?? '';

      // Handle gender
      if (data.gender == 'M' || data.gender == 'm') {
        _selectedGender = 'Male';
      } else if (data.gender == 'F' || data.gender == 'f') {
        _selectedGender = 'Female';
      }
      
      // Note: profilePic handling would go here if needed
      // if (data['profilePic'] != null) { ... }
    }
    setState(() {
      _isLoading = false;
    });
  }

  /// Picks an image from camera or gallery
  Future<void> _pickImage() async {
    // Example using image_picker
    final ImagePicker picker = ImagePicker();

    // Show a bottom sheet or dialog to choose camera/gallery
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
        _dateOfBirthController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _alternatePhoneController.text.trim().isNotEmpty &&
        _driverExperienceController.text.trim().isNotEmpty &&
        _driverLicenceController.text.trim().isNotEmpty &&
        _aadharCardNumberController.text.trim().isNotEmpty &&
        _selectedGender != null;
  }
  
  Future<bool> _saveProfile() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
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
      dateOfBirth: DateTime.parse(_dateOfBirthController.text),
      email: _emailController.text.trim(),
      gender: genderCode,
      profilePic: null,
      aadharNumber: _aadharCardNumberController.text,
      licenseNumber: _driverLicenceController.text,
      alternatePhoneNum: _alternatePhoneController.text.isNotEmpty
          ? _alternatePhoneController.text
          : null,
      experienceYears: int.tryParse(_driverExperienceController.text) ?? 0
    );

    setState(() {
      _isLoading = false;
      if (success) {
        // _isEditing = false;
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Profile saved successfully')),
        // );
        CherryToast.info(
          title: const Text('Data submitted successfully!'),
          toastDuration: const Duration(seconds: 2),
          iconWidget: const Icon(Icons.check_circle, color: Colors.green),
          // enableIconAnimation: false,
          disableToastAnimation: true,


        ).show(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save profile')));
      }
    });
    return success;
  }

  Future<void> _onContinuePressed() async {
    if (!isFormValid) return;
    final success = await _saveProfile();
    if(success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => const SelectLocationScreen(isFromAllAddress: false),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _alternatePhoneController.dispose();
    _driverExperienceController.dispose();
    _driverLicenceController.dispose();
    _aadharCardNumberController.dispose();
    _dateOfBirthController.dispose();
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
            // Progress bar & top title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: ProgressBar(currentStep: 3),
            ),
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator()) :
                SingleChildScrollView(
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
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Complete your profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

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
                                      // Convert XFile to File
                                      // (You need dart:io for this)
                                      // If you're on web, use a different approach
                                      // For demonstration, we assume mobile
                                      // so it works with a File constructor
                                      // from the path
                                      // e.g. File(_pickedImage!.path)
                                      //
                                      // But you must `import 'dart:io';`
                                      //
                                      // If building for web, you'll need
                                      // a different approach.
                                      // Or just store the path in memory
                                      // for display.
                                      //
                                      // We'll just show a placeholder logic:
                                      // (Uncomment if you want actual file usage)
                                      // File(_pickedImage!.path),
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
                          // Small camera icon in a circle
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
                      ),
                      const SizedBox(height: 16),
                      // Date of Birth field
                      CommonTextField(
                        label: 'Date of Birth',
                        hintText: 'Select your date of birth',
                        controller: _dateOfBirthController,
                        readOnly: true, // Make it read-only for date picker
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.timestamp(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.timestamp(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dateOfBirthController.text =
                                  '${pickedDate.toLocal()}'.split(' ')[0];
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email field
                      CommonTextField(
                        label: 'Company Email-ID',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Job Role field
                      CommonTextField(
                        label: 'Alternate Mobile Number',
                        hintText: 'Enter your alternate mobile number',
                        controller: _alternatePhoneController,
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
                              );
                            }).toList(),
                      ),
                      Divider(
                        color: Colors.grey.shade400,
                        height: 24,
                      ),
                       SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        'DRIVER DETAILS',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.withOpacity(0.9),
                        ),
                      ),
                        SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      // Driver Experience
                      CommonTextField(
                        label: 'Driver Experience',
                        hintText: 'Enter your experience',
                        controller: _driverExperienceController,
                      ),
                      const SizedBox(height: 16),
                      // Driver Licence
                      CommonTextField(
                        label: 'Driver Licence',
                        hintText: 'Enter your driving licence',
                        controller: _driverLicenceController,
                      ),
                      const SizedBox(height: 16),
                      // Vehicle Number Plate
                      CommonTextField(
                        label: 'Aadhar Card Number',
                        hintText: 'Enter your aadhar card number',
                        controller:  _aadharCardNumberController,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                      ),

                      // Continue button
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
