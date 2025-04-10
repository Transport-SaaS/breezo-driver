import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/views/personal_details_screen.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarycolor,
      // Allow the layout to resize when the keyboard appears.
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Top progress bar area.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: const ProgressBar(currentStep: 2),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 32,
                ),
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
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 44),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: const Text(
                                  'Please enter the OTP sent to +91827364520',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Phone number field in a single rectangular box.
                              _buildPinput(),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  LoadingAnimationWidget.horizontalRotatingDots(
                                    color: AppColors.activeButton,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Auto fetching OTP',
                                    style: TextStyle(
                                      color: AppColors.activeButton,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Retry in 00:30',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                                    label: 'Continue',
                                    isActive: true,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const PersonalDetailsScreen(),
                                        ),
                                      );
                                    },
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
      ),
    );
  }

  /// Builds the 4-digit PIN input using Pinput.
  Widget _buildPinput() {
    return Pinput(
      length: 4,
      // controller: _otpController,
      // Attempts to auto-fill from incoming SMS on Android
      // listenForMultipleSmsOnAndroid: true,
      // Default box style
      defaultPinTheme: PinTheme(
        width: 56,

        height: 56,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Focused box style
      focusedPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: AppColors.primarycolor),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Called on every input change
      onChanged: (value) => setState(() {}),
      // Called when the user has entered all 4 digits
      onCompleted: (pin) => setState(() {}),
    );
  }
}
