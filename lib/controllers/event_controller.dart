import 'package:club_app/models/event_model.dart';
import 'package:club_app/utils/repositories/event_repository.dart';
import 'package:club_app/utils/shared_prefs.dart';
import 'package:get/get.dart';

import 'network_controller.dart';

class EventController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    final networkController = Get.find<NetworkController>();
    networkController.isOnline.value ?
    fetchEvents() : fetchEventsFromSharedPrefs();
  }

  var eventList = <EventModel>[
    // EventModel(
    //     name: 'New Year Party 2024',
    //     description: 'Description 1',
    //     date: 'Jun 14',
    //     bannerUrl: 'Banner Url 1',
    //     location: 'Hyderabad',
    //     clubName: 'Club 1',
    //     clubImageUrl: 'https://via.placeholder.com/50x50',
    //     clubId: '1', id: ''),
    // EventModel(
    //     name: 'Event 2',
    //     description: 'Description 2',
    //     date: 'Date 2',
    //     bannerUrl: 'Banner Url 2',
    //     location: 'Location 2',
    //     clubName: 'Club 2',
    //     clubImageUrl: 'https://via.placeholder.com/50x50',
    //     clubId: '1', id: ''),
    // EventModel(
    //     name: 'Event 3',
    //     description: 'Description 3',
    //     date: 'Date 3',
    //     bannerUrl: 'Banner Url 3',
    //     location: 'Location 3',
    //     clubName: 'Club 3',
    //     clubImageUrl: 'https://via.placeholder.com/50x50',
    //     clubId: '1', id: ''),
  ].obs;

  Future<void> fetchEvents() async {
    eventList.value = await EventRepository().fetchEvents();
    await SharedPrefs.saveEvents(eventList);
    update();
  }

  void fetchEventsFromSharedPrefs() async {
    eventList.value = await SharedPrefs.getEvents();
    print('Events from shared prefs: ${eventList.length}');
    update();
  }



  Future<Map<String, dynamic>> createEvent(EventModel event) async {
    try{
      eventList.add(await EventRepository().createEvent(event));
      update();
      return {'status': 'ok', 'message': 'Event created successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateEvent(id, name, description, date, location, club) async {

    try{
      eventList.value = await EventRepository().updateEvent(id, name, description, date, location, club);
      update();
      return {'status': 'ok', 'message': 'Event Updated successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteEvent(id) async {
    try{
      eventList.value = await EventRepository().deleteEvent(id);
      update();
      return {'status': 'ok', 'message': 'Event Deleted successfully'};
    } catch(e) {
      print(e);
      return {'status': 'error', 'message': e.toString()};
    }
  }

}
