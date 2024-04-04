import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/response_object.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';


class AddNewTaskController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage ?? 'Add new task failed!';

  Future<bool> addNewTask(String title, String description, String status) async {
    _inProgress = true;
    update();

    Map<String, dynamic> inputParams = {
      'title': title,
      'description': description,
      'status' : status
    };

    final ResponseObject response = await NetworkCaller.postRequest(
        Urls.createTask, inputParams);

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