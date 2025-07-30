import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/profile/viewmodels/driver_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/custom_loader.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pinput/pinput.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'personal_details_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  bool get isOtpValid => _otpController.text.trim().length == 4;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _onVerifyPressed() async {
    if (!isOtpValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP')),
      );
      return;
    }

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final success = await authViewModel.verifyOTP(_otpController.text.trim());

    final viewModel = Provider.of<DriverViewModel>(context, listen: false);
    if (success) {
      if (mounted) {
        CherryToast.info(
          disableToastAnimation: true,
          title: const Text(
            'OTP verified successfully',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          iconWidget: const Icon(Icons.check_circle, color: Colors.green),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {
          
          },
        ).show(context);
          // Navigate based on driver status
        viewModel.loadDriverData();
        if (viewModel.hasOpenAccount) {
          // Navigate to home screen or dashboard
          // Navigator.pushReplacementNamed(context, '/home');
          // Fix the navigation - previously missing Navigator.pushReplacement
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PersonalDetailsScreen(),
            ),
          );
        } else {
          // Navigate to personal details screen with profile data if available
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const PersonalDetailsScreen(),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        CherryToast.error(
          disableToastAnimation: true,
          title: Text(
            viewModel.errorMessage,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          iconWidget: const Icon(Icons.error_outline, color: Colors.red),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {},
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: ProgressBar(currentStep: 2),
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
                                    child: const Icon(
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
                                        label: 'Verify',
                                        isActive: isOtpValid && !viewModel.isLoading,
                                        onPressed: viewModel.isLoading ? null : _onVerifyPressed,
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
            if (viewModel.isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const CustomLoader(),
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
      controller: _otpController,
      // listenForMultipleSmsOnAndroid: true,
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
      onChanged: (value) => setState(() {}),
      onCompleted: (pin) => setState(() {
        _otpController.text = pin;
      }),
    );
  }
}
