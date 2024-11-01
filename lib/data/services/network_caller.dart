import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_app_getx/data/models/response_object.dart';
import 'package:task_manager_app_getx/controllers/auth_controller.dart';
import 'package:task_manager_app_getx/presentation/screens/auth/sign_in_screen.dart';

import '../../controllers/auth_controller.dart';

class NetworkCaller {
  static Future<ResponseObject> getRequest(String url) async {
    try {
      log(url);
      log(AuthController.accessToken.toString());
      final http.Response response = await http.get(Uri.parse(url),
          headers: {'token': AuthController.accessToken ?? ''});

      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
            isSuccess: true, statusCode: 200, responseBody: decodedResponse);
      } else if (response.statusCode == 401) {
        _moveToSignIn();
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
            //errorMessage: 'Email or password wrong !';
            );
      } else {
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '');
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responseBody: '',
          errorMessage: e.toString());
    }
  }

  static Future<ResponseObject> postRequest(
      String url, Map<String, dynamic> body, {bool fromSignIn = false}) async {
    try {
      log(url);
      log(body.toString());
      final http.Response response = await http.post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {
            'Content-type': 'application/json',
            'token': AuthController.accessToken ?? ''
          });

      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ResponseObject(
            isSuccess: true, statusCode: 200, responseBody: decodedResponse);
      } else if (response.statusCode == 401) {
        if (fromSignIn) {
          return ResponseObject(
          isSuccess: false,
          statusCode: response.statusCode,
          responseBody: '',
          errorMessage: 'Email/password is incorrect. Try again',
          );
        } else {
          _moveToSignIn();
          return ResponseObject(
              isSuccess: false,
              statusCode: response.statusCode,
              responseBody: '');
        }

      } else {
        return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '');
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responseBody: '',
          errorMessage: e.toString());
    }
  }
  static Future<void> _moveToSignIn() async {
    await AuthController.clearUserData();
    Get.offAll(
          () => SignInScreen(),
      predicate: (_) => false,
    );
  }
}