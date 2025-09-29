import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/viewmodels/business_viewmodel.dart';
import 'package:breezodriver/features/auth/views/success_register_screen.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PartnerDetailsScreen extends StatefulWidget {
  const PartnerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PartnerDetailsScreen> createState() => _PartnerDetailsScreenState();
}

class _PartnerDetailsScreenState extends State<PartnerDetailsScreen> {
  final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarycolor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
          
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Working Schedule',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                     
                      const SizedBox(height: 24),
                      const Text(
                        'WORKING DAYS',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Consumer<BusinessViewModel>(
                        builder: (context, viewModel, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) => _buildDayButton(index, viewModel)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'WORKING HOURS',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
context.read<BusinessViewModel>().getWorkingHours(),
                              style: const TextStyle(color: AppColors.activeButton, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTimeSelection(),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CONTRACT DETAILS',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Container(
                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              context.read<BusinessViewModel>().getContractDuration(),
                              style: TextStyle(fontSize: 12, color: AppColors.activeButton),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _buildDateField('Contract Start', true)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildDateField('Contract End', false)),
                        ],
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.14),
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
                                                  const SuccessRegisterScreen(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton(int index, BusinessViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.toggleWorkingDay(index),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: viewModel.workingDays[index] 
            ? AppColors.activeButton 
            : Colors.grey.withOpacity(0.2),
        child: Text(
          weekDays[index],
          style: TextStyle(
            color: viewModel.workingDays[index] ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelection() {
    return Consumer<BusinessViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          _buildTimeDropdown('Shift Start', viewModel),
          const SizedBox(height: 16),
          _buildTimeDropdown('Shift End', viewModel),
        ],
      ),
    );
  }

  Widget _buildTimeDropdown(String label, BusinessViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              // Hours dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<int>(
                  value: label == 'Shift Start' ? viewModel.shiftStartHour : viewModel.shiftEndHour,
                  items: BusinessViewModel.hours.map((hour) => DropdownMenuItem(
                    value: hour,
                    child: Text(hour.toString().padLeft(2, '0')),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      if (label == 'Shift Start') {
                        viewModel.setShiftStart(
                          hour: value,
                          minute: viewModel.shiftStartMinute,
                          isAm: viewModel.shiftStartIsAm,
                        );
                      } else {
                        viewModel.setShiftEnd(
                          hour: value,
                          minute: viewModel.shiftEndMinute,
                          isAm: viewModel.shiftEndIsAm,
                        );
                      }
                    }
                  },
                  underline: const SizedBox(),
                ),
              ),
              const SizedBox(width: 8),
              // Minutes dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<int>(
                  value: label == 'Shift Start' ? viewModel.shiftStartMinute : viewModel.shiftEndMinute,
                  items: BusinessViewModel.minutes.map((minute) => DropdownMenuItem(
                    value: minute,
                    child: Text(minute.toString().padLeft(2, '0')),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      if (label == 'Shift Start') {
                        viewModel.setShiftStart(
                          hour: viewModel.shiftStartHour,
                          minute: value,
                          isAm: viewModel.shiftStartIsAm,
                        );
                      } else {
                        viewModel.setShiftEnd(
                          hour: viewModel.shiftEndHour,
                          minute: value,
                          isAm: viewModel.shiftEndIsAm,
                        );
                      }
                    }
                  },
                  underline: const SizedBox(),
                ),
              ),
              const SizedBox(width: 8),
              // AM/PM dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<bool>(
                  value: label == 'Shift Start' ? viewModel.shiftStartIsAm : viewModel.shiftEndIsAm,
                  items: BusinessViewModel.amPm.map((isAm) => DropdownMenuItem(
                    value: isAm,
                    child: Text(isAm ? 'AM' : 'PM'),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      if (label == 'Shift Start') {
                        viewModel.setShiftStart(
                          hour: viewModel.shiftStartHour,
                          minute: viewModel.shiftStartMinute,
                          isAm: value,
                        );
                      } else {
                        viewModel.setShiftEnd(
                          hour: viewModel.shiftEndHour,
                          minute: viewModel.shiftEndMinute,
                          isAm: value,
                        );
                      }
                    }
                  },
                  underline: const SizedBox(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, bool isStart) {
    return Consumer<BusinessViewModel>(
      builder: (context, viewModel, _) => InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.timestamp(),
            firstDate: DateTime.timestamp(),
            lastDate: DateTime.timestamp().add(const Duration(days: 365 * 5)),
          );
          if (picked != null) {
            if (isStart) {
              viewModel.setContractStart(picked);
            } else {
              viewModel.setContractEnd(picked);
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                isStart 
                    ? viewModel.contractStart?.toString().split(' ')[0] ?? 'Select Date'
                    : viewModel.contractEnd?.toString().split(' ')[0] ?? 'Select Date',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
