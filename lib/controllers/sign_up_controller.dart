import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/response_object.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';

import 'auth_controller.dart';

class SignUpController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage ?? 'Registration failed! Try again.';

  Future<bool> signUp(String email,String firstname,String lastname,String mobile, String password) async {
    _inProgress = true;
    update();

    Map<String, dynamic> inputParams = {
      'email': email,
      'firstname' : firstname,
      'lastname' : lastname,
      'mobile' : mobile,
      'password': password,
    };
    final ResponseObject response = await NetworkCaller.postRequest(
        Urls.registration, inputParams);

    _inProgress = false;

    if (response.isSuccess) {
      update();
      return true;
    } else {
      _errorMessage = response.errorMessage;
      update();
      return false;
    }
  }
}