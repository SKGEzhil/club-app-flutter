import 'package:club_app/models/event_model.dart';
import 'package:club_app/utils/repositories/event_repository.dart';
import 'package:club_app/utils/server_utils.dart';
import 'package:get/get.dart';

class EventController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  var eventList = <EventModel>[
    EventModel(
        name: 'New Year Party 2024',
        description: 'Description 1',
        date: 'Jun 14',
        bannerUrl: 'Banner Url 1',
        location: 'Hyderabad',
        clubName: 'Club 1',
        clubImageUrl: 'https://via.placeholder.com/50x50',
        clubId: '1'),
    EventModel(
        name: 'Event 2',
        description: 'Description 2',
        date: 'Date 2',
        bannerUrl: 'Banner Url 2',
        location: 'Location 2',
        clubName: 'Club 2',
        clubImageUrl: 'https://via.placeholder.com/50x50',
        clubId: '1'),
    EventModel(
        name: 'Event 3',
        description: 'Description 3',
        date: 'Date 3',
        bannerUrl: 'Banner Url 3',
        location: 'Location 3',
        clubName: 'Club 3',
        clubImageUrl: 'https://via.placeholder.com/50x50',
        clubId: '1'),
  ].obs;

  Future<void> fetchEvents() async {
    eventList.value = await EventRepository().fetchEvents();
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

}
