import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import 'button_widget.dart';

class AddAdminDialogue extends StatelessWidget {
  AddAdminDialogue({
    super.key
  });

  final adminController = Get.put(AdminController());
  final emailController = TextEditingController();

  void addUser(context){
    adminController.updateUserRole(
        emailController.text, "admin");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(
                    20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Add user',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight
                              .bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(
                          8.0),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                    ),

                    ButtonWidget(
                      onPressed: () => addUser(context),
                      buttonText: 'Add user',
                      textColor: Colors.green,
                      buttonColor: Colors.green.withOpacity(0.1),
                    ),

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
