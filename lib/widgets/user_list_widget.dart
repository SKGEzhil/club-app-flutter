import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/user_model.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../controllers/admin_controller.dart';
import '../controllers/clubs_controller.dart';
import '../controllers/profile_controller.dart';
import 'add_user_dialogue.dart';

class UserListWidget extends StatelessWidget {
  UserListWidget({
    super.key, required this.type, this.clubId,
  });

  final adminController = Get.put(AdminController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());

  UserModel get currentUser => profileController.currentUser.value;

  bool get isAuthorized {
    if(clubId != null){
      print("current user: ${currentUser.role}");
      return currentUser.role == 'admin' || clubsController.clubList.where((club) => club.id == clubId).first.members.any((member) => member.id == currentUser.id);
    } else {
      print("current user: ${currentUser.role}");
      return currentUser.role == 'admin';
    }
  }

  final clubId;
  final String type;

  void removeAdminUser(context, index){
    adminController.updateUserRole(context,
        adminController.adminUsers[index]
            .email, "user");
    Navigator.pop(context);
  }

  void removeClubUser(context, index){
    clubsController.removeUserFromClub(context, clubId,
        clubsController.clubList.where((club) => club.id == clubId).first.members[index].email);
    Navigator.pop(context);
  }

  void showAddUserDialogue(context){
    showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: type == 'admin' ? 'Add Admin User' : 'Add Club User',
        context: context,
        pageBuilder: (context, _, __) =>
            AddUserDialogue(type: type, clubId: clubId,)
    );
  }

  @override
  Widget build(BuildContext context) {

    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
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
                      child: Text(type == 'admin' ? 'All Admin Users' : 'All Club Members',
                        style: TextStyle(
                            // color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    !isAuthorized ? SizedBox(
                      height: 40,
                    ) :
                    ButtonWidget(
                      onPressed: () => showAddUserDialogue(context),
                      buttonText: type == 'admin' ? 'Add Admin' : 'Add Member',
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
                      itemCount: type == 'admin' ? adminController.adminUsers.length :
                      clubsController.clubList.where((club) => club.id == clubId).first.members.length,
                      itemBuilder: (context, index) {

                        final user = type == 'admin' ? adminController.adminUsers[index] :
                        clubsController.clubList.where((club) => club.id == clubId).first.members[index];

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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      width: 40,
                                      height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: user.photoUrl),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          user.email,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: currentColors.secondaryTextColor
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  !isAuthorized

                              ? SizedBox() :

                                  ButtonWidget(
                                    onPressed: (){
                                      showDialog(context: context, builder: (context){
                                        return CustomAlertDialogue(context: context,
                                            onPressed: () => type == 'admin' ? removeAdminUser(context, index) : removeClubUser(context, index),
                                            title: 'Remove User',
                                            content: 'Are you sure you want to remove ${user.name} from ${type == 'admin' ? 'Admin' : 'the Club'}?');
                                      });
                                    },
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

