import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';

import 'package:breezodriver/features/auth/views/select_home_location.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/common_textfield.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
// For picking images from gallery/camera
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../viewmodels/driver_viewmodel.dart';


// import 'select_location_screen.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
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

  void _initializeData() {
    final driverViewModel = Provider.of<DriverViewModel>(context, listen: false);
    if (driverViewModel.driverProfile != null) {
      final data = driverViewModel.driverProfile!;
      _drivingExperienceController.text = data.experienceYears != null ? data.experienceYears.toString() : '';
      _drivingLicenseNumberController.text = data.licenseNumber ?? '';
      _aadharCardNumberController.text = data.aadharNumber ?? '';
    }
  }

  void _onContinuePressed() {
    if (!isFormValid || !_isEditMode) return;
    _saveProfile();
  }

  Future<void> _saveProfile() async {
    if (!isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final driverViewModel = Provider.of<DriverViewModel>(
      context,
      listen: false,
    );
    final success = await driverViewModel.saveProfile(
      experienceYears: int.tryParse(_drivingExperienceController.text) ?? 0,
      licenseNumber: _drivingLicenseNumberController.text,
      aadharNumber: _aadharCardNumberController.text,
    );

    setState(() {
      if (success) {
        // _isEditing = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details saved successfully')),
        );
        setState(() {
          _isEditMode=false;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save profile')));
        _initializeData();
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
                            child: const Icon(Icons.arrow_back, color: Colors.black),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Driver Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if(!_isEditMode)
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
                       // const Text(
                       //      'BUSINESS DETAILS',
                       //      style: TextStyle(
                       //        fontSize: 14,
                       //        fontWeight: FontWeight.bold,
                       //        color: Colors.grey
                       //      ),
                       //    ),


                      // Avatar + Camera/Gallery icon
                      const Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Add your avatar widgets here if needed
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Name field
                      CommonTextField(
                        label: 'Driving Experience in years',
                        hintText: 'Enter your driving experience',
                        controller: _drivingExperienceController,
                        keyboardType: TextInputType.number,
                        enabled: _isEditMode,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
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
                            label: 'Save',
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
