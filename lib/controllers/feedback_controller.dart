import 'package:get/get.dart';

import '../models/feedback_model.dart';
import '../utils/repositories/feedback_repository.dart';

class FeedbackController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchFeedbackForms();
  }

  var feedbackList = <FeedbackModel>[].obs;

  Future<void> fetchFeedbackForms() async {
    try{
      final response = await FeedbackRepository().fetchFeedbackForms();
      feedbackList.value = response;
      update();
    } catch(e){
      print(e);
    }
  }


  Future<Map<String, dynamic>> uploadFeedback(id, ratingList) async {
    try{
      final result = await FeedbackRepository().uploadFeedback(id, ratingList);
      print(result);
      return {'status': 'ok', 'message': 'Feedback uploaded successfully'};
    } catch(e){
      print(e);
      return {'status': 'error', 'message': 'Failed to upload feedback'};
    }
  }

}