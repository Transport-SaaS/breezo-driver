// import 'package:breezoapp1/views/screens/office_details_screen.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/views/business_selection_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/common_textfield.dart';
import '../widgets/common_button.dart';

class LocationDetailsModal extends StatefulWidget {
  final String address;
  final String placeName;
  final bool isFromAllAddress;

  const LocationDetailsModal({
    Key? key,
    required this.address,
    required this.placeName,
    this.isFromAllAddress = false,
  }) : super(key: key);

  @override
  State<LocationDetailsModal> createState() => _LocationDetailsModalState();
}

class _LocationDetailsModalState extends State<LocationDetailsModal> {
  final _buildingController = TextEditingController();
  final _areaController = TextEditingController();
  final _customLocationController = TextEditingController();
  String _selectedLocationType = 'home'; // Default selection

  @override
  void dispose() {
    _buildingController.dispose();
    _areaController.dispose();
    _customLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primarycolor),

                    Text(
                      widget.placeName.length > 40
                          ? widget.placeName.substring(0, 40) + '...'
                          : widget.placeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.address,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 16),
            CommonTextField(
              label: 'Plot No./ Building No.',
              hintText: 'Eg. Sridhar Heights',
              controller: _buildingController,
            ),
            const SizedBox(height: 16),
            CommonTextField(
              label: 'Area/ Locality',
              hintText: 'Eg. Nehru Nagar',
              controller: _areaController,
            ),
            const SizedBox(height: 24),
            const Text(
              'SAVE LOCATION AS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildLocationTypeChip(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: _selectedLocationType == 'home',
                  onTap: () => setState(() => _selectedLocationType = 'home'),
                ),
                const SizedBox(width: 12),
                _buildLocationTypeChip(
                  icon: Icons.location_on,
                  label: 'Other',
                  isSelected: _selectedLocationType == 'other',
                  onTap: () => setState(() => _selectedLocationType = 'other'),
                ),
              ],
            ),

            // Conditional TextField for custom location name
            if (_selectedLocationType == 'other') ...[
              const SizedBox(height: 24),
              CommonTextField(
                label: 'Name this location',
                hintText: 'Eg. Office, Gym, etc.',
                controller: _customLocationController,
              ),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CommonButton(
                label: widget.isFromAllAddress ? 'Add Address' : 'Confirm Location',
                isActive: true,
                onPressed: () {
                  // Handle confirmation and close modal
                    if (widget.isFromAllAddress==false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusinessSelectionScreen(),
                      ),
                    );
                  } else {
                    Navigator.pop(context, {
                      'address': widget.address,
                      'placeName': widget.placeName,
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTypeChip({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primarycolor : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(20),
          color:
              isSelected
                  ? AppColors.primarycolor.withOpacity(0.1)
                  : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primarycolor : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? AppColors.primarycolor : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
