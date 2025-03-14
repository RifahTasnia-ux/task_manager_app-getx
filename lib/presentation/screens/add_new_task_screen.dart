import 'package:flutter/material.dart';
import 'package:task_manager_app_getx/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';
import 'package:task_manager_app_getx/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_app_getx/presentation/widgets/snack_bar_message.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/controllers/add_new_task_controller.dart';
import '../widgets/circular_progress_widget.dart';


class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AddNewTaskController _addNewTaskController = Get.find<AddNewTaskController>();
  bool _shouldRefreshNewTaskList = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _shouldRefreshNewTaskList);
      },
      child: Scaffold(
        appBar: profileAppBar,
        body: BackgroundWidget(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48,),
                    Text(
                      'Add New Task',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: const InputDecoration(
                          hintText: 'Title'
                      ),
                      validator: (String? value) {
                        if (value
                            ?.trim()
                            .isEmpty ?? true) {
                          return 'Enter your title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: _descriptionTEController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          hintText: 'Description'
                      ),
                      validator: (String? value) {
                        if (value
                            ?.trim()
                            .isEmpty ?? true) {
                          return 'Enter your description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<AddNewTaskController>(
                          builder: (addnewtaskcontroller) {
                            return Visibility(
                              visible: addnewtaskcontroller.inProgress == false,
                              replacement: const CircularProgressWidget(),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _addNewTask();
                                  }
                                },
                                child: const Icon(
                                    Icons.arrow_circle_right_outlined),
                              ),
                            );
                          }
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(result: _addNewTask);
                          showSnackBarMessage(context, 'Please Refresh Screen.');
                        },
                        child: const Text('Go Back to Home Screen'),
                      ),
                    ),
                  ],
                ),
              ),

            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewTask() async {
    final result = await _addNewTaskController.addNewTask(
        _titleTEController.text.trim(),
        _descriptionTEController.text.trim(),
        "New");

    if (result) {
      _shouldRefreshNewTaskList = true;
      _titleTEController.clear();
      _descriptionTEController.clear();
      if (mounted) {
        showSnackBarMessage(context, 'New task has been added!');
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, _addNewTaskController.errorMessage);
      }
    }
    @override
    void dispose() {
      _titleTEController.dispose();
      _descriptionTEController.dispose();
      super.dispose();
    }
  }
}
