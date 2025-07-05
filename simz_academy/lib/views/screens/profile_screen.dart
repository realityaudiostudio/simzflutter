import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart'; // Ensure you have the iconsax package added in pubspec.yaml
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:simz_academy/models/student_model/badge_model.dart';
import 'package:simz_academy/models/student_model/certificate_model.dart';
//import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/controllers/constants/supabase_functions.dart';
import 'package:simz_academy/views/screens/bottom_nav.dart';
import 'package:simz_academy/views/screens/edit_profile.dart';
import 'package:simz_academy/views/screens/login_screen.dart';
import 'package:simz_academy/views/screens/student_attendance_screen.dart';
import 'package:simz_academy/views/widgets/common_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<String> courses = [];
  final BadgeModel _badgeModel = BadgeModel();
  late CertificateModel _certificateModel;
  bool _show = false;
  @override
  void initState() {
    super.initState();
    _certificateModel = CertificateModel(userId: getUserId());
    _fetchData();
    fetchCourses();
    Future.delayed(Duration(milliseconds: 750), () {
      setState(() {
        _show = true;
      });
    });
  }

  Future<void> fetchCourses() async {
    final userId = getCurrentUserId(context); // Replace with actual user ID
    final response = await supabase
        .from('student_details')
        .select('courses')
        .eq('user_id', userId)
        .single();

    if (response['courses'] != null) {
      setState(() {
        courses = List<String>.from(response['courses']);
      });
    }
  }

  Future<void> _fetchData() async {
    try {
      // Fetch certificates
      final certificatesResult = await CertificateModel.fetchCertificates();

      // Fetch badges
      await _badgeModel.getBadge();

      // Update state
      setState(() {
        if (certificatesResult != null) {
          _certificateModel = certificatesResult;
          debugPrint(
              "Certificates loaded: ${_certificateModel.certificateName.length}");
        }
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  void _launchURL(Uri uri, bool inApp) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inApp) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
        } else {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Iconsax.logout, color: Color.fromRGBO(56, 15, 67, 1)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: HomeUiHelper().customText(
                      "Are you sure want to logout?",
                      26,
                      FontWeight.w600,
                      Color.fromRGBO(56, 15, 67, 1),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: HomeUiHelper().customText(
                          "Cancel",
                          20,
                          FontWeight.w400,
                          Color.fromRGBO(56, 15, 67, 1),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Color.fromRGBO(56, 15, 67, 1)),
                          foregroundColor: WidgetStateProperty.all<Color>(
                              Color.fromRGBO(251, 246, 253, 1)),
                        ),
                        onPressed: () {
                          // Logout user and goto Login and to remove all the previous pages
                          Supabase.instance.client.auth.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: HomeUiHelper().customText(
                          "Logout",
                          20,
                          FontWeight.w400,
                          Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
        leading: IconButton(
          icon: Icon(Iconsax.arrow_square_left),
          color: Color.fromRGBO(56, 15, 67, 1),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => BottomNav(),
            ));
          },
        ),
        title: Center(
          child: HomeUiHelper().customText(
            'Profile',
            24,
            FontWeight.w400,
            Color.fromRGBO(56, 15, 67, 1),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeUiHelper().customText(
                  'Student details',
                  20,
                  FontWeight.w600,
                  Color.fromRGBO(56, 15, 67, 1),
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white,
                    gradient: RadialGradient(
                      colors: const [
                        Color.fromRGBO(56, 15, 67, 1),
                        Color.fromRGBO(91, 40, 103, 1),
                      ],
                      radius: 0.8,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(IconsaxPlusBold.user_square, size: 40.0,color: Colors.white,),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200.0,
                              child: HomeUiHelper().customText(
                                getCurrentUserName(),
                                32,
                                FontWeight.w600,
                                Color.fromRGBO(251, 246, 253, 1),
                              ),
                            ),
                            // SizedBox(
                            //   width: 200.0,
                            //   child: Text(
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     getCurrentUserId(context),
                            //     style: GoogleFonts.blinker(
                            //       fontSize: 16,
                            //       fontWeight: FontWeight.w400,
                            //       color: Color.fromRGBO(251, 246, 253, 1),
                            //     ),
                            //   ),
                            // ),
                            HomeUiHelper().customText(
                              getCurrentUserEmail(),
                              16,
                              FontWeight.w400,
                              Color.fromRGBO(251, 246, 253, 1),
                            ),
                            // HomeUiHelper().customText(
                            //   getCurrentUserPhone(),
                            //   16,
                            //   FontWeight.w400,
                            //   Color.fromRGBO(251, 246, 253, 1),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //SizedBox(width: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return StudentAttendanceScreen();
                        }));
                      },
                      child: Row(
                        children: [
                          HomeUiHelper().customText(
                            'View Attendance  ',
                            16,
                            FontWeight.w400,
                            Color.fromRGBO(56, 15, 67, 1),
                          ),
                          Icon(
                            Iconsax.task_square,
                            color: Color.fromRGBO(56, 15, 67, 1),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          HomeUiHelper().customText(
                            'Edit Profile  ',
                            16,
                            FontWeight.w400,
                            Color.fromRGBO(56, 15, 67, 1),
                          ),
                          Icon(
                            Iconsax.edit,
                            color: Color.fromRGBO(56, 15, 67, 1),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                HomeUiHelper().customText("Your Courses", 20, FontWeight.w600,
                    Color.fromRGBO(56, 15, 67, 1)),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 120.0, // Fixed height for horizontal scrolling
                  child: CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return SizedBox(
                              width: 363.0,
                              child: Container(
                                margin: EdgeInsets.only(right: 16.0),
                                width: 412.0,
                                height: 200.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: Color.fromRGBO(196, 220, 243, 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 230.0,
                                        child: HomeUiHelper().customText(
                                          courses[index][0].toUpperCase() + courses[index].substring(1),
                                          26,
                                          FontWeight.w600,
                                          Color.fromRGBO(56, 15, 67, 1),
                                        ),
                                      ),
                                    ),
                                    Image.asset(
                                      'lib/assets/images/sheets.png',
                                      width: 100.0,
                                      height: 100.0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: courses.length,
                        ),
                      ),
                    ],
                  ),
                ),

// Badges gained section below  vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

                SizedBox(height: 16.0),
                HomeUiHelper().customText(
                  "Badges Gained",
                  20,
                  FontWeight.w600,
                  const Color.fromRGBO(56, 15, 67, 1),
                ),
                SizedBox(height: 16.0),
                Container(
                  //height: 150, // Fixed height for the badge section
                  padding: const EdgeInsets.all(16.0),
                  child: _badgeModel.badgeName.isNotEmpty
                      ? SizedBox(
                          height:
                              150, // Limit ListView's height to avoid overflow
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _badgeModel.badgeName.length,
                            itemBuilder: (ctx, index) {
                              final badge = _badgeModel.badgeName[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'lib/assets/images/award.png',
                                      width: 100.0,
                                      height: 100.0,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      badge,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(27, 60, 95, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: _show
                              ? HomeUiHelper().customText(
                                  'No badges found',
                                  20,
                                  FontWeight.w400,
                                  Color.fromRGBO(56, 15, 67, 1),
                                )
                              : CircularProgressIndicator(),
                        ),
                ),

// Badges gained section above  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// Certificates earned section below  vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

                SizedBox(height: 16.0),
                HomeUiHelper().customText(
                  "Certificates Gained",
                  20,
                  FontWeight.w600,
                  const Color.fromRGBO(56, 15, 67, 1),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: _certificateModel.certificateName.isNotEmpty
                      ? SizedBox(
                          height: 200, // Limit ListView's height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _certificateModel.certificateName.length,
                            itemBuilder: (ctx, index) {
                              final certificateName =
                                  _certificateModel.certificateName[index];
                              final certificateUrl =
                                  _certificateModel.certificateUrl[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    // Open the certificate URL in the browser
                                    _launchURL(
                                        Uri.parse(certificateUrl), false);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'lib/assets/images/document-download.png', // Replace with your certificate icon
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(height: 8.0),
                                      Container(
                                        width:
                                            150, // Fixed width to control text layout
                                        height:
                                            60, // Fixed height to limit vertical space
                                        alignment: Alignment.center,
                                        child: Text(
                                          certificateName,
                                          textAlign: TextAlign.center,
                                          maxLines: 5, // Allow up to 5 lines
                                          overflow: TextOverflow
                                              .ellipsis, // Add ellipsis if text overflows
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                Color.fromRGBO(27, 60, 95, 1),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              if (_show)
                                Lottie.asset(
                                  'lib/assets/animations/not_found.json',
                                  width: 200.0,
                                  height: 200.0,
                                ),
                              HomeUiHelper().customText(
                                'No certificates found',
                                20,
                                FontWeight.w400,
                                const Color.fromRGBO(56, 15, 67, 1),
                              ),
                            ],
                          ),
                        ),
                ),

// Certificates earned section above  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// instant support and connected with us section below  vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

                SizedBox(height: 16.0),
                Center(
                  child: HomeUiHelper().customText(
                      "        Get instant support from our team ! \nChat with instructors anytime, anywhere !",
                      14,
                      FontWeight.w600,
                      Color.fromRGBO(56, 15, 67, 1)),
                ),
                SizedBox(height: 32.0),
                Container(
                  width: double.infinity,
                  height: 115,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      HomeUiHelper().customText("Stay connected with us !", 24,
                          FontWeight.w600, Color(0xFF380F43)),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => _launchURL(
                                Uri.parse(
                                    'https://www.facebook.com/simzacademy/'),
                                false),
                            child: Lottie.asset(
                                'lib/assets/animations/facebook.json',
                                width: 48.0,
                                height: 48.0),
                          ),
                          InkWell(
                            onTap: () => _launchURL(
                                Uri.parse('https://simzmuzic.com/'), false),
                            child: Lottie.asset(
                                'lib/assets/animations/internet.json',
                                width: 55.0,
                                height: 55.0),
                          ),
                          InkWell(
                            onTap: () => _launchURL(
                                Uri.parse(
                                    'https://www.instagram.com/simzacademy/'),
                                false),
                            child: Lottie.asset(
                                'lib/assets/animations/instagram.json',
                                width: 65.0,
                                height: 65.0),
                          ),
                          InkWell(
                            onTap: () => _launchURL(
                                Uri.parse(
                                    'https://api.whatsapp.com/send/?phone=917907386458&text=Hello+Simz+Academy%2C+I+would+like+to+know+more+about+your+courses.&type=phone_number&app_absent=0'),
                                false),
                            child: Lottie.asset(
                                'lib/assets/animations/whatsapp1.json',
                                width: 40.0,
                                height: 40.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.0),

                //contact us section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeUiHelper().customText(
                        'Contact Us', 20, FontWeight.w600, Color(0xFF380F43)),
                    SizedBox(height: 10.0),
                    InkWell(
                        onTap: () =>
                            _launchURL(Uri.parse('tel:+919072397378'), false),
                        child: HomeUiHelper().customText(
                            'Phone : +919072397378',
                            16,
                            FontWeight.w400,
                            Color(0xFF380F43))), //phone
                    InkWell(
                        onTap: () => _launchURL(
                            Uri.parse('mailto:simzzacademy@gmail.com'), false),
                        child: HomeUiHelper().customText(
                            'Email: simzzacademy@gmail.com',
                            16,
                            FontWeight.w400,
                            Color(0xFF380F43))), //email
                    HomeUiHelper().customText(
                        'Address : Punna complex,\nChungathara P O\nNilambur, Kerala',
                        16,
                        FontWeight.w400,
                        Color(0xFF380F43)), //address
                    HomeUiHelper().customText(
                        'Working Hours : Mon-Fri: 9AM - 5PM',
                        16,
                        FontWeight.w400,
                        Color(0xFF380F43)),
                  ],
                ),
                FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
