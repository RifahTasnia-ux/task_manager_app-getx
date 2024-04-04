import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_app_getx/data/models/user_data.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';

import 'auth_controller.dart';

class UpdateProfileController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;
  String? _errorMessage;
  String get errorMessage => _errorMessage ?? 'Update profile failed! Try again.';
  String? photo;
  @override

  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String? password,
    XFile? pickedImage,
  }) async {

    _inProgress = true;
    update();


    Map<String, dynamic> inputParams = {
      "email": email,
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "mobile": mobile.trim(),
    };


    if (password != null && password.isNotEmpty) {
      inputParams['password'] = password;
    }

    if (pickedImage != null) {
      List<int> bytes = await pickedImage.readAsBytes();
      photo = base64Encode(bytes);
      inputParams['photo'] = photo;
    }

    final response = await NetworkCaller.postRequest(Urls.updateProfile, inputParams);
    _inProgress = false;

    if (response.isSuccess && response.responseBody['status'] == 'success') {
      UserData userData = UserData(
        email: email,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        mobile: mobile.trim(),
        photo: photo,
      );
      await AuthController.saveUserData(userData);
      update();
      return true;
    } else {
      _errorMessage = response.errorMessage;
      update();
      return false;
    }
  }
}
