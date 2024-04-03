import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/presentation/controllers/complete_task_controller.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_app_getx/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/task_card.dart';
import '../widgets/circular_progress_widget.dart';


class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getCompleteTaskList();
  }
  void _getCompleteTaskList() {
    Get.find<CompleteTaskController>().getCompleteTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child:
        GetBuilder<CompleteTaskController>(builder: (completeTaskController) {
          return Visibility(
            visible: completeTaskController.inProgress == false,
            replacement: const CircularProgressWidget(),
            child: RefreshIndicator(
              onRefresh: () async => _getCompleteTaskList(),
              child: Visibility(
                visible: completeTaskController.completeTaskListWrapper.taskList?.isNotEmpty ??false,
                replacement: const EmptyListWidget(),
                child: ListView.builder(
                  itemCount: completeTaskController.completeTaskListWrapper.taskList?.length ??0,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskItem: completeTaskController.completeTaskListWrapper.taskList![index],
                      refreshList: () {
                        _getCompleteTaskList();
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

