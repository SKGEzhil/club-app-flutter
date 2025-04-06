import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/controllers/event_controller.dart';
import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/screens/calendarPage.dart';
import 'package:club_app/widgets/app_widgets/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../models/event_model.dart';

class EventListWidget extends StatelessWidget {
  EventListWidget({super.key});

  final eventController = Get.put(EventController());
  final profileController = Get.put(ProfileController());
  final clubsController = Get.put(ClubsController());

  bool get isAuthorized {
    final isAdmin = profileController.currentUser.value.role == 'admin';
    final isAnyClubMember = clubsController.clubList.any((club) => club.members
        .any((member) => member.id == profileController.currentUser.value.id));
    return isAdmin || isAnyClubMember;
  }

  List<EventModel> get todayEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    return eventList
        .where((event) =>
            DateTime(event.dateTime.year, event.dateTime.month,
                event.dateTime.day) ==
            DateTime(today.year, today.month, today.day))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get thisWeekEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    final nextWeek = today.add(const Duration(days: 7));
    return eventList
        .where((event) =>
            event.dateTime.isAfter(today) && event.dateTime.isBefore(nextWeek))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get thisMonthEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    final thisWeek = today.add(const Duration(days: 7));
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 1);
    return eventList
        .where((event) =>
            event.dateTime.isAfter(thisWeek) &&
            event.dateTime.isBefore(lastDayOfMonth))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get upcomingEventList {
    final eventList = eventController.eventList;
    final today = DateTime.now();
    final lastDayOfMonth = DateTime(today.year, today.month + 1, 1);
    return eventList
        .where((event) => event.dateTime.isAfter(lastDayOfMonth))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EventModel> get sortedEventList {
    final eventList = eventController.eventList;
    eventList.sort((a, b) => a.date.compareTo(b.date));
    return eventList;
  }

  List<String> get dateList {
    final eventList = eventController.eventList;
    List<String> dateList = [];
    eventList.forEach((event) {
      dateList.contains(event.formattedDate)
          ? null
          : dateList.add(event.formattedDate);
    });
    return dateList;
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Stack(
      children: [
        ListView(
          children: [
            Column(
                children: dateList.map((date) {
                  return EventWidget(
                      eventList: sortedEventList
                          .where((event) => event.formattedDate == date)
                          .map((event) => event)
                          .toList(),
                      date: date);
                }).toList(),
              )
          ],
        ),

        
        !isAuthorized
            ? const SizedBox()
            : Positioned(
                bottom: 100,
                right: 20,
                child: FloatingActionButton(
                  heroTag: 'calendar',
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarPage(),
                      ),
                    );
                  },
                  child: Icon(Icons.calendar_month, color: Colors.black.withOpacity(0.7)),
                ),
              ),
      ],
    );
  }
}
