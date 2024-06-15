import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/loading_controller.dart';
import '../widgets/loading_widget.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authenticationController = Get.put(AuthenticationController());
  final loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(

            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onTap: () async {
                loadingController.toggleLoading();
                final result = await authenticationController.authenticate(context);
                loadingController.toggleLoading();
                result['status'] == 'error'
                        ? CustomSnackBar.show(context,
                            message: result['message'], color: Colors.red)
                        : CustomSnackBar.show(context,
                    message: result['message'], color: Colors.green);
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ?
                    'assets/android_light_rd_ctn@4x.png' : 'assets/android_dark_rd_ctn@4x.png'
                ),
              ),
            ),
          ),
          Obx(() {
            return Container(
              child:
              loadingController.isLoading.value
                  ?
              LoadingWidget() : null,
            );
          }),
        ],
      ),
    );
  }
}
