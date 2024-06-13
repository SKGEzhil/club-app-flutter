import 'package:club_app/widgets/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/event_controller.dart';
import '../screens/create_event_page.dart';

class EventListWidget extends StatelessWidget {
  EventListWidget({super.key});

  final eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        final eventWidgetList = eventController.eventList
            .map((event) => SizedBox(child: EventWidget(event: event,)))
            .toList();
        eventWidgetList.add(SizedBox(height: 100,));
        return Stack(
          children: [
            ListView(
                children: eventWidgetList
            ),
            Positioned(
              bottom: 80,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateEventPage()));
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
