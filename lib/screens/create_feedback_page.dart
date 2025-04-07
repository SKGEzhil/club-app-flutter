import 'package:club_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/feedback_controller.dart';
import '../controllers/loading_controller.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/loading_widget.dart';

class CreateFeedbackPage extends StatefulWidget {
  const CreateFeedbackPage(
      {super.key, required this.eventId, required this.clubId});

  final String eventId;
  final String clubId;

  @override
  State<CreateFeedbackPage> createState() => _CreateFeedbackPageState();
}

class _CreateFeedbackPageState extends State<CreateFeedbackPage> {
  List<Widget> questionList = [];
  List<TextEditingController> questionControllers = [];
  final feedbackController = Get.put(FeedbackController());
  final loadingController = Get.put(LoadingController());

  // Custom accent color - yellowish shade
  final Color accentColor = const Color(0xFFF5C518);

  Future<void> submitForm(context) async {
    loadingController.toggleLoading();
    if(questionControllers.any((element) => element.text.isEmpty)){
      CustomSnackBar.show(context,
          message: 'Please fill all the fields', color: Colors.red);
      loadingController.toggleLoading();
      return;
    }
    final result = await feedbackController.createFeedbackForm(widget.eventId,
        widget.clubId, questionControllers.map((e) => e.text).toList());
    loadingController.toggleLoading();
    result['status'] == 'error'
        ? CustomSnackBar.show(context,
        message: result['message'], color: Colors.red)
        : CustomSnackBar.show(context,
        message: result['message'], color: Colors.green);
    Navigator.of(context).pop();
  }

  Widget _buildQuestionField(TextEditingController controller, int index) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Question ${index + 1}',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  onTap: () {
                    setState(() {
                      questionList.removeAt(index);
                      questionControllers[index].dispose();
                      questionControllers.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextFormField(
              maxLines: 1,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter your question here...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Create Feedback',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ButtonWidget(
                  onPressed: () => submitForm(context),
                  buttonText: 'Submit',
                  isNegative: false,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Questions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ButtonWidget(
                      onPressed: () {
                        setState(() {
                          var questionController = TextEditingController();
                          questionControllers.add(questionController);
                          questionList.add(_buildQuestionField(questionController, questionList.length));
                        });
                      },
                      preceedingIcon: Icons.add,
                      buttonText: 'Add Question',
                      isNegative: false,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: questionList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: questionList[index],
                    );
                  },
                ),
              ),
              if (questionList.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.feedback_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No questions added yet',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click the "Add Question" button to start',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Obx(() {
          return Container(
            child: loadingController.isLoading.value ? LoadingWidget() : null,
          );
        }),
      ],
    );
  }
}
