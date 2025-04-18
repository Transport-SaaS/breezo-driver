import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';

import 'package:breezodriver/features/auth/views/select_home_location.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/common_textfield.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// For picking images from gallery/camera
import 'package:image_picker/image_picker.dart';


// import 'select_location_screen.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  // Text controllers
  final _drivingExperienceController = TextEditingController();
  final _drivingLicenseNumberController = TextEditingController();
  final _aadharCardNumberController = TextEditingController();
  bool _isEditMode = false;


  /// Determines if all fields are filled (for enabling the Continue button).
  bool get isFormValid {
    return _drivingExperienceController.text.trim().isNotEmpty &&
        _drivingLicenseNumberController.text.trim().isNotEmpty &&
        _aadharCardNumberController.text.trim().isNotEmpty; 
  }

  void _onContinuePressed() {
    if (!isFormValid || !_isEditMode) return;
    // TODO: Handle form submission logic, then navigate or do next steps
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Profile completed for: ${_nameController.text}')),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const SelectLocationScreen(isFromAllAddress: false),
      ),
    );
  }

  // Toggle edit mode
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  void dispose() {
    _drivingExperienceController.dispose(); 
    _drivingLicenseNumberController.dispose();
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
            SizedBox(height: 20,),
           
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
                            'Driver Details',
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
                                SizedBox(width: 4),
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
                       const Text(
                            'BUSINESS DETAILS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                            ),
                          ),


                      // Avatar + Camera/Gallery icon
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Add your avatar widgets here if needed
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Name field
                      CommonTextField(
                        label: 'Driving Experience',
                        hintText: 'Enter your driving experience',
                        controller: _drivingExperienceController,
                        enabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      CommonTextField(
                        label: 'Driving License Number',
                        hintText: 'Enter your driving license number',
                        controller: _drivingLicenseNumberController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: _isEditMode,
                      ),
                      const SizedBox(height: 16),

                      // Job Role field
                      CommonTextField(
                        label: 'Aadhar Card Number',
                        hintText: 'Enter your aadhar card number',
                        controller: _aadharCardNumberController,
                        enabled: _isEditMode,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.35),

                    
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
