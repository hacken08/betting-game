import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import 'groupChat/group_chat_contact_page.dart';
import 'singleChat/single_chat_contact_page.dart';
// import 'package:animated_icon_button/animated_icon_button.dart';

// ignore: camel_case_types
class ContactListPage extends HookConsumerWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> isLoading = useState<bool>(true);
    ValueNotifier<int> userId = useState<int>(0);
    ValueNotifier<List> rooms = useState<List>([1, 2, 3, 4]);
    ValueNotifier<List> groupRooms = useState<List>([1, 2, 3, 4]);
    ValueNotifier<bool> isMultiSelectOn = useState(false);
    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: ExpandableFab.location,
        bottomSheet: Container(
          height: 0.5,
          width: size.width,
          color: const Color.fromARGB(124, 160, 160, 160),
        ),
        floatingActionButton: ExpandableFab(
          distance: 55,
          type: ExpandableFabType.up,
          // pos: ExpandableFabPos.right,
          childrenAnimation: ExpandableFabAnimation.none,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.white.withOpacity(0.8),
          ),
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            fabSize: ExpandableFabSize.regular,
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(245, 62, 167, 254),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: const Center(
              child: Icon(
                Icons.edit_sharp,
                // size: 17,
                color: Colors.white,
              ),
            ),
          ),
          closeButtonBuilder: RotateFloatingActionButtonBuilder(
            fabSize: ExpandableFabSize.small,
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(245, 62, 167, 254),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: const Center(
              child: Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          children: [
            // const SizedBox(width: 20),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1.5,
                            spreadRadius: 0.5,
                            offset: const Offset(0, 2))
                      ]),
                  child: Text(
                    "New chat",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey[600]),
                  ),
                ),
                FloatingActionButton.small(
                  heroTag: null,
                  onPressed: () {},
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 17,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1.5,
                            spreadRadius: 0.5,
                            offset: const Offset(0, 2))
                      ]),
                  child: Text(
                    "Create group",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey[600]),
                  ),
                ),
                FloatingActionButton.small(
                  heroTag: null,
                  onPressed: () {
                    String paramObject = jsonEncode({"createGroup": true});
                    context.push("/contact/multiSelect/$paramObject");
                  },
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 213, 192, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const Center(
                      child: Icon(
                    Icons.group_add,
                    size: 17,
                  )),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 1.5,
                            spreadRadius: 0.5,
                            offset: const Offset(0, 2))
                      ]),
                  child: Text(
                    "Search user",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey[600]),
                  ),
                ),
                FloatingActionButton.small(
                  heroTag: null,
                  onPressed: () => context.push("/home/searchuser"),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  child: const Center(
                      child: Icon(
                    Icons.search_outlined,
                    size: 21,
                  )),
                ),
              ],
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(onPressed: () {}),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 1, 121, 220),
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                    width: 60,
                    child: Icon(
                      Icons.menu,
                      size: 19,
                      color: Colors.white,
                    ),
                  ),
                  // const SizedBox(width: 5),
                  const TabBar(
                    dragStartBehavior: DragStartBehavior.down,
                    // controller: tabController,
                    dividerColor: Color.fromARGB(38, 0, 0, 0),
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.center,
                    isScrollable: false,
                    indicatorSize: TabBarIndicatorSize.tab,
                    overlayColor: WidgetStatePropertyAll(Colors.white),
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                    labelStyle: TextStyle(
                        fontSize: 14.5,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w500),
                    unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(189, 255, 255, 255)),
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                        text: 'CHATS',
                      ),
                      Tab(
                        text: 'GROUPS',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    width: 50,
                    child: InkWell(
                      onTap: () => context.push("/home/searchuser"),
                      child: Image.asset(
                        "assets/icons/search.png",
                        color: Colors.white,
                        scale: 3.3,
                      ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // PopupMenuButton<String>(
                  //   color: Colors.white,
                  //   shadowColor: Colors.white,
                  //   elevation: 1,
                  //   tooltip: "More option",
                  //   popUpAnimationStyle: AnimationStyle(
                  //       curve: Curves.easeInToLinear,
                  //       duration: Durations.long1),
                  //   itemBuilder: (BuildContext context) =>
                  //       <PopupMenuEntry<String>>[
                  //     PopupMenuItem<String>(
                  //       onTap: () => context.push('/contact/blocked'),
                  //       value: 'Blocked User',
                  //       child: const Text('Blocked User'),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(width: 7)
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                // controller: tabController,
                children: [
                  Contacts(
                    userId: userId,
                    rooms: rooms,
                    init: () {},
                  ),
                  Groups(
                    userId: userId,
                    groupRooms: groupRooms,
                    init: () {},
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
