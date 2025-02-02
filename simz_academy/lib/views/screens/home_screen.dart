import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';
import 'package:simz_academy/views/screens/quiz_screen.dart';
import 'package:simz_academy/views/screens/practise_screen.dart';
import 'package:simz_academy/views/screens/sheet_screen.dart';
//import 'package:simz_academy/views/screens/student_attendance_screen.dart';
//import 'package:simz_academy/screens/syllabus_screen.dart';
import 'package:simz_academy/views/screens/syllabus_select_screen.dart';
import 'package:simz_academy/views/screens/track_lessons.dart';
//import 'package:simz_academy/views/screens/test_search_screen.dart';
//import 'package:simz_academy/views/screens/test_video_player.dart';
import 'package:simz_academy/views/widgets/home_screen_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currLearn = "Loading...";
  String progress = "Loading ...";
  @override
  void initState() {
    super.initState();
    fetchCurrentLearning();
  }
  Future<void> fetchCurrentLearning() async {
    try {
      final response = await Supabase.instance.client
          .from('student_details')
          .select('curr_learn')
          .eq('user_id', getCurrentUserId(context))
          .single();


      if (response['curr_learn'] is List && response['curr_learn'].isNotEmpty) {
        setState(() {
          currLearn = response['curr_learn'][0]; // Assign the first item in the array
          progress = response['curr_learn'][1];
        });
      } else {
        setState(() {
          currLearn = "No data available";
          progress = "0% progress";
        });
      }
    } catch (e) {
      setState(() {
        currLearn = "No courses available";
        progress = "0% progress";
      });
      debugPrint('Error fetching current learning: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(getCurrentUserName());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              HomeUiHelper().customText(
                                'Howdy',
                                16,
                                FontWeight.w300,
                                const Color.fromRGBO(56, 15, 67, 1.0),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  getCurrentUserName(),
                                  style: GoogleFonts.blinker(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(56, 15, 67, 1.0),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,//  text overflow
                                ),
                              )

                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Stack(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(236, 215, 247, 1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Icon(
                                  Iconsax.notification,
                                  color: Color.fromRGBO(56, 15, 67, 1.0),
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  width: 13,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                //main container
                Center(
                  child: Container(
                    width: 400,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(196, 220, 243, 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //sub container heading
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            color: Color.fromRGBO(28, 83, 136, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SingleChildScrollView(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    Iconsax.teacher5,
                                    color: Color.fromRGBO(196, 220, 243, 1),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  HomeUiHelper().customText(
                                    'Learning Now',
                                    15,
                                    FontWeight.normal,
                                    const Color.fromRGBO(196, 220, 243, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              HomeUiHelper().customText(
                                'Grade ',
                                15,
                                FontWeight.normal,
                                const Color.fromRGBO(28, 83, 136, 1),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  HomeUiHelper().customText(
                                    currLearn,
                                    24,
                                    FontWeight.bold,
                                    const Color.fromRGBO(28, 83, 136, 1),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // on pressed
                                    },
                                    icon: const Icon(
                                      Iconsax.music_playlist,
                                      color: Color.fromRGBO(28, 83, 136, 1),
                                    ),
                                  ),
                                ],
                              ),
                              HomeUiHelper().customText(
                                'Musical Masterpiece composed by \nTraditional',
                                16,
                                FontWeight.w400,
                                const Color.fromRGBO(18, 39, 63, 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  HomeUiHelper().customText(
                                      progress,
                                      20,
                                      FontWeight.w600,
                                      const Color.fromRGBO(18, 39, 63, 1)),
                                  const Expanded(child: SizedBox()),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        const Color.fromRGBO(36, 114, 186, 1),
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                        return TrackLessonScreen();
                                      }));
                                    },
                                    child: const Text(
                                      'Track Lessons',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(242, 247, 253, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                HomeUiHelper().customText(
                  'Something to do',
                  28,
                  FontWeight.w600,
                  const Color.fromRGBO(56, 15, 67, 1),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const SomethingToDo().buildIconButtonWithText(
                        context,
                        // make the icons bold
                        IconsaxPlusBold.book,
                        'Syllabus',
                        const SyllabusSelectScreen(),
                        const Color.fromRGBO(91, 40, 103, 1),
                        const Color.fromRGBO(236, 215, 247, 1)),
                    const SomethingToDo().buildIconButtonWithText(
                        context,
                        IconsaxPlusBold.clipboard_text,
                        'Quiz',
                        const QuizScreen(),
                        const Color.fromRGBO(126, 30, 37, 1),
                        const Color.fromRGBO(254, 202, 206, 1)),
                    const SomethingToDo().buildIconButtonWithText(
                        context,
                        IconsaxPlusBold.music_square,
                        'Sheets',
                        const SheetScreen(),
                        const Color.fromRGBO(27, 60, 95, 1),
                        const Color.fromRGBO(196, 220, 243, 1)),
                    const SomethingToDo().buildIconButtonWithText(
                        context,
                        IconsaxPlusBold.microphone_2,
                        'Practise',
                        const PractiseScreen(),
                        const Color.fromRGBO(91, 40, 103, 1),
                        const Color.fromRGBO(236, 215, 247, 1)),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                HomeUiHelper().customText('Live Class', 28, FontWeight.w600,
                    const Color.fromRGBO(56, 15, 67, 1)),
                const SizedBox(
                  height: 10,
                ),
                const LiveNow(),
                const SizedBox(
                  height: 5,
                ),
                HomeUiHelper().customText('Upcoming', 28, FontWeight.w600,
                    const Color.fromRGBO(56, 15, 67, 1)),
                const SizedBox(
                  height: 10,
                ),
                const Upcoming(),
                const SizedBox(
                  height: 10,
                ),
                HomeUiHelper().customText('Appreciations', 28, FontWeight.w600,
                    const Color.fromRGBO(56, 15, 67, 1)),
                const SizedBox(
                  height: 10,
                ),
                const Appreciations(),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset('lib/assets/images/simz_logo_2.png'),
                            HomeUiHelper().customText(
                                ' Simz ',
                                16,
                                FontWeight.w600,
                                const Color.fromRGBO(56, 15, 67, 1)),
                            HomeUiHelper().customText(
                                'Academy ',
                                16,
                                FontWeight.w600,
                                const Color.fromRGBO(27, 60, 95, 1)),
                          ],
                        ),
                        HomeUiHelper().customText(
                            'v1.0.0',
                            16,
                            FontWeight.w300,
                            const Color.fromRGBO(105, 42, 123, 1)),
                        HomeUiHelper().customText(
                            'Developed By Team AJS Web Creatives',
                            16,
                            FontWeight.w300,
                            const Color.fromRGBO(105, 42, 123, 1)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
