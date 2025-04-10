
import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:flutter/material.dart';


class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePicker({
    Key? key,
    required this.initialTime,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late int selectedHour;
  late int selectedMinute;
  late bool isAm;

  @override
  void initState() {
    super.initState();
    // Convert 24-hour format to 12-hour format
    final hour = widget.initialTime.hour;
    selectedHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    selectedMinute = widget.initialTime.minute >= 30 ? 30 : 0;
    isAm = widget.initialTime.hour < 12;
  }

  void _selectTime() {
    // Convert back to 24-hour format
    int hour = selectedHour;
    if (!isAm) {
      hour = hour == 12 ? 12 : hour + 12;
    } else {
      hour = hour == 12 ? 0 : hour;
    }

    final time = TimeOfDay(hour: hour, minute: selectedMinute);
    widget.onTimeSelected(time);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Hours
              Column(
                children: [
                  const Text('Hour'),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final hour = index + 1; // 1-12
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedHour = hour;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  selectedHour == hour
                                      ? AppColors.primarycolor.withOpacity(0.2)
                                      : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                hour.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontWeight:
                                      selectedHour == hour
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Minutes
              Column(
                children: [
                  const Text('Minute'),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMinute = 0;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  selectedMinute == 0
                                      ? AppColors.primarycolor.withOpacity(0.2)
                                      : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '00',
                                style: TextStyle(
                                  fontWeight:
                                      selectedMinute == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMinute = 30;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  selectedMinute == 30
                                      ? AppColors.primarycolor.withOpacity(0.2)
                                      : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                '30',
                                style: TextStyle(
                                  fontWeight:
                                      selectedMinute == 30
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // AM/PM
              Column(
                children: [
                  const Text('AM/PM'),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAm = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  isAm
                                      ? AppColors.primarycolor.withOpacity(0.2)
                                      : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'AM',
                                style: TextStyle(
                                  fontWeight:
                                      isAm
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isAm = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  !isAm
                                      ? AppColors.primarycolor.withOpacity(0.2)
                                      : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                'PM',
                                style: TextStyle(
                                  fontWeight:
                                      !isAm
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(

            // width: SizeConfig.blockSizeHorizontal * 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: CommonButton(
                    label: "Cancel",
                    isActive: true,
                    onPressed: () => Navigator.pop(context),
                    activeColor: Colors.grey.shade300,
                  ),
                ),
                SizedBox(width:SizeConfig.blockSizeHorizontal * 4,),
                Expanded(
                  child: CommonButton(
                    label: "Save",
                    isActive: true,
                    onPressed: _selectTime,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
