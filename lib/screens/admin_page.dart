import 'package:flutter/material.dart';

import '../controllers/admin_controller.dart';
import 'package:get/get.dart';

import '../widgets/user_list_widget.dart';

class AdminPage extends StatelessWidget {
  AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: UserListWidget(type: 'admin',)
    );
  }
}

