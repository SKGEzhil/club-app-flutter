import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentication_controller.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authenticationController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await authenticationController.authenticate(context);
            result['status'] == 'error'
                ? CustomSnackBar.show(context,
                    message: result['message'], color: Colors.red)
                : null;
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
