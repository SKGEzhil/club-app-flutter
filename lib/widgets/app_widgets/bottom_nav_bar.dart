import 'package:club_app/screens/create_feedback_page.dart';
import 'package:club_app/widgets/button_widget.dart';
import 'package:club_app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/colors.dart';
import '../../controllers/bottom_nav_controller.dart';
import '../../controllers/clubs_controller.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../screens/create_event_page.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with SingleTickerProviderStateMixin {
  final bottomNavController = Get.put(BottomNavController());
  final eventController = Get.put(EventController());
  final clubsController = Get.put(ClubsController());
  final profileController = Get.put(ProfileController());

  var selectedEvent = ''.obs;
  var selectedClub = ''.obs;
  bool _isClubDropdownExpanded = false;
  bool _isEventDropdownExpanded = false;

  // Custom accent color - yellowish shade
  final Color accentColor = const Color(0xFFF5C518);

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  Widget _buildExpandableDropdown({
    required String title,
    required String hintText,
    required bool isExpanded,
    required List<dynamic> items,
    required String? selectedValue,
    required Function(dynamic) onSelect,
    required String Function(dynamic) getLabel,
    required String Function(dynamic) getValue,
    String? Function(dynamic)? getImageUrl,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isExpanded 
                ? accentColor 
                : theme.colorScheme.outline.withOpacity(0.2),
            ),
            boxShadow: isExpanded
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header - always visible
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    if (title == 'Select a Club') {
                      _isClubDropdownExpanded = !_isClubDropdownExpanded;
                      if (_isClubDropdownExpanded) _isEventDropdownExpanded = false;
                    } else {
                      _isEventDropdownExpanded = !_isEventDropdownExpanded;
                      if (_isEventDropdownExpanded) _isClubDropdownExpanded = false;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        title == 'Select a Club' ? Icons.group : Icons.event,
                        color: accentColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: selectedValue != null && selectedValue.isNotEmpty
                            ? Builder(
                                builder: (context) {
                                  dynamic selectedItem;
                                  try {
                                    selectedItem = items.firstWhere(
                                      (item) => getValue(item) == selectedValue
                                    );
                                  } catch (e) {
                                    return Text(
                                      hintText,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    );
                                  }
                                  
                                  return Row(
                                    children: [
                                      if (getImageUrl != null)
                                        ...[
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundImage: NetworkImage(
                                              getImageUrl(selectedItem) ?? '',
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      Text(
                                        getLabel(selectedItem),
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ],
                                  );
                                }
                              )
                            : Text(
                                hintText,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: isExpanded
                              ? accentColor
                              : theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Expandable list
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  height: isExpanded ? null : 0,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: isExpanded
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(height: 1, color: accentColor.withOpacity(0.2)),
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height * 0.3,
                              ),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final isSelected = selectedValue == getValue(item);
                                  
                                  return InkWell(
                                    onTap: () {
                                      onSelect(item);
                                      setState(() {
                                        if (title == 'Select a Club') {
                                          _isClubDropdownExpanded = false;
                                        } else {
                                          _isEventDropdownExpanded = false;
                                        }
                                      });
                                    },
                                    child: Container(
                                      color: isSelected 
                                          ? accentColor.withOpacity(0.1)
                                          : null,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          if (getImageUrl != null)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 16),
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(getImageUrl(item) ?? ''),
                                              ),
                                            ),
                                          Expanded(
                                            child: Text(
                                              getLabel(item),
                                              style: theme.textTheme.titleMedium,
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle,
                                              color: accentColor,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is light or dark
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    // Choose the color based on the theme
    ThemeColors currentColors = isDarkTheme ? darkColors : lightColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Obx(() {
                return Container(
                  child: bottomNavController.isSheetOpen.value
                      ? bottomNavController.isFeedbackSelectionVisible.value
                      ? Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromRGBO(18, 18, 18, 1.0)
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        border: Border.all(
                            width: 1,
                            color: accentColor)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Obx(() {
                            final isAdmin = profileController.currentUser.value.role == 'admin';
                            final clubs = isAdmin 
                                ? clubsController.clubList
                                : (profileController.currentUser.value.clubs ?? []) as List;
                            
                            return _buildExpandableDropdown(
                              title: 'Select a Club',
                              hintText: 'Choose a club',
                              isExpanded: _isClubDropdownExpanded,
                              items: clubs,
                              selectedValue: selectedClub.value,
                              onSelect: (club) {
                                selectedClub.value = club.id;
                                selectedEvent.value = ''; // Reset event selection
                              },
                              getLabel: (club) => club.name,
                              getValue: (club) => club.id,
                              getImageUrl: (club) => club.imageUrl,
                            );
                          }),
                          SizedBox(height: 24),
                          Obx(() {
                            final events = selectedClub.value == ''
                                ? []
                                : eventController.eventList
                                    .where((event) => event.clubId == selectedClub.value)
                                    .toList();
                            
                            return _buildExpandableDropdown(
                              title: 'Select an Event',
                              hintText: selectedClub.value == '' 
                                  ? 'Select a club first'
                                  : 'Choose an event',
                              isExpanded: _isEventDropdownExpanded,
                              items: events,
                              selectedValue: selectedEvent.value,
                              onSelect: (event) {
                                selectedEvent.value = event.id;
                              },
                              getLabel: (event) => event.name,
                              getValue: (event) => event.id,
                              getImageUrl: (event) => event.bannerUrl,
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: ButtonWidget(
                                  onPressed: () =>
                                  {
                                    selectedClub.value == '' ||
                                        selectedEvent.value == ''
                                        ? CustomSnackBar.show(context,
                                        message:
                                        'Please fill all the required fields',
                                        color: Colors.red)
                                        : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CreateFeedbackPage(
                                              clubId: selectedClub
                                                  .value,
                                              eventId: selectedEvent
                                                  .value,
                                            ),
                                      ),
                                    )
                                  },
                                  buttonText: 'Create Feedback Form',
                                  isNegative: false),
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Color.fromRGBO(18, 18, 18, 1.0)
                            : Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        border: Border.all(
                            width: 1,
                            color: accentColor)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: currentColors.oppositeColor
                                  .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Create Event',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateEventPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text(
                            'Create Feedback Form',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            bottomNavController.isFeedbackSelectionVisible.value = true;
                            },
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  )
                      : SizedBox(
                    height: 40,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GetBuilder<BottomNavController>(builder: (logic) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 18, 8, 8),
                  child: Obx(() {
                    // Check if user is admin or has any clubs
                    bool showAddButton = profileController.currentUser.value.role == 'admin' ||
                        (profileController.currentUser.value.clubs != null && 
                         profileController.currentUser.value.clubs!.isNotEmpty);

                    return Row(
                      mainAxisAlignment: showAddButton ? MainAxisAlignment.spaceAround : MainAxisAlignment.spaceEvenly,
                      children: [
                        bottonNavItems(currentColors, Icons.home, 0),
                        bottonNavItems(currentColors, Icons.group, 1),
                        if (showAddButton)
                          InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onTap: () {
                              bottomNavController.isSheetOpen.value =
                              !bottomNavController.isSheetOpen.value;
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.add,
                                    size: 30, color: Colors.white),
                              ),
                            ),
                          ),
                        bottonNavItems(currentColors, Icons.feedback_outlined, 2),
                        bottonNavItems(currentColors, Icons.person, 3),
                      ],
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  InkWell bottonNavItems(ThemeColors currentColors, IconData icon, int index) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        bottomNavController.selectIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 30, color: Colors.black.withOpacity(0.7)),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: bottomNavController.selectedIndex.value == index
                    ? Colors.red
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          )
        ],
      ),
    );
  }
}
