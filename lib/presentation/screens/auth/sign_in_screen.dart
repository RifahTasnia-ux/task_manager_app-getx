import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/presentation/controllers/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app_getx/presentation/screens/auth/email_verification_screen.dart';
import 'package:task_manager_app_getx/presentation/screens/auth/sign_up_screen.dart';
import 'package:task_manager_app_getx/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/snack_bar_message.dart';
import '../../widgets/circular_progress_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEmail(String input) => EmailValidator.validate(input);
  final SignInController _signInController = Get.find<SignInController>();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        'Get Started With',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _emailTEController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your email';
                          }
                          else if (!isEmail(value!)) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _passwordTEController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: GetBuilder<SignInController>(
                            builder: (signInController) {
                              return Visibility(
                                visible: signInController.inProgress == false,
                                replacement: const CircularProgressWidget(),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _signIn();
                                    }
                                  },
                                  child: const Icon(Icons.arrow_circle_right_outlined),
                                ),
                              );
                            }
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              )),
                          onPressed: () {
                            Get.to(EmailVerificationScreen());
                          },
                          child: const Text(
                            'Forgot Password?',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          TextButton(
                            onPressed: () {
                             Get.to(SignUpScreen());
                            },
                            child: const Text(
                              'Sign up',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

      ),
    );
  }
  Future<void> _signIn() async {
    final result = await _signInController.signIn(
        _emailTEController.text.trim(), _passwordTEController.text);
    if (result) {
      if (mounted) {
        Get.off(MainBottomNavScreen());
      }

    } else {
      if (mounted) {
        showSnackBarMessage(context, _signInController.errorMessage);
      }
    }
  }
  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}