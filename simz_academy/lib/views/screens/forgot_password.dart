import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:simz_academy/views/screens/reset_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const formSpacer = SizedBox(width: 16, height: 16);
const borderRadiusStd = BorderRadius.all(Radius.circular(8));

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
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input field
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
              // Reset password button
              ElevatedButton(
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
                child: const Text('Send Reset Password Token'),
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
                child: const Text('Already have a token? Reset your password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


