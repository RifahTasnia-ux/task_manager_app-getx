import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/task_count_by_status_data.dart';
import 'package:task_manager_app_getx/controllers/count_task_by_status_controller.dart';
import 'package:task_manager_app_getx/controllers/new_task_controller.dart';
import 'package:task_manager_app_getx/presentation/screens/add_new_task_screen.dart';
import 'package:task_manager_app_getx/presentation/utils/app_colors.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_app_getx/presentation/widgets/task_card.dart';
import 'package:task_manager_app_getx/presentation/widgets/task_counter_card.dart';

import '../widgets/circular_progress_widget.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    _getDataFromApis();
  }

  void _getDataFromApis() {
    Get.find<CountTaskByStatusController>().getCountByTaskStatus();
    Get.find<NewTaskController>().getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Column(
          children: [
        GetBuilder<CountTaskByStatusController>(
        builder: (countTaskByStatusController) {
      return Visibility(
      visible: countTaskByStatusController.inProgress == false,
                replacement: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
             child: taskCounterSection(
            countTaskByStatusController.countByStatusWrapper.listOfTaskByStatusData ??[],
                ),

      );
    }),
    Expanded(
     child:
         GetBuilder<NewTaskController>(builder: (newTaskController) {
           return Visibility(
             visible: newTaskController.inProgress == false,
              replacement: const CircularProgressWidget(),
              child: RefreshIndicator(
              onRefresh: () async => _getDataFromApis(),
              child: Visibility(
               visible: newTaskController.newTaskListWrapper.taskList?.isNotEmpty ??false,
               replacement: const EmptyListWidget(),
              child: ListView.builder(
                  itemCount: newTaskController.newTaskListWrapper.taskList?.length ??0,
                 itemBuilder: (context, index) {
                    return TaskCard(
                     taskItem: newTaskController.newTaskListWrapper.taskList![index],
                     refreshList: () {
                        _getDataFromApis();
                        },
                       );
                     },
                    ),
                   ),
                  ),
                 );
               }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(AddNewTaskScreen());
          if (result != null && result == true) {
            _getDataFromApis();
          }
        },
        backgroundColor: AppColors.themeColor,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  Widget taskCounterSection(
      List<TaskCountByStatusData> listOfTaskCountByStatus) {
    return SizedBox(
      height: 115,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: listOfTaskCountByStatus.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return TaskCounterCard(
              title: listOfTaskCountByStatus[index].sId ?? '',
              amount: listOfTaskCountByStatus[index].sum ?? 0,
            );
          },
          separatorBuilder: (_, __) {
            return const SizedBox(
              width: 8,
            );
          },
        ),
      ),
    );
  }
}