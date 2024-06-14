import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:club_app/models/event_model.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_alert_dialogue.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/clubs_controller.dart';
import '../controllers/event_controller.dart';
import '../controllers/profile_controller.dart';
import 'club_info_page.dart';
import 'club_page.dart';

class EventPage extends StatefulWidget {
  EventPage({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final isEditMode = false.obs;

  final editNameController = TextEditingController();

  final editDescriptionController = TextEditingController();

  final editLocationController = TextEditingController();

  var editedEventDate;

  final eventController = Get.put(EventController());

  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());

  bool get isAuthorized =>
      profileController.currentUser.value.role == 'admin' ||
      clubsController.clubList
          .where((club) => club.id == widget.event.clubId)
          .first
          .members
          .any((member) => member.id == profileController.currentUser.value.id);

  Future<void> updateEvent(context) async {
    final result = await eventController.updateEvent(
        widget.event.id,
        editNameController.text,
        editDescriptionController.text,
        '${editedEventDate == null ? widget.event.date : editedEventDate}',
        editLocationController.text,
        widget.event.clubId);

    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);

    isEditMode.value = !isEditMode.value;
    Navigator.pop(context);
  }

  Future<void> deleteEvent(context) async {
    final result = await eventController.deleteEvent(widget.event.id);

    result['status'] == 'error'
        ? CustomSnackBar.show(context,
            message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
            message: result['message'], color: Colors.green);

    Navigator.pop(context);
  }

  // final Color leadingIconColor;
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
    editNameController.text = widget.event.name;
    editDescriptionController.text = widget.event.description;
    editLocationController.text = widget.event.location;

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
                        imageUrl: widget.event.bannerUrl)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ClubInfoPage(clubId: widget.event.clubId)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      widget.event.clubImageUrl),
                                  radius: 15,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.3),
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    widget.event.clubName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        return Container(
                          child:
                              !isAuthorized ? SizedBox() :
                          Container(
                            child: isEditMode.value
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ButtonWidget(
                                          onPressed: () {
                                            isEditMode.value =
                                                !isEditMode.value;
                                          },
                                          buttonText: 'Cancel',
                                          textColor: Colors.red,
                                          buttonColor:
                                              Colors.red.withOpacity(0.1)),
                                      SizedBox(width: 8),
                                      ButtonWidget(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CustomAlertDialogue(
                                                      context: context,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        updateEvent(context);
                                                      },
                                                      title: 'Conform Edit',
                                                      content:
                                                          'Are you sure you want to edit this event?',
                                                    ));
                                          },
                                          buttonText: 'Done',
                                          textColor: Colors.blue,
                                          buttonColor:
                                              Colors.blue.withOpacity(0.1)),
                                    ],
                                  )
                                : ButtonWidget(
                                    onPressed: () {
                                      isEditMode.value = !isEditMode.value;
                                    },
                                    preceedingIcon: Icons.edit,
                                    buttonText: 'Edit',
                                    textColor: Colors.blue,
                                    buttonColor: Colors.blue.withOpacity(0.1)),
                          ),
                        );
                      })
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: isEditMode.value
                          ? Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue.withOpacity(0.4),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: TextFormField(
                                  controller: editNameController,
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null,
                                ),
                              ),
                            )
                          : Text(
                              widget.event.name,
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                    );
                  }),
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
                            Obx(() {
                              return Text(
                                isEditMode.value
                                    ? editedEventDate != null
                                        ? DateFormat('dd MMM')
                                            .format(editedEventDate)
                                        : widget.event.formattedDate
                                    : widget.event.formattedDate,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.blue),
                              );
                            }),
                            Obx(() {
                              return Text(
                                isEditMode.value
                                    ? editedEventDate != null
                                        ? DateFormat.jm()
                                            .format(editedEventDate)
                                        : widget.event.formattedTime
                                    : widget.event.formattedTime,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              );
                            }),
                          ],
                        ),
                        Expanded(child: Obx(() {
                          return Align(
                              alignment: Alignment.centerRight,
                              child: isEditMode.value
                                  ? ButtonWidget(
                                      onPressed: () async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            initialDate: DateTime.now(),
                                            lastDate: DateTime(
                                                DateTime.now().year + 2));
                                        final time = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          setState(() {
                                            if (date != null && value != null) {
                                              editedEventDate = DateTime(
                                                  date.year,
                                                  date.month,
                                                  date.day,
                                                  value.hour,
                                                  value.minute);
                                            }
                                          });
                                        });
                                      },
                                      buttonText: 'Change Date',
                                      textColor: Colors.blue,
                                      buttonColor: Colors.blue.withOpacity(0.1))
                                  : ButtonWidget(
                                      onPressed: () {
                                        addToCalendar(widget.event);
                                      },
                                      buttonText: 'Add to Calendar',
                                      textColor: Colors.blue,
                                      buttonColor:
                                          Colors.blue.withOpacity(0.1)));
                        }))
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                return Container(
                                  child: isEditMode.value
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blue
                                                      .withOpacity(0.4),
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: TextFormField(
                                              controller:
                                                  editLocationController,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          '${widget.event.location}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.blue),
                                        ),
                                );
                              }),
                              Text(
                                'Location',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ],
                          ),
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
                          Row(
                            children: [
                              Text('Description',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Obx(() {
                            return Container(
                              child: isEditMode.value
                                  ? Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.blue.withOpacity(0.4),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: TextFormField(
                                          controller: editDescriptionController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          maxLines: null,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      widget.event.description,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                            );
                          }),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  !isAuthorized ? SizedBox() :
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonWidget(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialogue(
                                    context: context,
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await deleteEvent(context);
                                    },
                                    title: 'Conform Delete',
                                    content:
                                        'Are you sure you want to delete this event? This action cannot be undone',
                                  ));
                        },
                        buttonText: 'Delete Event',
                        textColor: Colors.red,
                        buttonColor: Colors.red.withOpacity(0.1)),
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
