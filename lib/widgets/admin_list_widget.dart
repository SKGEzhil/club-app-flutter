import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import 'add_admin_dialogue.dart';

class AdminListWidget extends StatelessWidget {
  AdminListWidget({
    super.key,
  });

  final adminController = Get.put(AdminController());

  void removeUser(context, index){
    adminController.updateUserRole(context,
        adminController.adminUsers[index]
            .email, "user");
  }

  void showAddUserDialogue(context){
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: "Add admin",
        context: context,
        pageBuilder: (context, _, __) =>
            AddAdminDialogue()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Wrap(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        'All Admin Users',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonWidget(
                      onPressed: () => showAddUserDialogue(context),
                      buttonText: 'Add Admin',
                      textColor: Colors.blueAccent,
                      buttonColor: Colors.blue.withOpacity(0.1),
                    ),
                  )
                ],
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: 300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Scrollbar(
                    radius: Radius.circular(10),
                    thickness: 5,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: adminController.adminUsers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          adminController.adminUsers[index]
                                              .name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          adminController.adminUsers[index]
                                              .email,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black.withOpacity(
                                                  0.8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ButtonWidget(
                                    onPressed: () => removeUser(context, index),
                                    buttonText: 'Remove',
                                    textColor: Colors.redAccent,
                                    buttonColor: Colors.redAccent.withOpacity(0.1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

