import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart' as refresh;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

// ============================== Groups Page ==============================
class Groups extends HookConsumerWidget {
  final ValueNotifier<int> userId;
  final ValueNotifier<List> groupRooms;
  final void Function() init;
  const Groups(
      {super.key,
      required this.userId,
      required this.groupRooms,
      required this.init});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger().f("rebuilt state ");

    final size = MediaQuery.of(context).size;

    refresh.EasyRefreshController refreshController =
        refresh.EasyRefreshController(
            controlFinishLoad: true, controlFinishRefresh: true);

    void sortRoomByDateTime(List<dynamic> listToSort) {
      listToSort.sort((firstItem, secItem) {
        final fisrtTimeStamp =
            DateTime.parse(firstItem["latestMessageCreatedAt"]);
        final secTimeStamp = DateTime.parse(secItem["latestMessageCreatedAt"]);
        return secTimeStamp.compareTo(fisrtTimeStamp);
      });
    }

    void addingNewGroupToUserContact(Map latestMessageStream,
        void Function(void Function()) setState) async {
      bool isMemberInRoom = false;

      List newRooms = [
        ...groupRooms.value,
        {
          "id": latestMessageStream["id"],
          "profile": latestMessageStream["profile"],
          "name": latestMessageStream["username"],
          "latestMessage": latestMessageStream["latestMessage"],
          "latestMessageCreatedAt":
              latestMessageStream["latestMessageCreatedAt"],
          "sender": latestMessageStream["id"],
          "roomName": latestMessageStream["roomName"],
          "roomLogo": latestMessageStream["roomLogo"],
          "isGroupChat": latestMessageStream["isGroupChat"],
        }
      ];
      sortRoomByDateTime(newRooms);
      setState(() => groupRooms.value = newRooms);

      //  Fetching members of room from where this
      // final newRoom = await groupRefW.findGroupByRoomId(
      //     context, latestMessageStream["id"]);
      // if (newRoom.isEmpty) return;

      // for (final room in newRoom) {
      //   Map recieversInfo = {};

      //   for (final member in room["members"]) {
      //     if (member["userId"] == userId.value) {
      //       recieversInfo = member["user"];
      //     }
      //   }
      //   List newRooms = [
      //     ...groupRooms.value,
      //     {
      //       "id": room["id"],
      //       "profile": recieversInfo["profile"],
      //       "name": recieversInfo["username"],
      //       "latestMessage": room["latestMessage"]["message"],
      //       "latestMessageCreatedAt": room["latestMessage"]["createdAt"],
      //       "sender": recieversInfo["id"],
      //       "roomName": room["roomName"],
      //       "roomLogo": room["roomLogo"],
      //       "isGroupChat": room["isGroupChat"],
      //     }
      //   ];
      //   groupRooms.value = newRooms;
      // }
    }

    void updatingLatestMessageOfGroup(
      Map messageStream,
      void Function(void Function()) setState,
    ) async {
      List existedRoom = groupRooms.value;

      // seaching the room from where this come and removing it
      List findedRooms = existedRoom
          .where((group) => group["id"] == messageStream["roomId"])
          .toList();
      if (findedRooms.isEmpty) return;
      final findedRoom = findedRooms[0];
      existedRoom.remove(findedRoom);
      // Logger().f("room finded and removed  -> $findedRoom");

      // Updating latest message of group to display
      findedRoom["latestMessage"] = messageStream["message"];
      findedRoom["latestMessageCreatedAt"] = messageStream["createdAt"];
      // Logger().f("latest message of room updated  -> $findedRoom");

      // Inserting updated room and changing state
      existedRoom.add(findedRoom);
      sortRoomByDateTime(existedRoom);

      setState(() {
        groupRooms.value = existedRoom;
        // Logger().f("state rebuild triggered");
        // Logger().d(groupRooms.value);
      });
    }

    void initGroupChat() {
      // Logger().f(groupRooms.value);
    }

    useEffect(() {
      initGroupChat();
      return null;
    }, const []);

    return StatefulBuilder(builder: (context, setState) {
      // liveSocketW.listentToEvents("newLatestMessage", (groupStream) {
      //   Map messageGroupStream = groupStream as Map;
      //   // Logger().i("new group info -  $messageGroupStream");
      //   updatingLatestMessageOfGroup(messageGroupStream, setState);
      // });
      // liveSocketW.listentToEvents("newRomJoined", (groupStream) {
      //   Map messageGroupStream = groupStream as Map;
      //   Logger().i("new group info -  $messageGroupStream");
      //   addingNewGroupToUserContact(messageGroupStream, setState);
      // });
      return Scaffold(
        backgroundColor: Colors.white,
        body: refresh.EasyRefresh(
          controller: refreshController,
          onLoad: () => refreshController.finishLoad(),
          onRefresh: () {
            init();
            refreshController.finishRefresh();
            refreshController.resetFooter();
          },
          header: const refresh.ClassicHeader(
            backgroundColor: Color.fromARGB(255, 244, 245, 250),
          ),
          footer: const refresh.ClassicFooter(
              triggerOffset: 0.0,
              triggerWhenReach: false,
              maxOverOffset: 0.0,
              infiniteOffset: 0),
          child: SizedBox(
            height: size.height,
            child: groupRooms.value.isEmpty
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
                            child: Image.asset('assets/images/empty.png'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ____________________ Contacts of Friends ____________________
                        // const Padding(
                        //   padding: EdgeInsets.only(left: 17.0, top: 18),
                        //   child: Text(
                        //     'List of Groups',
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w600,
                        //         fontSize: 12.5,
                        //         color: Colors.black45),
                        //   ),
                        // ),
                        for (int a = 0; a < groupRooms.value.length; a++) ...[
                          ListTile(
                              onTap: () {},
                              // onTap: () => context.push("/contact/chat/2"),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 6),
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
                                  width: 47,
                                  height: 47,
                                  imageUrl: " ",
                                  // imageUrl:
                                  //     "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
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
                              title: Text(
                                "no group name",
                                // "User name",
                                style: const TextStyle(
                                  fontSize: 15.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                  longtext(
                                    "Poker master: hi boii wassup wassup",
                                    20,
                                  ),
                                  // "Hi, how trade going?",
                                  style: const TextStyle(
                                      fontSize: 13.6,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500)),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "12:00pm",
                                    style: const TextStyle(
                                        fontSize: 9.5,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // Container(
                                  //   // padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                  //   constraints: const BoxConstraints(
                                  //       minHeight: 21, minWidth: 21),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.blue,
                                  //     borderRadius: BorderRadius.circular(100),
                                  //   ),
                                  //   child: const Center(
                                  //     widthFactor: 2,
                                  //     heightFactor: 0,
                                  //     child: Text(
                                  //       "2",
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              )),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
