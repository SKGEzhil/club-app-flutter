import 'dart:ffi';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/screens/event_page.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:get/get.dart';
import '../config/colors.dart';
import '../controllers/event_controller.dart';
import '../screens/create_event_page.dart';
import 'package:club_app/screens/secret_info_page.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({super.key});

  final eventController = Get.put(EventController());

  List<EventModel> get eventList {
    return eventController.eventList;
  }

  List<NeatCleanCalendarEvent> get _eventList {
    return eventList
        .map(
          (event) => NeatCleanCalendarEvent(
              event.name,
              metadata: {
                'id': event.id,
                'name': event.name,
                'description': event.description,
                'date': event.date,
                'time': event.formattedTime,
                'clubName': event.clubName,
                'location': event.location,
              },
              startTime: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
              endTime: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
              color: Colors.orange,
              isMultiDay: true),
        )
        .toList();
  }

  void addToCalendar(event) {
    final Event calendarEvent = Event(
      title: event['name'],
      description: event['description'],
      location: event['location'],
      startDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event['date'])),
      endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event['date'])),
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
      title: GestureDetector(
        onTap: Info().handleTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: currentColors.oppositeColor.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Calendar(
                startOnMonday: true,
                weekDays: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                eventsList: _eventList,
                isExpandable: true,
                eventDoneColor: currentColors.oppositeColor.withOpacity(0.5),
                defaultDayColor: currentColors.oppositeColor,
                selectedColor: Theme.of(context).primaryColor,
                selectedTodayColor: Theme.of(context).primaryColor,
                todayColor: Theme.of(context).primaryColor,
                eventColor: null,
                locale: 'en_US',
                todayButtonText: 'Events',
                isExpanded: true,
                expandableDateFormat: 'EEEE, dd MMMM yyyy',
                datePickerType: DatePickerType.date,
                dayOfWeekStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                eventListBuilder: (context, eventList) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            eventList.length > 0 ? 'Events' : 'No Events on this day',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Column(
                          children: eventList.map((event) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventPage(eventId: event.metadata?['id'])));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: currentColors.oppositeColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                              event.metadata?['name'],
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(event.metadata?['time']),
                                        ),
                                      ),
                                      ButtonWidget(
                                        onPressed: (){
                                          addToCalendar(event.metadata);
                                        },
                                        preceedingIcon: Icons.notifications_active_outlined,
                                        isNegative: false,
                                        buttonText: '',),
                                      SizedBox(width: 8,)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList()
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
