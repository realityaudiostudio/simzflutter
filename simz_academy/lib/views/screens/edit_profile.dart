import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simz_academy/models/student_model/profile_model.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/constants/supabase_functions.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileModel _profileModel = ProfileModel();
  final yearOfAdmissionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool setVisible = true;
  bool setPassword = false;
  @override
  void initState() {
    super.initState();
    getYearOfAdmission();
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
                      updateProfile(passwordController.text, nameController.text,
                          phoneNumberController.text);
                    },
                    child: HomeUiHelper().customText(
                      'Save Changes',
                      20,
                      FontWeight.w700,
                      Color(0xFFECD7F7),
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

  void updateProfile(String password, String name, String phone) async {
    final userId = getUserId();
    try {
      // Update the year of admission in the 'student_details' table
      await Supabase.instance.client
          .from('student_details')
          .update({'year_adm': yearOfAdmissionController.text})
          .eq('user_id', userId);

      // Update the password if the user requested it
      if (setPassword && password.isNotEmpty) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: password),
        );
      }

      // Update user profile data (name and phone)
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {"username": name, "phone": phone}),
      );

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Log the error and show error snackbar
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update profile: $e',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
