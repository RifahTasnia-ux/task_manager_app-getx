import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/data/models/task_item.dart';
import '../controllers/delete_task_controller.dart';
import '../controllers/update_task_controller.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskItem,
    required this.refreshList,
  });
  final TaskItem taskItem;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<UpdatetaskController>();
    final deletetaskController = Get.find<DeletetaskController>();

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskItem.title ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.taskItem.description ?? ''),
            Text('Date: ${widget.taskItem.createdDate}'),
            Row(
              children: [
                Chip(label: Text(widget.taskItem.status ?? '')),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    _showUpdateStatusDialog(context, widget.taskItem.sId!);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    deletetaskController.deleteTask(widget.taskItem.sId!);
                    widget.refreshList();
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showUpdateStatusDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('New'),
                onTap: () {
                  Get.back(); // Close the dialog
                  _updateTaskStatus(id, 'New');
                },
              ),
              ListTile(
                title: const Text('Completed'),
                onTap: () {
                  Get.back();
                  _updateTaskStatus(id, 'Completed');
                },
              ),
              ListTile(
                title: const Text('Progress'),
                onTap: () {
                  Get.back();
                  _updateTaskStatus(id, 'Progress');
                },
              ),
              ListTile(
                title: const Text('Cancelled'),
                onTap: () {
                  Get.back();
                  _updateTaskStatus(id, 'Cancelled');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateTaskStatus(String id, String status) {
    final updatetaskController = Get.find<UpdatetaskController>();
    updatetaskController.updateTaskStatus(id, status).then((_) {
      widget.refreshList();
    });
  }
}

