// lib/views/screens/phone_number_screen.dart

import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/viewmodels/otp_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/custom_loader.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'otp_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  // Returns true if the phone number has exactly 10 digits.
  bool get isPhoneValid => _phoneController.text.trim().length == 10;

  @override
  void initState() {
    super.initState();
    // Listen to changes in the phone field and rebuild when updated.
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onNextPressed() async {
    if (!isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final viewModel = context.read<OtpViewModel>();
      final success = await viewModel.generateOTP(_phoneController.text.trim());
      
      if (success) {
        if (mounted) {
          CherryToast.info(
            disableToastAnimation: true,
            title: const Text(
              'OTP sent successfully',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            iconWidget: Icon(Icons.check_circle, color: Colors.green),
            inheritThemeColors: true,
            actionHandler: () {},
            onToastClosed: () {},
          ).show(context);
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OtpScreen()),
          );
        }
      } else {
        if (mounted) {
           CherryToast.info(
            disableToastAnimation: true,
            title: const Text(
              'Oops! There was an error sending the OTP.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            iconWidget: Icon(Icons.error_outline, color: Colors.red),
            inheritThemeColors: true,
            actionHandler: () {},
            onToastClosed: () {},
          ).show(context);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarycolor,
      // Allow the layout to resize when the keyboard appears.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top progress bar area.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: const ProgressBar(currentStep: 1),
                ),
                // White container that fills the remaining space.
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 32),
                    // Use LayoutBuilder + ConstrainedBox + IntrinsicHeight to ensure
                    // the content fills the available space and the button stays at the bottom.
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title.
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: const Text(
                                      'Enter your phone number to get started',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Phone number field in a single rectangular box.
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          '+91',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextField(
                                            controller: _phoneController,
                                            keyboardType: TextInputType.phone,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(10),
                                            ],
                                            decoration: InputDecoration(
                                              hintText: '0000000000',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade400,
                                              ),
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Expanded spacer pushes the button to the bottom.
                                  Expanded(child: Container()),
                                  // "Next" button with padding only from the top.
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: CommonButton(
                                        label: 'Next',
                                        isActive: isPhoneValid && !_isLoading,
                                        onPressed: _isLoading ? null : _onNextPressed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const CustomLoader(),
              ),
          ],
        ),
      ),
    );
  }
}

// Stub OtpScreen so this file compiles.
