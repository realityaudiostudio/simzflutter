import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:iconsax/iconsax.dart';
//import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const formSpacer = SizedBox(width: 16, height: 16);
const borderRadiusStd = BorderRadius.all(Radius.circular(8));

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailC = TextEditingController(); // Email controller
  final passwordC = TextEditingController(); // Password controller
  final List<TextEditingController> resetTokenControllers =
  List.generate(6, (index) => TextEditingController()); // Reset token controllers
  final formKey = GlobalKey<FormState>(); // Form key for validation
  bool _passwordVisible = true; // For toggling password visibility
  bool? isLoading;

  String getResetToken() {
    // Combine the six individual token fields into one string
    return resetTokenControllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBF6FD),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_square_left, color: Color(0xFF380F43)),
        ),
        centerTitle: true,
        title: HomeUiHelper().customText(
          'Reset Password',
          24,
          FontWeight.w400,
          Color(0xFF380F43),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset Token Input Fields (Six Boxes)
              Align(
                alignment: Alignment.centerLeft,
                child: HomeUiHelper().customText(
                  'Token',
                  16,
                  FontWeight.w600,
                  Color(0xFF380F43),
                ),
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 40,
                      child: TextFormField(
                        controller: resetTokenControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Color(0xFF380F43),
                            ),
                          ),
                          border: OutlineInputBorder(),
                          counterText: "", // Removes character count below the box
                        ),
                        onChanged: (value) {
                          // Automatically move to the next box on input
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                          // Move to the previous box on backspace
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          if (!RegExp(r'^[0-9]$').hasMatch(value)) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                  );
                }),
              ),
              formSpacer,
              // Email Input Field
              Align(
                alignment: Alignment.centerLeft,
                child: HomeUiHelper().customText(
                  'Email Address',
                  16,
                  FontWeight.w600,
                  Color(0xFF380F43),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6EBFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: TextFormField(
                    controller: emailC,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFFCD8CE6)),
                      hintText: 'Enter Email',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => !EmailValidator.validate(value!)
                        ? 'Invalid Email Format!'
                        : null,
                  ),
                ),
              ),
              formSpacer,
              // Password Input Field
              Align(
                alignment: Alignment.centerLeft,
                child: HomeUiHelper().customText(
                  'New Password',
                  16,
                  FontWeight.w600,
                  Color(0xFF380F43),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6EBFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: TextFormField(
                    controller: passwordC,
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      border:
                      InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFFCD8CE6)),
                      hintText: 'Enter New Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: _passwordVisible
                            ? Icon(Iconsax.eye,color: Color.fromRGBO(137,60,162,1),)
                            : Icon(Iconsax.eye_slash,color: Color.fromRGBO(137,60,162,1)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Password must be at least 6 characters!';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              formSpacer,
              // Reset Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all(10),
                    shadowColor: WidgetStateProperty.all(const Color(0x3F380F43)),
                    backgroundColor: WidgetStateProperty.all(const Color(0xFF893CA2)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: borderRadiusStd,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final resetToken = getResetToken();
                      if (resetToken.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid Token! Must be 6 digits.'),
                          ),
                        );
                        return;
                      }
                      isLoading = true;
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                        const Center(child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                      );
                      try {
                        // Verify OTP and update password
                        await Supabase.instance.client.auth.verifyOTP(
                          email: emailC.text,
                          token: resetToken,
                          type: OtpType.recovery,
                        );
                        await Supabase.instance.client.auth.updateUser(
                          UserAttributes(password: passwordC.text),
                        );
                        isLoading = false;
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Password successfully updated. Please log in again.',
                            ),
                          ),
                        );
                        Navigator.pop(context); // Navigate back after success
                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  child: HomeUiHelper().customText('Reset Password', 20, FontWeight.w700, Color(0xFFECD7F7),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
