import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/presentation/controllers/progress_task_controller.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_app_getx/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/task_card.dart';
import '../widgets/circular_progress_widget.dart';


class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }
  void _getProgressTaskList() {
    Get.find<ProgressTaskController>().getProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child:
        GetBuilder<ProgressTaskController>(builder: (progressTaskController) {
          return Visibility(
            visible: progressTaskController.inProgress == false,
            replacement: const CircularProgressWidget(),
            child: RefreshIndicator(
              onRefresh: () async => _getProgressTaskList(),
              child: Visibility(
                visible: progressTaskController.progressTaskListWrapper.taskList?.isNotEmpty ??false,
                replacement: const EmptyListWidget(),
                child: ListView.builder(
                  itemCount: progressTaskController.progressTaskListWrapper.taskList?.length ??0,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskItem: progressTaskController.progressTaskListWrapper.taskList![index],
                      refreshList: () {
                        _getProgressTaskList();
                      },
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

