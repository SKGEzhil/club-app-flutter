import 'package:club_app/controllers/clubs_controller.dart';
import 'package:club_app/controllers/event_controller.dart';
import 'package:club_app/controllers/profile_controller.dart';
import 'package:club_app/screens/calendarPage.dart';
import 'package:club_app/widgets/app_widgets/event_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../models/event_model.dart';

class EventListWidget extends StatefulWidget {
  EventListWidget({super.key});

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  final eventController = Get.put(EventController());
  final profileController = Get.put(ProfileController());
  final clubsController = Get.put(ClubsController());
  bool showCompletedEvents = false;

  // Custom accent color - yellowish shade
  final Color accentColor = const Color(0xFFF5C518);

  bool get isAuthorized {
    final isAdmin = profileController.currentUser.value.role == 'admin';
    final isAnyClubMember = clubsController.clubList.any((club) => club.members
        .any((member) => member.id == profileController.currentUser.value.id));
    return isAdmin || isAnyClubMember;
  }

  List<EventModel> get upcomingEvents {
    final now = DateTime.now();
    return eventController.eventList
        .where((event) => event.dateTime.isAfter(now))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Newest first
  }

  List<EventModel> get completedEvents {
    final now = DateTime.now();
    return eventController.eventList
        .where((event) => event.dateTime.isBefore(now))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Newest first
  }

  Map<String, List<EventModel>> groupEventsByDate(List<EventModel> events) {
    final groupedEvents = <String, List<EventModel>>{};
    for (var event in events) {
      final date = event.formattedDate;
      if (!groupedEvents.containsKey(date)) {
        groupedEvents[date] = [];
      }
      groupedEvents[date]!.add(event);
    }
    return groupedEvents;
  }

  List<String> getDateList(List<EventModel> events) {
    final groupedEvents = groupEventsByDate(events);
    final dates = groupedEvents.keys.toList();
    
    // Sort dates based on the first event's timestamp in each group
    dates.sort((a, b) {
      final aEvents = groupedEvents[a]!;
      final bEvents = groupedEvents[b]!;
      return bEvents.first.dateTime.compareTo(aEvents.first.dateTime);
    });
    
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isDarkTheme = theme.brightness == Brightness.dark;
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Stack(
      children: [
        ListView(
          children: [
            // Upcoming Events Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Upcoming Events',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...getDateList(upcomingEvents).map((date) {
                  final dateEvents = upcomingEvents
                      .where((event) => event.formattedDate == date)
                      .toList()
                    ..sort((a, b) => a.dateTime.compareTo(b.dateTime)); // Sort by time within same date
                  return EventWidget(
                    eventList: dateEvents,
                    date: date,
                  );
                }).toList(),
                if (upcomingEvents.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No upcoming events',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Completed Events Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle button for completed events
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showCompletedEvents = !showCompletedEvents;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: showCompletedEvents
                            ? accentColor.withOpacity(0.1)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: showCompletedEvents
                              ? accentColor
                              : theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            showCompletedEvents
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                            color: showCompletedEvents
                                ? accentColor
                                : theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Completed Events',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: showCompletedEvents
                                  ? accentColor
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: showCompletedEvents
                                  ? accentColor
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: showCompletedEvents
                                    ? accentColor
                                    : theme.colorScheme.outline.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              '${completedEvents.length}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: showCompletedEvents
                                    ? theme.colorScheme.surface
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (showCompletedEvents) ...[
                  ...getDateList(completedEvents).map((date) {
                    final dateEvents = completedEvents
                        .where((event) => event.formattedDate == date)
                        .toList()
                      ..sort((a, b) => a.dateTime.compareTo(b.dateTime)); // Sort by time within same date
                    return EventWidget(
                      eventList: dateEvents,
                      date: date,
                    );
                  }).toList(),
                  if (completedEvents.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          'No completed events',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
            // Add bottom padding to account for FAB
            const SizedBox(height: 100),
          ],
        ),
        !isAuthorized
            ? const SizedBox()
            : Positioned(
                bottom: 100,
                right: 20,
                child: FloatingActionButton(
                  heroTag: 'calendar',
                  backgroundColor: accentColor,
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
