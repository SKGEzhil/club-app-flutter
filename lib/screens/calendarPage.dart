import 'dart:ffi';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/screens/event_page.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/colors.dart';
import '../controllers/event_controller.dart';
import '../screens/create_event_page.dart';
import '../widgets/custom_calendar.dart';
import 'package:club_app/screens/secret_info_page.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({super.key});

  final eventController = Get.put(EventController());

  List<EventModel> get eventList {
    return eventController.eventList;
  }

  void addToCalendar(EventModel event) {
    final Event calendarEvent = Event(
      title: event.name,
      description: event.description,
      location: event.location,
      startDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
      endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
      iosParams: const IOSParams(
        reminder: Duration(/* Ex. hours:1 */),
        url: 'https://www.example.com',
      ),
      androidParams: const AndroidParams(
        emailInvites: [],
      ),
    );
    Add2Calendar.addEvent2Cal(calendarEvent);
  }

  AppBar buildAppBar(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.chevron_left, color: currentColors.oppositeColor, size: 30),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: GestureDetector(
        onTap: Info().handleTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Calendar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: currentColors.oppositeColor,
              ),
            ),
            Text(
              'Event Calendar',
              style: TextStyle(
                fontSize: 15,
                color: currentColors.oppositeColor.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: currentColors.oppositeColor.withOpacity(0.05),
                ),
                margin: const EdgeInsets.all(16),
                child: CustomCalendar(
                  events: eventList,
                  onEventTap: (event) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventPage(eventId: event.id),
                      ),
                    );
                  },
                  onAddToCalendar: addToCalendar,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_event',
        backgroundColor: currentColors.mainColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEventPage(),
            ),
          );
        },
        child: Icon(Icons.add, color: currentColors.oppositeColor),
      ),
    );
  }
}
