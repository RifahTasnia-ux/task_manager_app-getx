import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/controllers/count_task_by_status_controller.dart';
import 'package:task_manager_app_getx/controllers/cancelled_task_controller.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_app_getx/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/task_card.dart';
import '../widgets/circular_progress_widget.dart';


class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }
  void _getCancelledTaskList() {
    Get.find<CountTaskByStatusController>().getCountByTaskStatus();
    Get.find<CancelledTaskController>().getCancelledTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child:
           GetBuilder<CancelledTaskController>(builder: (cancelledTaskController) {
             return Visibility(
              visible: cancelledTaskController.inProgress == false,
              replacement: const CircularProgressWidget(),
           child: RefreshIndicator(
             onRefresh: () async => _getCancelledTaskList(),
             child: Visibility(
                  visible: cancelledTaskController.cancelledTaskListWrapper.taskList?.isNotEmpty ??false,
                  replacement: const EmptyListWidget(),
             child: ListView.builder(
                itemCount: cancelledTaskController.cancelledTaskListWrapper.taskList?.length ??0,
                itemBuilder: (context, index) {
              return TaskCard(
                taskItem: cancelledTaskController.cancelledTaskListWrapper.taskList![index],
              refreshList: () {
                    _getCancelledTaskList();
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

