import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
  final resetTokenC = TextEditingController(); // Reset token controller
  final formKey = GlobalKey<FormState>(); // Form key for validation
  bool _passwordVisible = true; // For toggling password visibility
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset Token Input Field
              TextFormField(
                controller: resetTokenC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'Reset Token',
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Invalid Token!';
                  }
                  return null;
                },
              ),
              formSpacer,
              // Email Input Field
              TextFormField(
                controller: emailC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'Email',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => !EmailValidator.validate(value!)
                    ? 'Invalid Email Format!'
                    : null,
              ),
              formSpacer,
              // Password Input Field
              TextFormField(
                controller: passwordC,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                  border:
                  const OutlineInputBorder(borderRadius: borderRadiusStd),
                  hintText: 'New Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: _passwordVisible
                        ? Icon(IconsaxPlusBold.eye)
                        : Icon(IconsaxPlusBold.eye_slash)
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters!';
                  }
                  return null;
                },
              ),
              formSpacer,
              // Reset Password Button
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                    );
                    try {
                      // Verify OTP and update password
                      await Supabase.instance.client.auth.verifyOTP(
                        email: emailC.text,
                        token: resetTokenC.text,
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
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
