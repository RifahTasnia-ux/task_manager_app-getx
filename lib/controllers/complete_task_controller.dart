import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/task_list_wrapper.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';

class CompleteTaskController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;
  TaskListWrapper _completeTaskListWrapper = TaskListWrapper();

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage ?? 'Get completed task list has been failed';

  TaskListWrapper get completeTaskListWrapper => _completeTaskListWrapper;

  Future<bool> getCompleteTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final response = await NetworkCaller.getRequest(Urls.completedTaskList);
    if (response.isSuccess) {
      _completeTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}