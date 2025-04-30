import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                TextField(
                  onSubmitted: (value) {
                    controller.passwordNode.requestFocus();
                  },
                  focusNode: controller.emailNode,
                  autofillHints: [AutofillHints.email],
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                ),
                Obx(
                  () => TextField(
                    onSubmitted: (value) {
                      controller.login();
                      Get.focusScope?.unfocus();
                    },
                    focusNode: controller.passwordNode,
                    autofillHints: [AutofillHints.password],
                    obscureText: controller.isObscure.value,
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      suffix: IconButton(
                        onPressed: () {
                          controller.isObscure.value =
                              !controller.isObscure.value;
                        },
                        icon: Icon(
                          controller.isObscure.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    obscuringCharacter: '*',
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                        controller.isLoginProgress.value
                            ? null
                            : controller.login,
                    child: Obx(
                      () =>
                          controller.isLoginProgress.value
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Login'),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed:
                        controller.isSendEmailProgress.value
                            ? null
                            : controller.sendResetPasswordEmail,
                    child: Obx(
                      () =>
                          controller.isSendEmailProgress.value
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Send Password Reset Email'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
