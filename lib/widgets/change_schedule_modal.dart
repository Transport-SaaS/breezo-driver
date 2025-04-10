// import 'package:breezoapp1/core/utils/size_config.dart';
// import 'package:breezoapp1/views/widgets/common_button.dart';
// import 'package:breezoapp1/views/widgets/custom_time_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../core/viewmodels/office_schedule_viewmodel.dart';
// import '../../core/constants/app_colors.dart';

// class ChangeScheduleModal extends StatefulWidget {
//   final DateTime date;
//   final OfficeScheduleViewModel viewModel;

//   const ChangeScheduleModal({
//     Key? key,
//     required this.date,
//     required this.viewModel,
//   }) : super(key: key);

//   @override
//   State<ChangeScheduleModal> createState() => _ChangeScheduleModalState();
// }

// class _ChangeScheduleModalState extends State<ChangeScheduleModal> {
//   late TimeOfDay officeInTime;
//   late TimeOfDay officeOutTime;
//   bool setAsDefault = false;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with values from viewModel or defaults
//     officeInTime = const TimeOfDay(hour: 10, minute: 30);
//     officeOutTime = const TimeOfDay(hour: 19, minute: 30);
//   }

//   String _formatTimeOfDay(TimeOfDay time) {
//     // Convert to 12-hour format with am/pm
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
//                   'CHANGE SCHEDULE',
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   '${DateFormat('EEE, dd MMM yyyy').format(widget.date).toUpperCase()}',
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: AppColors.primarycolor,
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

//             Divider(color: Colors.grey.withOpacity(0.3)),
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

//             // Checkbox
//             Row(
//               children: [
//                 SizedBox(
//                   height: 24,
//                   width: 24,
//                   child: Checkbox(
//                     value: false,
//                     onChanged: (value) {},
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'Set as default for all upcoming days',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

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
