import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simz_academy/views/UIHelper/home_ui_helper.dart';
import 'package:simz_academy/views/screens/reset_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const formSpacer = SizedBox(width: 16, height: 16);
const borderRadiusStd = BorderRadius.all(Radius.circular(9));

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailC = TextEditingController(); // Email controller
  final formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //forgot password image
                Image.asset('lib/assets/images/forgot_password.png',
                    width: 250, height: 250),
                SizedBox(height: 20),
                //Forgot password text
                Align(
                  alignment: Alignment.centerLeft,
                  child: HomeUiHelper().customText(
                    'Forgot Password',
                    36,
                    FontWeight.w600,
                    Color(0xFF380F43),
                  ),
                ),
                SizedBox(height: 10),
                // Email input field
                Align(
                  alignment: Alignment.centerLeft,
                  child: HomeUiHelper().customText(
                    'Email Address',
                    16,
                    FontWeight.w600,
                    Color(0xFF380F43),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF6EBFC),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: TextFormField(
                        controller: emailC,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Color(0xFFCD8CE6)),
                          hintText: 'Email',
                          border: InputBorder
                              .none, // Make the TextFormField borderless
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => !EmailValidator.validate(value!)
                            ? 'Invalid Email Format!'
                            : null,
                      ),
                    )),
                formSpacer,
                // Reset password button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: WidgetStatePropertyAll(10),
                      shadowColor: WidgetStateProperty.all(
                        const Color(0x3F380F43),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        const Color(0xFF893CA2),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: borderRadiusStd,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Show dialog while sending the reset token
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Text(
                              'Please check your email and spam folder for the reset token!',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        try {
                          // Send the reset token via Supabase
                          await Supabase.instance.client.auth
                              .resetPasswordForEmail(emailC.text);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    child: HomeUiHelper().customText('Send Reset Password Token', 20, FontWeight.w700, Color(0xFFECD7F7)),
                  ),
                ),
                formSpacer,
                // Navigate to reset password screen
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen(),
                      ),
                    );
                  },
                  child:
                      Row(
                        children: [
                          HomeUiHelper().customText('Already have a reset token?  ', 16, FontWeight.w600, Color(0xFF380F43)),
                          HomeUiHelper().customText('Reset Password', 16, FontWeight.w600, Color(0xFFC61515)),
                        ],
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
