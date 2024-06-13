import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  const EventPage({
    super.key,
    required this.event,
  });

  final EventModel event;
  // final Color leadingIconColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 370,
                        imageUrl: event.bannerUrl)),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(event.clubImageUrl),
                            radius: 15,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            event.clubName,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      event.name,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month_rounded, size: 40),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${event.formattedDate}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.blue),
                            ),
                            Text(
                              '${event.formattedTime}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ],
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: ButtonWidget(
                                    onPressed: () {},
                                    buttonText: 'Add to Calendar',
                                    textColor: Colors.blue,
                                    buttonColor: Colors.blue.withOpacity(0.1))))
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 8,
                  ),
                  Card(

                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 40),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${event.location}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.blue),
                            ),
                            Text(
                              'Location',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description',
                              style:
                              TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            event.description,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
