import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../controllers/clubs_controller.dart';
import 'button_widget.dart';

class AddUserDialogue extends StatelessWidget {
  AddUserDialogue({super.key, this.clubId, required this.type});

  final adminController = Get.put(AdminController());
  final clubsController = Get.put(ClubsController());
  final emailController = TextEditingController();

  final clubId;
  final String type;

  void addAdminUser(context) {
    adminController.updateUserRole(context, emailController.text, "admin");
    Navigator.pop(context);
  }

  void addClubUser(context) {
    clubsController.addUserToClub(context, clubId, emailController.text);
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  type == 'admin' ? 'Add Admin User' : 'Add Club User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                ),
                ButtonWidget(
                  onPressed: () => type == 'admin'
                      ? addAdminUser(context)
                      : addClubUser(context),
                  buttonText: 'Add user',
                  textColor: Colors.green,
                  buttonColor: Colors.green.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
