import 'package:club_app/controllers/loading_controller.dart';
import 'package:club_app/models/feedback_model.dart';
import 'package:club_app/widgets/app_widgets/rating_bar.dart';
import 'package:club_app/widgets/dialogue_widgets/suggestion_dialogue.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/colors.dart';
import '../controllers/feedback_controller.dart';
import '../widgets/loading_widget.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({super.key, required this.feedbackForm});

  final FeedbackModel feedbackForm;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final pageController = PageController();
  final feedbackController = Get.put(FeedbackController());
  final loadingController = Get.put(LoadingController());

  var pageIndex = 0;
  List<int> sliderValues = [];
  List<String> ratingTexts = [];
  List<Color> ratingTextColors = [];

  @override
  void initState() {
    super.initState();
    sliderValues = List.filled(widget.feedbackForm.questions.length, 0);
    ratingTexts =
        List.filled(widget.feedbackForm.questions.length, 'Pull the slider');
    ratingTextColors = List.filled(widget.feedbackForm.questions.length,
        Theme.of(Get.context!).primaryColor);
  }

  void uploadFeedback(context, suggestionText) async {
    loadingController.toggleLoading();
    final result = await feedbackController.uploadFeedback(
        widget.feedbackForm.id, sliderValues, suggestionText);
    loadingController.toggleLoading();
    if (result['status'] == 'error') {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.red);
    } else {
      CustomSnackBar.show(context,
          message: result['message'], color: Colors.green);
    }
    Navigator.of(context).pop();
  }

  void changeRating(int index, int value) {
    setState(() {
      sliderValues[index] = value;
      switch (value.toInt()) {
        case 0:
          ratingTexts[index] = 'Pull the slider';
          ratingTextColors[index] = Theme.of(Get.context!).primaryColor;
          break;
        case 1:
          ratingTexts[index] = '😭';
          ratingTextColors[index] = Colors.red;
          break;
        case 2:
          ratingTexts[index] = '🙁';
          ratingTextColors[index] = Colors.deepOrangeAccent;
          break;
        case 3:
          ratingTexts[index] = '🙂';
          ratingTextColors[index] = Colors.orange;
          break;
        case 4:
          ratingTexts[index] = '😀';
          ratingTextColors[index] = Colors.amber;
          break;
        case 5:
          ratingTexts[index] = '😁';
          ratingTextColors[index] = Colors.green;
          break;
        default:
          ratingTexts[index] = 'Pull the slider';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              title: const Text('Feedback'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonWidget(
                    onPressed: () {
                      if (sliderValues.any((value) => value == 0)) {
                        CustomSnackBar.show(context,
                            message: 'Please rate all questions',
                            color: Colors.red);
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (dialogueContext) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SuggestionDialogue(
                              onSubmit: (suggestionText) {
                                uploadFeedback(context, suggestionText);
                              },
                            ),
                          );
                        },
                      );
                    },
                    buttonText: 'Submit',
                    isNegative: false,
                    height: 36,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentColors.oppositeColor.withOpacity(0.1),
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: PageView.builder(
                            onPageChanged: (index) {
                              setState(() {
                                pageIndex = index;
                              });
                            },
                            controller: pageController,
                            itemCount: widget.feedbackForm.questions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Question ${pageIndex + 1}',
                                                style: TextStyle(
                                                    color: currentColors
                                                        .oppositeColor
                                                        .withOpacity(0.8),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Divider(
                                          color: currentColors.oppositeColor
                                              .withOpacity(0.5),
                                          height: 0,
                                          thickness: 0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 12, 16, 0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                widget.feedbackForm
                                                    .questions[index].question,
                                                style: TextStyle(
                                                    color: currentColors
                                                        .oppositeColor
                                                        .withOpacity(0.8),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(ratingTexts[index],
                                            style: TextStyle(
                                                color: ratingTextColors[index],
                                                fontSize: 40,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 30),
                                        RatingBar(
                                          onRatingChanged: (value) {
                                            changeRating(index, value.toInt());
                                          },
                                          initialRating:
                                              sliderValues[index].toDouble(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.feedbackForm.questions
                              .asMap()
                              .map((index, question) => MapEntry(
                              index,
                              InkWell(
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onTap: () {
                                  pageController.animateToPage(index,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                  setState(() {
                                    pageIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: pageIndex == index
                                          ? Theme.of(context).primaryColor
                                          : currentColors.oppositeColor
                                          .withOpacity(0.1),
                                    ),
                                    height: 8,
                                    width: 8,
                                  ),
                                ),
                              )))
                              .values
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: ButtonWidget(
                                onPressed: () {
                                  if (pageIndex < widget.feedbackForm.questions.length - 1) {
                                    pageController.animateToPage(pageIndex + 1,
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    setState(() {
                                      pageIndex = pageIndex + 1;
                                    });
                                  }
                                },
                                buttonText: 'Next',
                                isNegative: false)),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Obx(() {
          return Container(
            child: loadingController.isLoading.value ? LoadingWidget() : null,
          );
        }),
      ],
    );
  }
}
