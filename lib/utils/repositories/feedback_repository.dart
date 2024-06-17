import 'package:club_app/models/feedback_model.dart';
import 'package:club_app/utils/network_services/feedback_service.dart';
import 'package:get/get.dart';

import '../../controllers/network_controller.dart';

class FeedbackRepository {
  static bool isInternetConnectionAvailable() {
    // Check internet connection
    final networkController = Get.find<NetworkController>();
    return networkController.isOnline.value;
  }

  Future<List<FeedbackModel>> fetchFeedbackForms() async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
          await FeedbackService().fetchFeedbackForms();
      final feedbackForms = (data['data'])['getFeedbacks'];
      final feedbackFormList = feedbackForms
          .map<FeedbackModel>((feedback) => FeedbackModel.fromJson(feedback))
          .toList();
      return feedbackFormList;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> uploadFeedback(id, ratingList) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
      await FeedbackService().uploadFeedback(id, ratingList);
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<FeedbackModel>> createFeedbackForm(eventId, clubId, List<String> questionList) async {
    if (!isInternetConnectionAvailable()) {
      return Future.error('No internet connection');
    }
    try {
      final Map<String, dynamic> data =
      await FeedbackService().createFeedbackForm(eventId, clubId, questionList);
      return fetchFeedbackForms();
    } catch (e) {
      return Future.error(e);
    }
  }

}
