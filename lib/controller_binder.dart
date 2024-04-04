import 'package:get/get.dart';

import 'controllers/add_new_task_controller.dart';
import 'controllers/cancelled_task_controller.dart';
import 'controllers/complete_task_controller.dart';
import 'controllers/count_task_by_status_controller.dart';
import 'controllers/delete_task_controller.dart';
import 'controllers/email_verification_controller.dart';
import 'controllers/new_task_controller.dart';
import 'controllers/pin_verification_controller.dart';
import 'controllers/progress_task_controller.dart';
import 'controllers/set_password_controller.dart';
import 'controllers/sign_in_controller.dart';
import 'controllers/sign_up_controller.dart';
import 'controllers/update_profile_controller.dart';
import 'controllers/update_task_controller.dart';


class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(SignUpController());
    Get.put(AddNewTaskController());
    Get.put(UpdateProfileController());
    Get.put(CountTaskByStatusController());
    Get.put(NewTaskController());
    Get.put(CancelledTaskController());
    Get.put(CompleteTaskController());
    Get.put(ProgressTaskController());
    Get.put(UpdatetaskController());
    Get.put(DeletetaskController());
    Get.put(EmailVerificationController());
    Get.put(PinVerificationController());
    Get.put(SetPasswordController());
  }
}