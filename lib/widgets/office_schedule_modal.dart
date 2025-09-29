// import 'package:breezoapp1/views/screens/main_navigation_screen.dart';
// import 'package:breezoapp1/views/widgets/custom_time_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../core/constants/app_colors.dart';
// import '../widgets/common_button.dart';

// class OfficeScheduleModal extends StatefulWidget {
//   final String officeName;
//   final String officeAddress;
//   final bool isEdit;

//   const OfficeScheduleModal({
//     Key? key,
//     required this.officeName,
//     required this.officeAddress,
//     this.isEdit = false,
//   }) : super(key: key);

//   @override
//   State<OfficeScheduleModal> createState() => _OfficeScheduleModalState();
// }

// class _OfficeScheduleModalState extends State<OfficeScheduleModal> {
//   final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
//   final List<bool> selectedDays = [true, true, true, true, true, false, false];
//   TimeOfDay officeInTime = const TimeOfDay(hour: 10, minute: 30);
//   TimeOfDay officeOutTime = const TimeOfDay(hour: 19, minute: 30);

//   String _formatTimeOfDay(TimeOfDay time) {
//     final now = DateTime.timestamp();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     return DateFormat('hh:mm a').format(dt).toLowerCase();
//   }

//  Future<void> _selectTime(BuildContext context, bool isOfficeIn) async {
//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: CustomTimePicker(
//         initialTime: isOfficeIn ? officeInTime : officeOutTime,
//         onTimeSelected: (TimeOfDay selectedTime) {
//           setState(() {
//             if (isOfficeIn) {
//               officeInTime = selectedTime;
//             } else {
//               officeOutTime = selectedTime;
//             }
//           });
//         },
//       ),
//     ),
//   );
// }


//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final dayButtonSize = (screenSize.width - 32 - (6 * 8)) / 7;

//     return Container(
//       alignment: Alignment.bottomCenter,
//       child: Stack(
//         children: [
//           // Black background container
//           Container(
//             padding: EdgeInsets.only(top: 7, bottom: 5),
//             width: double.infinity,
//             height: screenSize.height * 0.44,
//             decoration: const BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//             ),
//             child: Column(
//               children: [
//                 Text(
//                   'This will be used for your smooth pickup and drop',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),

//           // White content container - Positioned at the bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: EdgeInsets.fromLTRB(
//                 16,
//                 16,
//                 16,
//                 MediaQuery.of(context).padding.bottom + 16,
//               ),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'SET OFFICE SCHEDULE',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Day selector row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: List.generate(
//                       7,
//                       (index) => GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedDays[index] = !selectedDays[index];
//                           });
//                         },
//                         child: Container(
//                           width: dayButtonSize,
//                           height: dayButtonSize,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color:
//                                 selectedDays[index]
//                                     ? AppColors.activeButton.withOpacity(0.1)
//                                     : Colors.transparent,
//                             border: Border.all(
//                               color:
//                                   selectedDays[index]
//                                       ? AppColors.activeButton
//                                       : Colors.grey.shade300,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               weekDays[index],
//                               style: TextStyle(
//                                 color:
//                                     selectedDays[index]
//                                         ? AppColors.activeButton
//                                         : Colors.grey.shade600,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Divider(color: Colors.grey.shade300),
//                   const SizedBox(height: 10),
//                   // Office-In time selector
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Office-In',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () => _selectTime(context, true),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(_formatTimeOfDay(officeInTime)),
//                               Icon(
//                                 Icons.arrow_drop_down,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Divider(color: Colors.grey.shade300),
//                   const SizedBox(height: 10),
//                   // Office-Out time selector
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Office-Out',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () => _selectTime(context, false),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 3,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(_formatTimeOfDay(officeOutTime)),
//                               Icon(
//                                 Icons.arrow_drop_down,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   // Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: CommonButton(
//                       label: "Let's Start",
//                       isActive: true,
//                       onPressed: () {
//                         Navigator.pop(context, {
//                           'selectedDays': selectedDays,
//                           'officeInTime': officeInTime,
//                           'officeOutTime': officeOutTime,
//                         });
//                         if (!widget.isEdit) {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                           MaterialPageRoute(
//                             builder: (context) => MainNavigationScreen(),
//                           ),
//                           (route) => false,
//                         );
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
