import 'dart:ui';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/screens/event_page.dart';
import 'package:flutter/material.dart';

import '../../config/colors.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key, required this.eventList, required this.date});

  final List<EventModel> eventList;
  final String date;

  void addToCalendar(event) {
    final Event calendarEvent = Event(
      title: event.name,
      description: event.description,
      location: event.location,
      startDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
      endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(event.date)),
      iosParams: const IOSParams(
        reminder: Duration(/* Ex. hours:1 */),
        // on iOS, you can set alarm notification after your event.
        url:
        'https://www.example.com', // on iOS, you can set url to your event.
      ),
      androidParams: const AndroidParams(
        emailInvites: [], // on Android, you can add invite emails to your event.
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: currentColors.oppositeColor.withOpacity(0.07),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Column(
                children: [
                  Text('${date.substring(0, 2)}',
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  Text('${date.substring(3, 6)}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  children: eventList
                      .map((event) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            // final iconColor = await isBright() ? Colors.black : Colors.white;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EventPage(eventId: event.id)),
                            );
                          },
                          child: Container(
                                                decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? currentColors.oppositeColor.withOpacity(0.07)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18.0),
                                                ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(event.formattedTime,
                                        style: TextStyle(
                                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                                    InkWell(
                                      customBorder: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      onTap: () => addToCalendar(event),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(Icons.notification_add_outlined),
                                        )
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3.0),
                                Text(event.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 17.0)),
                              ],
                            ),
                          )
                                              ),
                        ),
                      )
                  )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () async{
  //       // final iconColor = await isBright() ? Colors.black : Colors.white;
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => EventPage(eventId: event.id)),
  //       );
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Card(
  //         // color: Colors.white,
  //         elevation: 5,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(18.0),
  //         ),
  //         child:
  //         Stack(
  //           children: [
  //
  //             Positioned.fill(
  //               child: Container(
  //                 width: double.infinity,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(18.0),
  //                   image: DecorationImage(
  //                     image: CachedNetworkImageProvider(event.clubImageUrl),
  //                     opacity: 0.07,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //
  //             Padding(
  //               padding: const EdgeInsets.all(0),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(18.0),
  //                 child: BackdropFilter(
  //                   filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
  //                   child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(12.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 ClipRRect(
  //                                   borderRadius: BorderRadius.circular(50.0),
  //                                   child: CachedNetworkImage(
  //                                     fit: BoxFit.cover,
  //                                     width: 40,
  //                                     height: 40,
  //                                     imageUrl: event.clubImageUrl,
  //                                   ),
  //                                 ),
  //                                 const SizedBox(width: 10.0),
  //                                 Expanded(
  //                                   child: Text(event.clubName,
  //                                       maxLines: 1,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: const TextStyle(
  //                                           fontWeight: FontWeight.bold, fontSize: 17.0)),
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(height: 10.0),
  //                             Text(event.name,
  //                                 maxLines: 2,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: const TextStyle(
  //                                     fontWeight: FontWeight.bold, fontSize: 20.0)),
  //                             const SizedBox(height: 5.0),
  //                             Row(
  //                               children: [
  //                                 const Icon(
  //                                   Icons.calendar_month_outlined,
  //                                 ),
  //                                 const SizedBox(width: 5.0),
  //                                 Text(event.formattedDate,
  //                                     style: const TextStyle(
  //                                         fontSize: 15.0, fontWeight: FontWeight.w500)),
  //                               ],
  //                             ),
  //                             const SizedBox(height: 5.0),
  //                             Row(
  //                               children: [
  //                                 const Icon(Icons.location_on_outlined),
  //                                 const SizedBox(width: 5.0),
  //                                 Text(event.location,
  //                                     style: const TextStyle(
  //                                         fontSize: 15.0, fontWeight: FontWeight.w500)),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(16.0),
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.circular(15.0),
  //                         child: CachedNetworkImage(
  //                             width: 110,
  //                             height: 110,
  //                             fit: BoxFit.cover,
  //                             imageUrl: event.bannerUrl),
  //                       ),
  //                     )
  //                   ]),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
