import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/features/trips/viewmodels/trip_details_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationModal extends StatefulWidget {
  final TripDetailsViewModel viewModel;
  final Passenger passenger;

  const OtpVerificationModal({
    Key? key,
    required this.viewModel,
    required this.passenger,
  }) : super(key: key);

  @override
  State<OtpVerificationModal> createState() => _OtpVerificationModalState();
}

class _OtpVerificationModalState extends State<OtpVerificationModal> with SingleTickerProviderStateMixin {
  late final TextEditingController _otpController;
  bool _isVerifying = false;
  String? _errorText;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    
    // Set up animation for the modal
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 4) {
      setState(() {
        _errorText = 'Please enter a 4-digit OTP';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    bool isVerified = await widget.viewModel.verifyOtp(
      widget.passenger.id, 
      _otpController.text
    );

    if (!mounted) return;

    if (isVerified) {
      // Close the modal with success
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isVerifying = false;
        _errorText = 'Invalid OTP. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _getAvatarColor(widget.passenger.initials),
                  child: Text(
                    widget.passenger.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.passenger.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Enter 4-digit OTP provided by the passenger',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // OTP Input
            Pinput(
              controller: _otpController,
              length: 4,
              defaultPinTheme: PinTheme(
                width: 70,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 70,
                height: 60,
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primarycolor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: 70,
                height: 60,
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primarycolor,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primarycolor),
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primarycolor.withOpacity(0.1),
                ),
              ),
              onCompleted: (_) => _verifyOtp(),
            ),
            
            if (_errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            
            const SizedBox(height: 30),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: CommonButton(
                label: _isVerifying ? 'Verifying...' : 'Continue',
                onPressed: _isVerifying ? null : _verifyOtp,
                activeColor: AppColors.primarycolor,
                inactiveColor: Colors.grey.shade300,
                isActive: !_isVerifying,
              ),
            ),
            
            // Add padding at the bottom to avoid system buttons
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
  
  Color _getAvatarColor(String initials) {
    // Map initials to specific colors to match the screenshot
    const Map<String, Color> colorMap = {
      'BK': Color(0xFF6B7280), // Grey
      'BM': Color(0xFFEC4899), // Pink
      'AG': Color(0xFF8B5CF6), // Purple
      'VB': Color(0xFFEF4444), // Red
      'KE': Color(0xFF10B981), // Green
      'MV': Color(0xFF3B82F6), // Blue
    };

    return colorMap[initials] ?? Colors.blue;
  }
} 