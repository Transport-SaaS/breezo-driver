import 'package:breezodriver/features/trips/viewmodels/trip_details_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:flutter/material.dart';

class TripRejectionModal extends StatefulWidget {
  final TripDetailsViewModel viewModel;
  final VoidCallback onClose;
  final String? title;
  final String? subtitle1;
  final String? richText;
  final String? subtitle2;
  final String? buttonText;

  const TripRejectionModal({
    Key? key,
    required this.viewModel,
    required this.onClose,
    this.title="Reject Trip",
    this.subtitle1="Trip can be rejected only in an emergency. A ",
    this.subtitle2="for false rejections.",
    this.buttonText="Reject Trip",
    this.richText="penalty will be charged ",
  }) : super(key: key);

  @override
  State<TripRejectionModal> createState() => _TripRejectionModalState();
}

class _TripRejectionModalState extends State<TripRejectionModal> {
  final List<String> _rejectionReasons = [
    'Safety Concerns',
    'Vehicle Breakdown',
    'Personal Emergency',
    'Route Issue/Traffic',
    'Severe Weather Conditions',
    'Police or legal issue',
    'Accident Involvement',
  ];

  String? _selectedReason;

  @override
  void initState() {
    super.initState();
    // Initialize with the first reason selected
    _selectedReason = _rejectionReasons.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Warning text
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(
                  text: widget.subtitle1!,
                ),
                TextSpan(
                  text: widget.richText!,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: widget.subtitle2!),
              ],
            ),
          ),

          const Divider(height: 24, thickness: 1),

          // Reason text
          const Text(
            'Reason for cancelling',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          // Radio button list
          ...List.generate(
            _rejectionReasons.length,
            (index) => _buildRadioOption(_rejectionReasons[index]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
            child: Divider(color: Colors.grey.shade300, height: 1),
          ),

          // Buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CommonButton(
                  label: widget.buttonText!,
                  onPressed: () {
                    if (_selectedReason != null) {
                      widget.viewModel.setRejectionReason(_selectedReason!);
                      widget.viewModel.rejectTrip();
                    }
                    Navigator.pop(context);
                  },
                  isActive: true,
                  activeColor: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: widget.onClose,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Go back',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String reason) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedReason = reason;
          });
        },
        child: Row(
          children: [
            Radio<String>(
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
              activeColor: Colors.black,
            ),
            Text(reason, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
