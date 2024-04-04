import 'package:get/get.dart';
import 'package:task_manager_app_getx/api_req/clientApi.dart';
import 'package:task_manager_app_getx/data/utility/utility.dart';
import '../../style/styles.dart';
import '../presentation/screens/auth/sign_in_screen.dart';

class SetPasswordController extends GetxController {
  var loading = false.obs;
  var formValues = {
    "email": "",
    "OTP": "",
    "password": "",
    "cpassword": ""
  }.obs;

  @override
  void onInit() {
    callStoreData();
    super.onInit();
  }

  void callStoreData() async {
    String? otp = await ReadUserData("OTPVerification");
    String? email = await ReadUserData("EmailVerification");
    formValues.value['email'] = email ?? "";
    formValues.value['OTP'] = otp ?? "";
  }

  void inputOnChange(String mapKey, String textValue) {
    formValues.value[mapKey] = textValue;
  }

  Future<void> setPassword() async {
    if (formValues['password'] != formValues['cpassword']) {
      ErrorToast('Password and confirmed password should be same!');
    }
    else {
      loading.value = true;
      bool res = await SetPasswordRequest(formValues.value);
      if (res) {
        Get.off(SignInScreen());
      }
      else {
        loading.value = false;
      }
    }
  }
}
