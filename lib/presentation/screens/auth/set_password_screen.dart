import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import '../../controllers/set_password_controller.dart';
import '../../widgets/circular_progress_widget.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SetPasswordController controller = Get.put(SetPasswordController());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
                    'Set New Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Minimum 7 characters with letters and numbers combination',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: passwordController,
                    onChanged: (value) {
                      controller.inputOnChange('password', value);
                    },
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
                      if (value!.length <= 6) {
                        return 'Password should more than 6 letters';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    onChanged: (value) {
                      controller.inputOnChange('cpassword', value);
                    },
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your confirmed password';
                      }
                      if (value!.length <= 6) {
                        return 'Confirmed password should be more than 6 letters';
                      }
                      return null;
                    },

                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    child: Visibility(
                      visible: !controller.loading.value,
                      replacement: const CircularProgressWidget(),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.setPassword();
                          }
                        },
                      child: const Text('Confirm'),
                    ),
                   ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
