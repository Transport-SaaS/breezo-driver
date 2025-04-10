// import 'package:breezoapp1/core/constants/app_assets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart' show SvgPicture;
// import '../../core/utils/size_config.dart';
// import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

// class ScheduledTripCard extends StatefulWidget {
//   final String date;
//   final String startTime;
//   final String startLocation;
//   final String startAddress;
//   final String endTime;
//   final String endLocation;
//   final String endAddress;
//   final String lockTime;
//   final VoidCallback onChangePressed;
//   final VoidCallback onMorePressed;
//   final bool isScheduled;
//   final bool isCompleted;
//   const ScheduledTripCard({
//     super.key,
//     required this.date,
//     required this.startTime,
//     required this.startLocation,
//     required this.startAddress,
//     required this.endTime,
//     required this.endLocation,
//     required this.endAddress,
//     required this.lockTime,
//     required this.onChangePressed,
//     required this.onMorePressed,
//     required this.isCompleted,
//     this.isScheduled = true,
//   });

//   @override
//   State<ScheduledTripCard> createState() => _ScheduledTripCardState();
// }

// class _ScheduledTripCardState extends State<ScheduledTripCard> {
//   double _rating = 0.0;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       margin: EdgeInsets.symmetric(vertical: 15),
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//           ),
//         ],
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.white,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color:
//                       widget.isCompleted
//                           ? Colors.green.withOpacity(0.1)
//                           : Colors.amber[50],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   widget.isCompleted && widget.isScheduled == false
//                       ? 'Completed'
//                       : widget.isCompleted == false &&
//                           widget.isScheduled == false
//                       ? "Ongoing"
//                       : 'Scheduled',
//                   style: TextStyle(
//                     color: widget.isCompleted ? Colors.green : Colors.amber,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 widget.date,
//                 style: TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//               Spacer(),
//               IconButton(
//                 onPressed: widget.onMorePressed,
//                 icon: Icon(Icons.more_horiz),
//                 padding: EdgeInsets.zero,
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),
//           // --- ICONS WITH DOTTED LINE ---
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Column(
//                 children: [
//                   SvgPicture.asset(
//                     AppAssets.homeSchedule,
//                     color: Colors.green,
//                     height: SizeConfig.getProportionateScreenWidth(18),
//                   ),
//                   _DottedLine(
//                     height: SizeConfig.getProportionateScreenHeight(30),
//                   ),
//                   SvgPicture.asset(
//                     AppAssets.business,
//                     color: Colors.green.shade900,
//                     height: SizeConfig.getProportionateScreenWidth(16),
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Home row
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           '${widget.startTime}  ${widget.startLocation}',
//                           style: TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             widget.startAddress,
//                             style: TextStyle(color: Colors.grey, fontSize: 12),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: SizeConfig.getProportionateScreenHeight(25),
//                     ),
//                     // Office row
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           '${widget.endTime}  ${widget.endLocation}',
//                           style: TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             widget.endAddress,
//                             style: TextStyle(color: Colors.grey, fontSize: 12),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 8),
//             child: Divider(height: 1, color: Colors.grey[300]),
//           ),
//           widget.isCompleted == false
//               ? Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: widget.onChangePressed,
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       minimumSize: Size(0, 0),
//                     ),
//                     child: const Text(
//                       'Change',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.red,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         'Your trip will be locked in ',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: SizeConfig.blockSizeHorizontal * 3,
//                         ),
//                       ),
//                       Text(
//                         widget.lockTime,
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.w500,
//                           fontSize: SizeConfig.blockSizeHorizontal * 3,
//                         ),
//                       ),
//                       SizedBox(width: SizeConfig.blockSizeHorizontal * 1),
//                       SvgPicture.asset(
//                         AppAssets.time,

//                         color: Colors.red,
//                         height: SizeConfig.getProportionateScreenWidth(12),
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//               : Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "You reached your destination in 42 mins.",
//                     style: TextStyle(color: Colors.grey[400], fontSize: 11),
//                   ),
//                   RatingBar(
//                     iconSize: SizeConfig.getProportionateScreenWidth(
//                       18,
//                     ), // Size of the rating icons
//                     allowHalfRating: true, // Allows selection of half ratings
//                     filledIcon:
//                         Icons.star, // Icon to display for a filled rating unit
//                     halfFilledIcon:
//                         Icons
//                             .star_half, // Icon to display for a half-filled rating unit
//                     emptyIcon:
//                         Icons
//                             .star_border, // Icon to display for an empty rating units
//                     filledColor: Colors.amber, // Color of filled rating units
//                     emptyColor: Colors.grey, // Color of empty rating units
//                     currentRating: _rating, // Set initial rating value
//                     onRatingChanged: (rating) {
//                       // Callback triggered when the rating is changed
//                       setState(() {
//                         _rating = rating;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//         ],
//       ),
//     );
//   }
// }

// /// A small custom widget to draw a vertical dotted line.
// /// You can adjust [height], [color], [dashHeight], and [dashSpace] as needed.
// class _DottedLine extends StatelessWidget {
//   final double height;
//   final Color color;
//   const _DottedLine({Key? key, this.height = 40, this.color = Colors.grey})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(1, height),
//       painter: _DottedLinePainter(color),
//     );
//   }
// }

// class _DottedLinePainter extends CustomPainter {
//   final Color color;
//   _DottedLinePainter(this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     double dashHeight = 4, dashSpace = 4;
//     final paint =
//         Paint()
//           ..color = color
//           ..strokeWidth = 1;

//     double startY = 0;
//     while (startY < size.height) {
//       canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
//       startY += dashHeight + dashSpace;
//     }
//   }

//   @override
//   bool shouldRepaint(_DottedLinePainter oldDelegate) => false;
// }
