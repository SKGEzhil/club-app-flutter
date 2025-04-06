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
        // on iOS, you can set alarm notification after your event.
        url:
        'https://www.example.com', // on iOS, you can set url to your event.
      ),
      androidParams: const AndroidParams(
        emailInvites: [
        ], // on Android, you can add invite emails to your event.
      ),
    );
    Add2Calendar.addEvent2Cal(calendarEvent);
  }


  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Scaffold(
      body: Padding(
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
    );
  }
}
