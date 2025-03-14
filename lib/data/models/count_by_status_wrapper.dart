import 'package:task_manager_app_getx/data/models/task_count_by_status_data.dart';

class CountByStatusWrapper {
  String? status;
  List<TaskCountByStatusData>? listOfTaskByStatusData;

  CountByStatusWrapper({this.status, this.listOfTaskByStatusData});

  CountByStatusWrapper.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      listOfTaskByStatusData = <TaskCountByStatusData>[];
      json['data'].forEach((v) {
        listOfTaskByStatusData!.add(TaskCountByStatusData.fromJson(v));
      });
    }
  }
}
