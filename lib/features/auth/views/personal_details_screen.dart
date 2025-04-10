import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/common_textfield.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// For picking images from gallery/camera
import 'package:image_picker/image_picker.dart';


// import 'select_location_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  // Text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _jobRoleController = TextEditingController();
  final _driverExperienceController = TextEditingController();
  final _driverLicenceController = TextEditingController();

  final _aadharCardNumberController = TextEditingController();

  // Gender dropdown
  final List<String> _genders = ['Male', 'Female', 'Other'];
  String? _selectedGender;

  // Avatar image
  XFile? _pickedImage;

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
        _emailController.text.trim().isNotEmpty &&
        _jobRoleController.text.trim().isNotEmpty &&
        _driverExperienceController.text.trim().isNotEmpty &&
        _driverLicenceController.text.trim().isNotEmpty &&
        _aadharCardNumberController.text.trim().isNotEmpty &&
        _selectedGender != null;
  }

  void _onContinuePressed() {
    if (!isFormValid) return;
    // TODO: Handle form submission logic, then navigate or do next steps
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile completed for: ${_nameController.text}')),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder:
    //         (context) => const SelectLocationScreen(isFromAllAddress: false),
    //   ),
    // );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _jobRoleController.dispose();
    _driverExperienceController.dispose();
    _driverLicenceController.dispose();
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
            // Progress bar & top title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: const ProgressBar(currentStep: 3),
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
                        label: 'Job Role',
                        hintText: 'Enter your job role',
                        controller: _jobRoleController,
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
                        height: MediaQuery.of(context).size.height * 0.17,
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
