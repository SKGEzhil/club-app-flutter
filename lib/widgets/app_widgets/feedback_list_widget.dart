import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/feedback_controller.dart';
import '../../screens/feedback_page.dart';

class FeedbackListWidget extends StatelessWidget {
  FeedbackListWidget({super.key});

  final feedbackController = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Obx(() {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: feedbackController.feedbackList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FeedbackPage(
                          feedbackForm: feedbackController.feedbackList[0])));
                },
                child: ListTile(
                  title: Text(feedbackController.feedbackList[index].clubName),
                  subtitle:
                      Text(feedbackController.feedbackList[index].eventName),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
