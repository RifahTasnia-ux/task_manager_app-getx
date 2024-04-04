import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/login_response.dart';
import 'package:task_manager_app_getx/data/models/response_object.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';
import 'package:task_manager_app_getx/controllers/auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage ?? 'Login failed! Try again';

  Future<bool> signIn(String email, String password) async {
    _inProgress = true;
    update();

    Map<String, dynamic> inputParams = {
      'email': email,
      'password': password,
    };

    final ResponseObject response = await NetworkCaller.postRequest(
        Urls.login, inputParams,
        fromSignIn: true);

    _inProgress = false;

    if (response.isSuccess) {
      LoginResponse loginResponse =
      LoginResponse.fromJson(response.responseBody);

      await AuthController.saveUserData(loginResponse.userData!);
      await AuthController.saveUserToken(loginResponse.token!);

      update();
      return true;
    } else {

      update();
      return false;
    }
  }
}