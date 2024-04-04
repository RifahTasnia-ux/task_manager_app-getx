import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/task_list_wrapper.dart';
import 'package:task_manager_app_getx/data/services/network_caller.dart';
import 'package:task_manager_app_getx/data/utility/urls.dart';

class CancelledTaskController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;
  TaskListWrapper _cancelledTaskListWrapper = TaskListWrapper();

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage ?? 'Get cancelled task list has been failed';

  TaskListWrapper get cancelledTaskListWrapper => _cancelledTaskListWrapper;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    final response = await NetworkCaller.getRequest(Urls.cancelledTaskList);
    if (response.isSuccess) {
      _cancelledTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}