import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_app_getx/presentation/utils/app_colors.dart';
import 'package:task_manager_app_getx/presentation/widgets/background_widget.dart';

import '../../../controllers/pin_verification_controller.dart';
import '../../widgets/circular_progress_widget.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});


  @override
  State<PinVerificationScreen> createState() =>
      _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PinVerificationController controller = Get.put(PinVerificationController());
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    'Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'A 6 digits verification number code has been sent to your email address',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PinCodeTextField(
                    controller: otpController,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly],
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        inactiveColor: AppColors.themeColor,
                        selectedFillColor: Colors.white),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onCompleted: (v) {},
                    onChanged: (value) {
                      controller.inputOnChange('otp', value);
                    },
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter the pin code you received.';
                      }
                      if (value!.length < 6) {
                        return 'Pin should be 6 digits.';
                      }
                      return null;
                    },
                    appContext: context,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: !controller.loading.value,
                      replacement: const CircularProgressWidget(),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            controller.verifyOTP();
                          }
                        },
                      child: const Text('Verify'),
                    ),
                   ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
