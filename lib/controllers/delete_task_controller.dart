import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/task_item.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';

import 'auth_controller.dart';

class DeletetaskController extends GetxController {

  var tasks = <TaskItem>[].obs;
  String? _errorMessage;
  String get errorMessage => _errorMessage ?? 'Delete task has been failed';
  Future<void> deleteTask(String id) async {
    final response = await NetworkCaller.getRequest(Urls.deleteTask(id));
    if (response.isSuccess) {
      tasks.removeWhere((task) => task.sId == id);
    }
    else {
      _errorMessage = response.errorMessage;
    }
  }
}

