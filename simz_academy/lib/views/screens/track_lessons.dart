import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
//import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import '../../models/lesson_model/track_lesson_model.dart';

class TrackLessonScreen extends StatefulWidget {
  const TrackLessonScreen({super.key});
  @override
  State<TrackLessonScreen> createState() => _TrackLessonScreenState();
}

class _TrackLessonScreenState extends State<TrackLessonScreen> {
  TrackLessonModel trackLessonModel =
      TrackLessonModel(previousLessons: [], currentLessons: []);
  bool isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    fetchLessons(); // Fetch lessons during initialization
  }

  Future<void> fetchLessons() async {
    try {
      // Fetch data from Supabase
      final fetchedModel = await TrackLessonModel.fetchFromSupabase();
      setState(() {
        trackLessonModel = fetchedModel;
        isLoading = false; // Stop loading
      });
    } catch (e) {
      debugPrint('Error fetching lessons: $e');
      setState(() {
        isLoading = false; // Stop loading even if there’s an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.white, // Set the background color to white
        child: const Center(
          child: CircularProgressIndicator(), // Loading spinner
        ),
      );
    }

    if (trackLessonModel.previousLessons.isEmpty) {
      return const Center(child: Text('No previous lessons found.'));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_square_left),
          color: Color.fromRGBO(56, 15, 67, 1),
        ),
        title: HomeUiHelper().customText(
            'Lessons Tracking', 28, FontWeight.w400, Color(0xFF380F43)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: trackLessonModel.currentLessons.length-1,
            itemBuilder: (context, index) {
              final lesson = trackLessonModel.currentLessons[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Container(
                  padding: const EdgeInsets.all(16), // Adds inner spacing
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF6FD), // Background color
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: const Color(0xFFDFB7F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Section (Text)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Grade ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple, // Adjust color as needed
                            ),
                          ),
                          SizedBox(height: 4), // Spacing
                          Text(
                            lesson,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4B146A),
                            ),
                          ),
                          SizedBox(height: 4), // Spacing
                          Text(
                            'Currently Learning',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B146A),
                            ),
                          ),
                        ],
                      ),

                      // Right Section (Image)
                      Image.asset(
                        'lib/assets/images/sheets.png', // Replace with your image path
                        width: 64, // Scales the image
                        height: 64,
                        fit:
                        BoxFit.contain, // Ensures the image doesn't stretch
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Color.fromRGBO(181, 95, 214, 1),
            thickness: 2,
            indent: 100,
            endIndent: 100,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: trackLessonModel.previousLessons.length,
            itemBuilder: (context, index) {
              final lesson = trackLessonModel.previousLessons[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Container(
                  padding: const EdgeInsets.all(16), // Adds inner spacing
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF6FD), // Background color
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: const Color(0xFFDFB7F0),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left Section (Text)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Grade ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.purple, // Adjust color as needed
                            ),
                          ),
                          SizedBox(height: 4), // Spacing
                          Text(
                            lesson,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF4B146A),
                            ),
                          ),
                          SizedBox(height: 4), // Spacing
                          Text(
                            'Previously Learned',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B146A),
                            ),
                          ),
                        ],
                      ),

                      // Right Section (Image)
                      Image.asset(
                        'lib/assets/images/sheets.png', // Replace with your image path
                        width: 64, // Scales the image
                        height: 64,
                        fit:
                            BoxFit.contain, // Ensures the image doesn't stretch
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
