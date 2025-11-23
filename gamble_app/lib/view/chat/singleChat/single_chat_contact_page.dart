import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:logger/logger.dart';
import 'package:easy_refresh/easy_refresh.dart' as refresh;

class Contacts extends HookConsumerWidget {
  final ValueNotifier<int> userId;
  final ValueNotifier<List> rooms;
  final void Function() init;
  const Contacts(
      {super.key,
      required this.rooms,
      required this.userId,
      required this.init});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ValueNotifier<int> userId = useState(0);
    final size = MediaQuery.of(context).size;

    // void sortRoomByDateTime(List<dynamic> listToSort) {
    //   listToSort.sort((firstItem, secItem) {
    //     final fisrtTimeStamp =
    //         DateTime.parse(firstItem["latestMessageCreatedAt"]);
    //     final secTimeStamp = DateTime.parse(secItem["latestMessageCreatedAt"]);
    //     return secTimeStamp.compareTo(fisrtTimeStamp);
    //   });
    // }

    // Future<void> addingNewRoomToUserContact(Map latestMessageStream) async {
    //   List<Map<String, dynamic>> managedRoom = [];

    //   final newRooms = [];
    //   if (newRooms.isEmpty) return;

    //   // finding reciever name for all rooms and then adding it to list
    //   for (final room in newRooms) {
    //     Map reciever = {};

    //     if (room["isGroupChat"]) continue;
    //     for (final member in room["members"]) {
    //       if (member["userId"] != userId.value) {
    //         reciever = member["user"];
    //       }
    //     }
    //     managedRoom = [
    //       ...managedRoom,
    //       {
    //         "id": room["id"],
    //         "profile": reciever["profile"],
    //         "name": reciever["username"],
    //         "latestMessage": room["latestMessage"]["message"],
    //         "latestMessageCreatedAt": room["latestMessage"]["createdAt"],
    //         "sender": reciever["id"]
    //       }
    //     ];
    //   }
    //   sortRoomByDateTime(managedRoom);
    //   rooms.value = managedRoom;
    // }

    // Future<void> updatingLatestOfRoom(Map latestMessageOfRoom,
    //     void Function(void Function()) setState) async {
    //   //  Finding and removing room where this new message from
    //   List existedRooms = rooms.value;
    //   List findedRoom = existedRooms
    //       .where((room) => room["id"] == latestMessageOfRoom["roomId"])
    //       .toList();
    //   if (findedRoom.isEmpty) {
    //     await addingNewRoomToUserContact(latestMessageOfRoom);
    //     return;
    //   }
    //   final findedRoomValue = findedRoom[0] as Map;
    //   existedRooms.remove(findedRoomValue);

    //   // updating latest message of that room and pushing to
    //   findedRoomValue["latestMessage"] = latestMessageOfRoom["message"];
    //   findedRoomValue["latestMessageCreatedAt"] =
    //       latestMessageOfRoom["createdAt"];
    //   existedRooms.add(findedRoomValue);

    //   // Sorting the list and updating state;
    //   sortRoomByDateTime(existedRooms);
    //   setState(() {
    //     rooms.value = existedRooms;
    //   });
    // }

    Future<void> initChatContact() async {
      // userId.value = await userW.getUserData(UserData.id, context);
      // sortRoomByDateTime(rooms.value);
    }

    useEffect(() {
      // initSocket();
      initChatContact();
      return null;
    }, const []);

    refresh.EasyRefreshController refreshController =
        refresh.EasyRefreshController(
            controlFinishLoad: true, controlFinishRefresh: true);

    return StatefulBuilder(builder: (context, setState) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: refresh.EasyRefresh(
          controller: refreshController,
          onLoad: () {
            refreshController.finishLoad();
          },
          onRefresh: () {
            rooms.value = [];
            init();
            refreshController.finishRefresh();
            refreshController.resetFooter();
          },
          header: const refresh.ClassicHeader(
            backgroundColor: Color.fromARGB(255, 244, 245, 250),
          ),
          footer: const refresh.ClassicFooter(
              triggerOffset: 0.0, triggerWhenReach: false),
          child: rooms.value.isEmpty
              ? SingleChildScrollView(
                  child: SizedBox(
                    // color: Colors.pink,
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.16),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Image.asset('assets/empty.png'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Your chat box is empty.",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Start a new converstation by searching \nfor traders or create group chat",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.black45),
                        ),
                        SizedBox(height: size.height * 0.16),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      // ____________________ Contacts of Friends ____________________
                      // Replace lines 115-117 with:
                      Column(
                        children: rooms.value.map((room) {
                          // Logger().f(room);
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  context.pushNamed(RouteNames.chat, extra: 3);
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 2),
                                splashColor:
                                    const Color.fromARGB(255, 246, 242, 255),
                                hoverColor:
                                    const Color.fromARGB(255, 246, 242, 255),
                                focusColor:
                                    const Color.fromARGB(255, 246, 242, 255),
                                dense: false,
                                leading: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: CachedNetworkImage(
                                    width: 50,
                                    height: 50,
                                    imageUrl: " ",
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/profile.png",
                                      fit: BoxFit.cover,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: const Text(
                                  "Demo user",
                                  style: TextStyle(
                                      fontSize: 16.6,
                                      fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  longtext("this is your poker master", 20),
                                  style: const TextStyle(
                                      fontSize: 14.6,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "12:00pm",
                                      // dateTimeDisplayer(
                                      //   room["latestMessageCreatedAt"],
                                      //   true,
                                      // ),
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                thickness: 0.4,
                                height: 0,
                                endIndent: 35,
                                indent: 35,
                                color: Color.fromARGB(50, 0, 0, 0),
                              ),
                            ],
                          );
                        }).toList(),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.4),
                            child: Image.asset(
                              'assets/icons/customer-service.png',
                              scale: 2,
                              color: const Color.fromARGB(137, 49, 49, 49),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const Text(
                                "You can use customer care by  ",
                                style: TextStyle(
                                  color: Color.fromARGB(137, 49, 49, 49),
                                  fontSize: 12,
                                ),
                              ),
                              InkWell(
                                onTap: () => context.push("/contact/chat/1"),
                                child: const Text(
                                  "clicking here",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(237, 33, 149, 243),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 140,
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}
