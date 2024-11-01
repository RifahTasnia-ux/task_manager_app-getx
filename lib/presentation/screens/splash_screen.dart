import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_app_getx/controllers/auth_controller.dart';
import 'package:task_manager_app_getx/presentation/screens/auth/sign_in_screen.dart';
import 'package:task_manager_app_getx/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_app_getx/presentation/widgets/app_logo.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }
  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    bool isLoggedIn = await AuthController.isUserLoggedIn();

    if (mounted) {
      if (isLoggedIn) {
        Get.off(MainBottomNavScreen());
      } else {
        Get.off(SignInScreen());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: BackgroundWidget(
          child: Center(
            child: AppLogo(),
          ),
        )
    );
  }
}
