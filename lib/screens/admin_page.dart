import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';


import '../widgets/dialogue_widgets/new_club_dialogue.dart';
import '../widgets/app_widgets/user_list_widget.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              UserListWidget(
                type: 'admin',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ButtonWidget(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => NewClubDialogue());
                    },
                    buttonText: 'Create new club',
                    isNegative: false,),
              )
            ],
          ),
        ));
  }
}
