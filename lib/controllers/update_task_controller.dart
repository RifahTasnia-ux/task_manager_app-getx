import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/task_item.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';

class UpdatetaskController extends GetxController {

  var tasks = <TaskItem>[].obs;

  String? _errorMessage;

  String get errorMessage =>
      _errorMessage ?? 'Update task status has been failed';

  Future<void> updateTaskStatus(String id, String status) async {
    final response = await NetworkCaller.getRequest(
        Urls.updateTaskStatus(id, status));
    if (response.isSuccess) {
      final index = tasks.indexWhere((task) => task.sId == id);
      if (index != -1) {
        tasks[index].status = status;
      }
      else {
        _errorMessage = response.errorMessage;
      }
    }
  }

}
