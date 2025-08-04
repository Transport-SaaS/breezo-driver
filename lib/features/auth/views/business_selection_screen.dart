import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/auth/views/success_register_screen.dart';
import 'package:breezodriver/features/profile/viewmodels/driver_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:breezodriver/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/business_viewmodel.dart';

class BusinessSelectionScreen extends StatefulWidget {
  const BusinessSelectionScreen({Key? key}) : super(key: key);

  @override
  State<BusinessSelectionScreen> createState() => _BusinessSelectionScreenState();
}

class _BusinessSelectionScreenState extends State<BusinessSelectionScreen> {
  final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  String transporterOfficeName = 'Taxi GEO Transport Pvt. Ltd.';
  String transporterOfficeAddress = '15, Ashok Marg, Hazratganj, Lucknow';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransporterDetails();
    _loadDefaultWorkingSchedule();
  }
  Future<void> _loadTransporterDetails() async {
    final driverViewModel = Provider.of<DriverViewModel>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await driverViewModel.loadTransporterOfficeDetails();

      if (success && driverViewModel.transporterOfficeModel != null) {
        setState(() {
          transporterOfficeName = driverViewModel.transporterOfficeModel!.officeName;
          transporterOfficeAddress = driverViewModel.transporterOfficeModel!.officeAddress;
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load company details')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDefaultWorkingSchedule() async {
    final driverViewModel = Provider.of<DriverViewModel>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await driverViewModel.loadWorkingSchedule();

      final businessViewModel = Provider.of<BusinessViewModel>(context, listen: false);
      if (success && driverViewModel.workingSchedule != null) {
        setState(() {
          businessViewModel.setWorkingDays(driverViewModel.workingSchedule!.getSelectedDays());
          int hour = driverViewModel.workingSchedule!.getLoginTimeOfDay().hour;
          if (hour > 12) {
            hour -= 12; // Convert to 12-hour format
          } else if (hour == 0) {
            hour = 12; // Handle midnight case
          }
          businessViewModel.setShiftStart(hour:hour,
            minute: driverViewModel.workingSchedule!.getLoginTimeOfDay().minute,
            isAm: driverViewModel.workingSchedule!.getLoginTimeOfDay().period == DayPeriod.am
          );
          hour = driverViewModel.workingSchedule!.getLogoutTimeOfDay().hour;
          if (hour > 12) {
            hour -= 12; // Convert to 12-hour format
          } else if (hour == 0) {
            hour = 12; // Handle midnight case
          }
          businessViewModel.setShiftEnd(hour:hour,
              minute: driverViewModel.workingSchedule!.getLogoutTimeOfDay().minute,
              isAm: driverViewModel.workingSchedule!.getLogoutTimeOfDay().period == DayPeriod.am
          );
        });
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load company details')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> onSubmit() async{
    // Handle form submission logic here
    final driverViewModel = Provider.of<DriverViewModel>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    try {
      final success = await driverViewModel.saveContractDetails(
        contractStartDate: context.read<BusinessViewModel>().contractStart!,
        contractEndDate: context.read<BusinessViewModel>().contractEnd!
      );
      print("Contract saved successfully: $success");

      final businessViewModel = Provider.of<BusinessViewModel>(context, listen: false);
      final successDays = await driverViewModel.saveWorkingSchedule(
        businessViewModel.workingDays,
        _formatTimeOfDay(businessViewModel.shiftStart),
        _formatTimeOfDay(businessViewModel.shiftEnd)
      );
      print("Working schedule saved successfully: $successDays");

      if (success && successDays) {
        print("Contract and working schedule saved successfully");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessRegisterScreen(),
          ),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load company details')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarycolor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: ProgressBar(currentStep: 3),
            ),
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
                child: _isLoading ? const Center(child: CircularProgressIndicator()):
                SingleChildScrollView(
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
                            'Business Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'REPORTING HUB ADDRESS',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(

                        leading: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset('assets/images/business.png', width: 60, fit: BoxFit.cover))),
                        title: Text(transporterOfficeName),
                        subtitle: Text(transporterOfficeAddress),
                        contentPadding: EdgeInsets.zero,
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
                              style: const TextStyle(fontSize: 12, color: AppColors.activeButton),
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
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: CommonButton(
                            label: 'Continue',
                            isActive: true,
                            onPressed: onSubmit,
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
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
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
