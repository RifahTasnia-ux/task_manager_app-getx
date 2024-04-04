import 'package:get/get.dart';
import 'package:task_manager_app_getx/api_req/clientApi.dart';
import 'package:task_manager_app_getx/presentation/screens/auth/set_password_screen.dart';

import '../../data/utility/utility.dart';

class PinVerificationController extends GetxController {
  var loading = false.obs;
  var formValues = {"otp": ""}.obs;

  void inputOnChange(String mapKey, String textValue) {
    formValues[mapKey] = textValue;
  }

  Future<void> verifyOTP() async {
    loading.value = true;
    String? email = await ReadUserData("EmailVerification");
    bool res = await VerifyOTPRequest(email,formValues['otp']!);
    if (res) {
      Get.offAll(SetPasswordScreen());
    }
    else{
    loading.value = false;
    }
  }
}
