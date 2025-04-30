import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final isObscure = true.obs;
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  Future<void> login() async {
    isLoginProgress.value = true;
    final auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed('/home');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(e.code, e.message ?? '');
    } catch (e) {
      Get.snackbar('Error', 'An unknown error occurred\n${e.toString()}');
    } finally {
      isLoginProgress.value = false;
    }
  }

  Future<void> sendResetPasswordEmail() async {
    isSendEmailProgress.value = true;
    final auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      Get.snackbar(e.code, e.message ?? '');
    } catch (e) {
      Get.snackbar('Error', 'An unknown error occurred\n${e.toString()}');
    } finally {
      isSendEmailProgress.value = false;
    }
  }

  final isLoginProgress = false.obs;
  final isSendEmailProgress = false.obs;
}
