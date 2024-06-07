import 'package:flutter/material.dart';

import '../controllers/admin_controller.dart';
import 'package:get/get.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  final adminController = Get.put(AdminController());

  final addUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: Obx(() {
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
                        padding: const EdgeInsets.fromLTRB(8,0,8,0),
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
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onTap: () {
                          showGeneralDialog(
                              barrierDismissible: true,
                              barrierLabel: "Add admin",
                              context: context,
                              pageBuilder: (context, _, __) => Center(
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
                                            const Text('Add user',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: addUserController,
                                                decoration: const InputDecoration(
                                                  hintText: 'Email',
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              customBorder: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50)),
                                              onTap: () {
                                                // adminController.addUser();
                                                adminController.updateUserRole(addUserController.text, "admin");
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.blue.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(50)),
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(15,6,15,6),
                                                  child: Text('Add user',
                                                    style: TextStyle(
                                                        color: Colors.blueAccent,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                          )
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,6,15,6),
                            child: Text('Add user',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            adminController.adminUsers[index].name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            adminController.adminUsers[index].email,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      customBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50)),
                                      onTap: () {
                                        adminController.updateUserRole(adminController.adminUsers[index].email, "user");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(50)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                          child: Text(
                                            'Remove',
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    )
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
      }),
    );
  }
}
