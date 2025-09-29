import 'dart:math';

import 'package:breezodriver/core/utils%20copy/size_config.dart';
import 'package:breezodriver/core/utils/app_assets.dart';
import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/widgets/info_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

import '../core/utils/utils.dart';

class ScheduledTripCard extends StatefulWidget {
  final String assignedAt;
  final String startTime;
  final String startLocation;
  final String endTime;
  final String endLocation;
  final String duration;
  final String distance;
  final int passengers;
  final String acceptBeforeTime;
  final String status;
  // Add this to the ScheduledTripCard class parameters
  final Function()? onTap;
  
  const ScheduledTripCard({
    super.key,
    required this.assignedAt,
    required this.startTime,
    required this.startLocation,
    required this.endTime,
    required this.endLocation,
    required this.duration,
    required this.distance,
    required this.passengers,
    required this.acceptBeforeTime,
    required this.status,
    this.onTap,
  });
  
  @override
  State<ScheduledTripCard> createState() => _ScheduledTripCardState();
}

class _ScheduledTripCardState extends State<ScheduledTripCard> {
  @override
  Widget build(BuildContext context) {
    final Color pickupTagColor = Colors.cyan.shade100.withOpacity(0.6);
    final Color pickupTagTextColor = Colors.cyan.shade800;
    final Color iconBackgroundColor = Colors.purple.shade50;
    final Color iconColor = Colors.deepPurple.shade400;
    final Color chipBackgroundColor = Colors.grey.shade200;
    final Color chipTextColor = Colors.grey.shade800;
    final Color acceptBeforeColor = Colors.red.shade600;
    final Color dottedLineColor = Colors.deepPurple.shade400;

    final bool isAssigned = widget.status.contains('assigned');
    final bool isAccepted = widget.status.contains('accepted');
    final bool isMissed = widget.status.contains('missed');
    final bool isCompleted = widget.status.contains('completed');

    String tagText = 'PICKUP';
    Color tagBgColor = pickupTagColor;
    Color tagTextColor = pickupTagTextColor;
    
    if (isAccepted) {
      tagText = 'ACCEPTED';
      tagBgColor = Colors.green.shade100.withOpacity(0.6);
      tagTextColor = Colors.green.shade800;
    } else if (isMissed) {
      tagText = 'MISSED';
      tagBgColor = Colors.red.shade100.withOpacity(0.6);
      tagTextColor = Colors.red.shade800;
    } else if (isCompleted) {
      tagText = 'COMPLETED';
      tagBgColor = Colors.purple.shade100.withOpacity(0.6);
      tagTextColor = Colors.purple.shade800;
    }

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    border: Border.all(
                      color: tagTextColor,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tagText,
                    style: TextStyle(
                      color: tagTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Text(
                //   'Assigned at: ${widget.assignedAt}',
                //   style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                // ),
              ],
            ),
            const SizedBox(height: 16),
      
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child:  SvgPicture.asset(
                      AppAssets.homeSchedule,
                      color: AppColors.primarycolor,
                      height: SizeConfig.getProportionateScreenWidth(14),
                    ),
                    ),
                    _DottedLine(height: SizeConfig.blockSizeVertical*5.8, color: dottedLineColor),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child:SvgPicture.asset(
                      AppAssets.business,
                      color: AppColors.primarycolor,
                      height: SizeConfig.getProportionateScreenWidth(12),
                    ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
      
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.startTime,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Start',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.startLocation,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
      
                      // Info chips row
                      Row(
                        children: [
                          buildInfoChip(Icons.schedule, widget.duration, chipBackgroundColor, chipTextColor),
                          const SizedBox(width: 8),
                          buildInfoChip(Icons.directions_car_filled_outlined, widget.distance, chipBackgroundColor, chipTextColor),
                          const SizedBox(width: 8),
                          buildInfoChip(Icons.people_outline, widget.passengers.toString(), chipBackgroundColor, chipTextColor),
                        ],
                      ),
                      const SizedBox(height: 16),
      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.endTime,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Destination',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.endLocation,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey[300]),
            const SizedBox(height: 12),
      
            if (isAssigned) 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Accept before ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.acceptBeforeTime,
                    style: TextStyle(
                      color: acceptBeforeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.timer_outlined,
                    color: acceptBeforeColor,
                    size: 16,
                  ),
                ],
              )
            else if (isAccepted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // OutlinedButton(
                  //   onPressed: () {},
                  //   style: OutlinedButton.styleFrom(
                  //     foregroundColor: Colors.red,
                  //     side: BorderSide(color: Colors.red),
                  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  //   child: Text('Cancel', style: TextStyle(fontSize: 12)),
                  // ),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Accepted',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else if (isMissed)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'You missed this trip',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            else if (isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trip completed in ${widget.duration}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 4 ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

}

class _DottedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dashHeight;
  final double dashSpace;
  const _DottedLine({
    Key? key, 
    this.height = 40, 
    this.color = Colors.grey,
    this.dashHeight = 3.0,
    this.dashSpace = 3.0,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(1, height),
      painter: _DottedLinePainter(color, dashHeight, dashSpace),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashSpace;
  _DottedLinePainter(this.color, this.dashHeight, this.dashSpace);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
          ..color = color
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawCircle(Offset(size.width / 2, startY), paint.strokeWidth / 2, paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter oldDelegate) => 
      oldDelegate.color != color || 
      oldDelegate.dashHeight != dashHeight || 
      oldDelegate.dashSpace != dashSpace;
}
