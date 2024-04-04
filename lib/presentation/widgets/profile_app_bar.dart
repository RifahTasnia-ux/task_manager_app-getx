import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_app_getx/app.dart';
import 'package:task_manager_app_getx/controllers/auth_controller.dart';
import 'package:task_manager_app_getx/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_app_getx/presentation/screens/update_profile_screen.dart';
import 'package:task_manager_app_getx/presentation/utils/app_colors.dart';

PreferredSizeWidget get profileAppBar {
  String? photoBase64 = AuthController.userData?.photo;
  MemoryImage? avatarImage;
  try{
    if(photoBase64 != null){
      List<int> photoBytes = base64Decode(photoBase64);
      Uint8List bytes = Uint8List.fromList(photoBytes);
      avatarImage = MemoryImage(bytes);
    }
  } catch (e){
    print('Error decoding Base64 image: $e');
  }
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.themeColor,
    title: GestureDetector(
      onTap: () {
        Get.to(UpdateProfileScreen());
      },
      child: Row(
          children: [
            CircleAvatar(
                backgroundImage: avatarImage,
            ),
      const SizedBox(
        width: 12,
          ), Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    AuthController.userData?.email ?? '',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () async {
                  await AuthController.clearUserData();
                  Get.offAll(SignInScreen());
                },
                icon: const Icon(Icons.logout))
          ],
      ),
    ),
  );
}

