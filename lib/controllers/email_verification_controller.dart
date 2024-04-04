import 'package:get/get.dart';
import 'package:task_manager_app_getx/api_req/clientApi.dart';
import 'package:task_manager_app_getx/presentation/screens/auth/pin_verification_screen.dart';

class EmailVerificationController extends GetxController {
  var loading = false.obs;
  var formValues = {"email": ""}.obs;

  void inputOnChange(String mapKey, String textValue) {
    formValues[mapKey] = textValue;
  }
  Future<void> verifyEmail() async {
    loading.value = true;
    bool res = await VerifyEmailRequest(formValues['email']!);
    if (res) {
      Get.to(PinVerificationScreen());
    }
    else{
      loading.value = false;
    }
  }
}
