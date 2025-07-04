import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simz_academy/models/student_model/course_model.dart';
import 'package:simz_academy/models/student_model/profile_model.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/constants/supabase_functions.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileModel _profileModel = ProfileModel();
  final CourseModel _courseModel = CourseModel();
  final yearOfAdmissionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool setVisible = true;
  bool setPassword = false;
  List<bool> _selectedCourses = [];
  @override
  void initState() {
    super.initState();
    getYearOfAdmission();
    _initializeCourses();
  }

  Future<void> _initializeCourses() async {
    await _courseModel.getCourseNames();
    await _courseModel.getEnrolledCourseNames();
    setState(() {
      _selectedCourses =
          List<bool>.filled(_courseModel.courseName.length, false);
      for (int i = 0; i < _courseModel.courseName.length; i++) {
        if (_courseModel.enrolledCourses.contains(_courseModel.courseName[i])) {
          _selectedCourses[i] = true;
        }
      }
    });
  }

  Future<void> getYearOfAdmission() async {
    final userId = getUserId();
    final response = await Supabase.instance.client
        .from('student_details')
        .select('year_adm')
        .eq('user_id', userId);
    if (response[0]['year_adm'] != null) {
      yearOfAdmissionController.text = response[0]['year_adm'].toString();
    } else {
      yearOfAdmissionController.text = 'Not Available';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 2 - 16;

    TextEditingController nameController =
        TextEditingController(text: _profileModel.name);
    // TextEditingController emailController =
    //     TextEditingController(text: _profileModel.email);
    TextEditingController phoneNumberController =
        TextEditingController(text: _profileModel.phone);

    return Scaffold(
      backgroundColor: Color(0xFFFBF6FD),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Iconsax.arrow_square_left,
            color: Color.fromRGBO(56, 15, 67, 1),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: HomeUiHelper().customText(
                      'Edit Profile',
                      36,
                      FontWeight.w600,
                      Color(0xFF380F43),
                    )),
                SizedBox(
                  height: 20,
                ),

                //name
                Align(
                  alignment: Alignment.centerLeft,
                  child: HomeUiHelper().customText(
                    'Name',
                    16,
                    FontWeight.w600,
                    Color(0xFF380F43),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF6EBFC),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(color: Color(0xFFCD8CE6)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                //phone
                Align(
                  alignment: Alignment.centerLeft,
                  child: HomeUiHelper().customText(
                    'Phone',
                    16,
                    FontWeight.w600,
                    Color(0xFF380F43),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF6EBFC),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                //year of admission
                Align(
                  alignment: Alignment.centerLeft,
                  child: HomeUiHelper().customText(
                    'Year of Admission',
                    16,
                    FontWeight.w600,
                    Color(0xFF380F43),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF6EBFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextField(
                      controller: yearOfAdmissionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // New Password
                if (setPassword)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HomeUiHelper().customText(
                          'New Password',
                          16,
                          FontWeight.w600,
                          Color(0xFF380F43),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF6EBFC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: TextField(
                            obscureText: setVisible,
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter new password',
                              hintStyle: TextStyle(color: Color(0xFFCD8CE6)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  color: Color.fromRGBO(137, 60, 162, 1),
                                  setVisible ? Iconsax.eye : Iconsax.eye_slash,
                                ),
                                onPressed: () {
                                  setState(() {
                                    setVisible = !setVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                TextButton(
                  onPressed: () {
                    setState(
                      () {
                        setPassword = !setPassword;
                      },
                    );
                  },
                  child: setPassword
                      ? HomeUiHelper().customText(
                          'Cancel',
                          15,
                          FontWeight.w400,
                          Color(0xFF380F43),
                        )
                      : HomeUiHelper().customText(
                          'Add new Password',
                          15,
                          FontWeight.w400,
                          Color(0xFF380F43),
                        ),
                ),

                SizedBox(
                  height: 20,
                ),
                // Courses
                Align(
                  alignment: Alignment.centerLeft,
                  child: HomeUiHelper().customText(
                    'Courses',
                    16,
                    FontWeight.w600,
                    Color(0xFF380F43),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                (_courseModel.courseName.isEmpty)
                    ? HomeUiHelper().customText(
                        'No courses available',
                        16,
                        FontWeight.w600,
                        Color(0xFF380F43),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              screenWidth < 600 ? 1 : 2, // Maximum 2 columns
                          childAspectRatio: 3, // Adjust height dynamically
                        ),
                        itemCount: _courseModel.courseName.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(0xFFF6EBFC),
                            elevation: 2,
                            margin: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _selectedCourses[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _selectedCourses[index] =
                                            value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      _courseModel.courseName[index][0]
                                              .toUpperCase() +
                                          _courseModel.courseName[index]
                                              .substring(1),
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                SizedBox(
                  height: 15,
                ),

                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: HomeUiHelper().customText(
                            'Update Courses',
                            20,
                            FontWeight.w600,
                            Color(0xFF380F43),
                          ),
                          content: HomeUiHelper().customText(
                            'Are you sure you want to update your selected courses?',
                            16,
                            FontWeight.w400,
                            Color(0xFF893CA2),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: HomeUiHelper().customText(
                                'Cancel',
                                16,
                                FontWeight.w600,
                                Color(0xFF380F43),
                              ),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Color(0xFF893CA2),
                                ),
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                saveSelectedCourses(); // Call the method
                              },
                              child: HomeUiHelper().customText(
                                'Submit',
                                16,
                                FontWeight.w600,
                                Color(0xFFECD7F7),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: HomeUiHelper().customText(
                    'Update Courses',
                    16,
                    FontWeight.w400,
                    Color(0xFF380F43),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color(0xFF893CA2),
                      ),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      updateProfile(passwordController.text,
                          nameController.text, phoneNumberController.text);
                    },
                    child: HomeUiHelper().customText(
                      'Save Changes',
                      20,
                      FontWeight.w700,
                      Color(0xFFECD7F7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveSelectedCourses() async {
    final userId = getUserId();
    try {
      // Filter selected courses
      List<String> selectedCourseNames = [];
      for (int i = 0; i < _selectedCourses.length; i++) {
        if (_selectedCourses[i]) {
          selectedCourseNames.add(_courseModel.courseName[i]);
        }
      }

      // Update the selected courses in the 'student_details' table
      await Supabase.instance.client
          .from('student_details')
          .update({'courses': selectedCourseNames}).eq('user_id', userId);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Courses Saved Successfully',
            message: 'Your selected courses have been updated.',
            contentType: ContentType.success,
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Log the error and show error snackbar
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Save Failed',
            message: 'Unable to save selected courses. Try again later.',
            contentType: ContentType.failure,
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void updateProfile(String password, String name, String phone) async {
    List conditions = resetProfilePasswordValidator(passwordController);
    final userId = getUserId();
    try {
      // Update the year of admission in the 'student_details' table
      await Supabase.instance.client.from('student_details').update(
          {'year_adm': yearOfAdmissionController.text}).eq('user_id', userId);

      // Update the password if the user requested it

      if (setPassword && password.isNotEmpty) {
        if (conditions.isEmpty) {
          await Supabase.instance.client.auth.updateUser(
            UserAttributes(password: password),
          );
        } else {
          throw AuthApiException(conditions.toString());
        }
      }

      // Update user profile data (name and phone)
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {"username": name, "phone": phone}),
      );

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Profile Updated Successfully',
            message: 'Navigate to home page to view changes',
            contentType: ContentType.success,
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } on AuthApiException catch (e) {
      // Log the error and show error snackbar
      debugPrint(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: AwesomeSnackbarContent(
            title: 'Invalid Format',
            messageTextStyle: TextStyle(fontSize: 10),
            message: conditions
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll(', ', '\n'),
            contentType: ContentType.warning,
          ),
        ),
      );
    } catch (e) {
      // Log the error and show error snackbar
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Update Failed',
            message: 'Try again later',
            contentType: ContentType.failure,
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
