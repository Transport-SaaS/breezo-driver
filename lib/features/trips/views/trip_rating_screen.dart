import 'package:breezodriver/core/utils/app_colors.dart';
import 'package:breezodriver/features/trips/models/trip_model.dart';
import 'package:breezodriver/features/trips/viewmodels/trip_rating_viewmodel.dart';
import 'package:breezodriver/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TripRatingScreen extends StatefulWidget {
  final TripRatingViewModel viewModel;

  const TripRatingScreen({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<TripRatingScreen> createState() => _TripRatingScreenState();
}

class _TripRatingScreenState extends State<TripRatingScreen> {
  final List<String> _issueOptions = [
    'All good, smooth trip 👍',
    'Small issue, but okay 👌',
    'Got delayed or route problem ⏱️',
    'Passenger issue (late/no-show/rude) ❌',
    'Vehicle or technical problem 🔧'
  ];

  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<TripRatingViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip ID: ${viewModel.trip.id}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${viewModel.trip.distance} | ${viewModel.trip.passengers} passengers',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(

              children: [
                // Your ride is finished banner
                Container(
                  width: double.infinity,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: const Text(
                    'Your ride is finished!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                // Rating content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'How was your trip?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your feedback will help improve driving experience',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      
                      // Overall rating
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: StarRatingWidget(
                          rating: viewModel.overallRating.toInt(),
                          onRatingChanged: (rating) {
                            viewModel.setOverallRating(rating.toDouble());
                          },
                          starSize: 40,
                        ),
                      ),
                      
                      // Issue selection
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _issueOptions.map((issue) {
                          final isSelected = viewModel.selectedIssue == issue;
                          return InkWell(
                            onTap: () {
                              viewModel.setSelectedIssue(issue);
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.primarycolor.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primarycolor
                                      : Colors.grey.shade400,
                                ),
                              ),
                              child: Text(
                                issue,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primarycolor
                                      : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Rate your passengers section
                      const Text(
                        'Rate your passengers',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Passenger rating list
                      ...viewModel.trip.passengerList.map((passenger) => 
                        _buildPassengerRatingItem(passenger, viewModel)
                      ).toList(),
                      
                      // Additional comments
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _commentsController,
                        decoration: InputDecoration(
                          labelText: 'Additional comments',
                          hintText: 'Any other feedback?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          viewModel.setAdditionalComments(value);
                        },
                      ),
                      
                      const SizedBox(height: 60), // Extra space at the bottom
                    ],
                  ),
                ),
                
                // Submit button at the bottom
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,

                    child: CommonButton(label: viewModel.isSubmittingFeedback ? 'Submitting...' : 'Submit Feedback', onPressed: viewModel.isSubmittingFeedback ? null : () async {
                      await viewModel.submitFeedback();
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    activeColor: AppColors.primarycolor
                    , isActive: !viewModel.isSubmittingFeedback)
                    
                    // ElevatedButton( 
                    //   onPressed: viewModel.isSubmittingFeedback
                    //       ? null
                    //       : () async {
                    //           await viewModel.submitFeedback();
                    //           if (mounted) {
                    //             Navigator.pop(context);
                    //           }
                    //         },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: const Color(0xFF6A21CA),
                    //     foregroundColor: Colors.white,
                    //     disabledBackgroundColor: Colors.grey.shade300,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   child: Text(
                    //     viewModel.isSubmittingFeedback ? 'Submitting...' : 'Submit Feedback',
                    //     style: const TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPassengerRatingItem(Passenger passenger, TripRatingViewModel viewModel) {
    final currentRating = viewModel.passengerRatings[passenger.id]?.toInt() ?? 0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Passenger avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: _getAvatarColor(passenger.initials),
            child: Text(
              passenger.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Passenger details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passenger.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Building No. ${passenger.address.split(',').first}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Rating stars
          StarRatingWidget(
            rating: currentRating,
            onRatingChanged: (rating) {
              viewModel.setPassengerRating(passenger.id, rating.toDouble());
            },
            starSize: 24,
          ),
        ],
      ),
    );
  }
  
  Color _getAvatarColor(String initials) {
    // Map initials to specific colors to match the screenshot
    const Map<String, Color> colorMap = {
      'BK': Color(0xFF6B7280), // Grey
      'BM': Color(0xFFEC4899), // Pink
      'AG': Color(0xFF8B5CF6), // Purple
      'VB': Color(0xFFEF4444), // Red
      'KE': Color(0xFF10B981), // Green
      'MV': Color(0xFF3B82F6), // Blue
    };

    return colorMap[initials] ?? Colors.blue;
  }
}

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;
  final double starSize;

  const StarRatingWidget({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
    this.starSize = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: starSize,
          ),
        );
      }),
    );
  }
} 