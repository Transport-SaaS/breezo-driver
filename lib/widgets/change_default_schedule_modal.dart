// import 'package:breezoapp1/core/utils/size_config.dart';
// import 'package:breezoapp1/views/widgets/common_button.dart';
// import 'package:breezoapp1/views/widgets/custom_time_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../core/viewmodels/office_schedule_viewmodel.dart';
// import '../../core/constants/app_colors.dart';

// class ChangeDefaultScheduleModal extends StatefulWidget {
//   final OfficeScheduleViewModel viewModel;

//   const ChangeDefaultScheduleModal({Key? key, required this.viewModel})
//     : super(key: key);

//   @override
//   State<ChangeDefaultScheduleModal> createState() =>
//       _ChangeDefaultScheduleModalState();
// }

// class _ChangeDefaultScheduleModalState
//     extends State<ChangeDefaultScheduleModal> {
//   final List<bool> selectedDays = [true, true, true, true, true, false, false];
//   final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
//   late TimeOfDay officeInTime;
//   late TimeOfDay officeOutTime;

//   @override
//   void initState() {
//     super.initState();
//     officeInTime = const TimeOfDay(hour: 10, minute: 30);
//     officeOutTime = const TimeOfDay(hour: 19, minute: 30);
//   }

//   String _formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
//     final period = time.hour < 12 ? 'am' : 'pm';
//     final minute = time.minute == 0 ? '00' : '30';
//     return '${hour.toString().padLeft(2, '0')}:$minute $period';
//   }

//   Future<void> _selectTime(BuildContext context, bool isOfficeIn) async {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: CustomTimePicker(
//           initialTime: isOfficeIn ? officeInTime : officeOutTime,
//           onTimeSelected: (TimeOfDay selectedTime) {
//             setState(() {
//               if (isOfficeIn) {
//                 officeInTime = selectedTime;
//               } else {
//                 officeOutTime = selectedTime;
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final dayButtonSize = (screenSize.width - 32 - (6 * 8)) / 7;

//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'SET DEFAULT SCHEDULE',
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),

//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ],
//             ),

//             Divider(color: Colors.grey.shade300),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(
//                 7,
//                 (index) => GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedDays[index] = !selectedDays[index];
//                     });
//                   },
//                   child: Container(
//                     width: dayButtonSize,
//                     height: dayButtonSize,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           selectedDays[index]
//                               ? AppColors.activeButton.withOpacity(0.1)
//                               : Colors.transparent,
//                       border: Border.all(
//                         color:
//                             selectedDays[index]
//                                 ? AppColors.activeButton
//                                 : Colors.grey.shade300,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         weekDays[index],
//                         style: TextStyle(
//                           color:
//                               selectedDays[index]
//                                   ? AppColors.activeButton
//                                   : Colors.grey.shade600,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),
//             Divider(color: Colors.grey.shade300),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),
//             // Office-In Section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Office-In',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                 ),
//                 InkWell(
//                   onTap: () => _selectTime(context, true),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 3,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(_formatTimeOfDay(officeInTime)),
//                         Icon(
//                           Icons.arrow_drop_down,
//                           color: Colors.grey.shade600,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),
//             Divider(color: Colors.grey.shade300),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),
//             // Office-Out time selector
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Office-Out',
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                 ),
//                 InkWell(
//                   onTap: () => _selectTime(context, false),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 3,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(40),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(_formatTimeOfDay(officeOutTime)),
//                         Icon(
//                           Icons.arrow_drop_down,
//                           color: Colors.grey.shade600,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),
//             Divider(color: Colors.grey.shade300),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),

//             // Your Address Section
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(left: 16, top: 16),
//                     child: Text(
//                       'Your Address',
//                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
//                   ),
//                   ListTile(
//                     title: const Text('Home'),
//                     subtitle: Text(
//                       widget.viewModel.homeAddress,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 13,
//                       ),
//                     ),
//                     trailing: Icon(
//                       Icons.keyboard_arrow_down,
//                       color: Colors.grey.shade600,
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Office Address Section
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(left: 16, top: 16),
//                     child: Text(
//                       'Office Address',
//                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
//                   ),
//                   ListTile(
//                     title: const Text('Bengaluru HQ'),
//                     subtitle: const Text(
//                       'A2, Block-C, ABC Techpark, Magarpattam, Bengaluru',
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 4, top: 8),

//               child: RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize:
//                         MediaQuery.of(context).size.width * 0.038, // ~16px
//                   ),
//                   children: const [
//                     TextSpan(
//                       text:
//                           'You can change your office address by selecting a different office location in ',
//                     ),
//                     TextSpan(
//                       text: 'Company Profile',
//                       style: TextStyle(color: AppColors.activeButton),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Padding(
//             //   padding: const EdgeInsets.only(left: 4, top: 8),
//             //   child: Text(
//             //     'You can change your office address by selecting a different office location in Company Profile',
//             //     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             //   ),
//             // ),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),
//             Divider(color: Colors.grey.shade300),
//             SizedBox(height: SizeConfig.blockSizeVertical * 1),

//             const SizedBox(height: 5),

//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: CommonButton(
//                     onPressed: () => Navigator.pop(context),

//                     isActive: true,
//                     label: "Cancel",
//                     activeColor: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: CommonButton(
//                     onPressed: () => Navigator.pop(context),

//                     isActive: true,
//                     label: "Save",
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
