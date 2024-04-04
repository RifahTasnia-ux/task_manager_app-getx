import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app_getx/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_app_getx/presentation/screens/new_task_screen.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_app_getx/presentation/widgets/snack_bar_message.dart';


import '../../controllers/auth_controller.dart';
import '../../controllers/update_profile_controller.dart';
import '../widgets/circular_progress_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) => RegExp(
      r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$'
  ).hasMatch(input);
  final UpdateProfileController _updateProfileController = Get.find<UpdateProfileController>();
  bool isPasswordVisible =false;
  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _mobileTEController.text = AuthController.userData?.mobile ?? '';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48,),
                  Text(
                    'Update Profile',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 16,),
                  imagePickerButton(),
                  const SizedBox(height: 8,),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Email'
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                        hintText: 'First name'
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                        hintText: 'Last name'
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: 'Mobile'
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      else if (!isPhone(value!)) {
                        return 'Please enter a valid mobile number.';
                      }
                      return null;
                    },
                    maxLength: 11,
                  ),
                  const SizedBox(height: 8,),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password (Optional)',
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
                      if (value != null && value.isNotEmpty && value!.length <= 6) {
                        return 'Password should more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<UpdateProfileController>(
                        builder: (updateProfileController) {
                          return Visibility(
                            visible: updateProfileController.inProgress == false,
                            replacement: const CircularProgressWidget(),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _updateProfile();
                                }
                              },
                              child: const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget imagePickerButton() {
    return GestureDetector(
      onTap: () {
        pickImageFromGallery();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              child: const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                _pickedImage?.name ?? '',
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
  Future<void> _updateProfile() async {
    final result = await _updateProfileController.updateProfile(
      email: _emailTEController.text,
      firstName: _firstNameTEController.text,
      lastName: _lastNameTEController.text,
      mobile: _mobileTEController.text,
      password: _passwordTEController.text,
      pickedImage: _pickedImage,
    );
    if (result) {
      if (mounted) {
        showSnackBarMessage(context, 'Update Profile success!');
        Get.offAll(MainBottomNavScreen());
      }
    } else {
      if (!mounted) {
        return;
      }
      setState(() {});
        showSnackBarMessage(context, _updateProfileController.errorMessage);
      }
    }
  }


