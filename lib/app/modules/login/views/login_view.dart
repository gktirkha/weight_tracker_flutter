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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              Obx(
                () => TextField(
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
                            ? Icons.remove_red_eye_outlined
                            : Icons.remove_red_eye,
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
                  onPressed: controller.login,
                  child: const Text('Login'),
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
                  onPressed: controller.sendResetPasswordEmail,
                  child: const Text('Send Password Reset Email'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
