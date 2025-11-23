// // ignore_for_file: no_leading_underscores_for_local_identifiers, depend_on_referenced_packages, prefer_const_declarations, unused_local_variable

// import 'dart:async';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
// import 'package:trading_trads/components/chat/chatbox.dart';
// import 'package:trading_trads/services/api.dart';
// import 'package:trading_trads/states/chats/groupstate.dart';
// import 'package:trading_trads/states/chats/liveSocketChat.dart';
// // import 'package:trading_trads/states/userstate.dart';
// import 'package:trading_trads/states/userstate.dart';
// import 'package:trading_trads/utils/const.dart';
// import 'package:trading_trads/utils/utilsmethod.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;

// class GroupChatPage extends HookConsumerWidget {
//   final int roomId;

//   const GroupChatPage({super.key, required this.roomId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ValueNotifier<Duration> duration = useState(const Duration());
//     ValueNotifier<Duration> position = useState(const Duration());
//     ValueNotifier<bool> isPlaying = useState(true);
//     ValueNotifier<bool> isPause = useState(false);
//     ValueNotifier<String> profilephoto = useState<String>("");
//     ValueNotifier<String> name = useState<String>("");
//     ValueNotifier<String> username = useState<String>("");
//     ValueNotifier<bool> isLoading = useState<bool>(false);
//     ValueNotifier<bool> overlay = useState<bool>(false);
//     ValueNotifier<int> currentuserid = useState<int>(0);
//     ValueNotifier<int?> lastSenderId = useState(0);
//     ValueNotifier<io.Socket?> chatSocket = useState<io.Socket?>(null);
//     ValueNotifier<List<dynamic>> roommessages = useState<List<dynamic>>([]);
//     ValueNotifier<int> userId = useState(0);
//     ValueNotifier<bool> isMemberOfGroup = useState(true);

//     final prevMessage = useRef({});
//     final userStateW = ref.watch(userState);
//     final groupChatW = ref.watch(groupChatState);
//     final liveChatScoket = ref.watch(liveSocketChatState);
//     final width = MediaQuery.of(context).size.width;
//     final size = MediaQuery.of(context).size;
//     final keyBoardPadding = MediaQuery.of(context).padding.bottom;

//     ScrollController scrollController = useScrollController();
//     TextEditingController messageController = useTextEditingController();
//     MediaQueryData mediaQuery = MediaQuery.of(context);
//     ValueNotifier<bool> isKeyboardVisible = useState(false);
//     List<ImageProvider> listOfImages = [];
//     bool isSender = false;
//     bool spaceAfterSend = false;
//     isKeyboardVisible.value = mediaQuery.viewInsets.bottom > 0;

//     void scrollToEnd() {
//       scrollController.animateTo(
//         scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }

//     OverlayEntry? _overlayEntry;
//     OverlayState overlayState = OverlayState();
//     void _showOverlay(BuildContext context) {
//       overlayState = Overlay.of(context);
//       _overlayEntry = OverlayEntry(
//           builder: (context) => Positioned(
//                 bottom: isKeyboardVisible.value
//                     ? mediaQuery.size.height -
//                         mediaQuery.viewInsets.bottom -
//                         250
//                     : 80,
//                 right: 10,
//                 left: 10,
//                 child: Material(
//                   child: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     width: size.width,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10.0),
//                       border: Border.all(
//                           color: Colors.grey.withOpacity(0.2), width: 1),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 0.5,
//                           blurRadius: 1,
//                           offset: const Offset(0, -3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         ListTile(
//                           onTap: () {
//                             _overlayEntry!.remove();
//                             overlay.value = false;
//                           },
//                           leading: const Icon(Icons.photo),
//                           title: const Text('Media'),
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.bubble_chart),
//                           title: const Text('Create Suggestion'),
//                           onTap: () {
//                             context
//                                 .push('/contact/chat/$roomId/suggest/$roomId');
//                             _overlayEntry!.remove();
//                             overlay.value = false;
//                           },
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.location_on),
//                           title: const Text('Location'),
//                           onTap: () {
//                             _overlayEntry!.remove();
//                             overlay.value = false;
//                           },
//                         ),
//                         ListTile(
//                           leading: const Icon(Icons.insert_drive_file),
//                           title: const Text('Document'),
//                           onTap: () {
//                             _overlayEntry!.remove();
//                             overlay.value = false;
//                           },
//                         ),
//                         const Divider(
//                           thickness: 0.3,
//                           height: 5,
//                           color: Color.fromARGB(72, 0, 0, 0),
//                         ),
//                         ListTile(
//                           leading: const Icon(
//                             Icons.close,
//                           ),
//                           title: const Text('Close'),
//                           onTap: () {
//                             _overlayEntry!.remove();
//                             overlay.value = false;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ));
//       overlayState.insert(_overlayEntry!);
//     }

//     Future<void> sendmessage() async {
//       try {
//         if (messageController.text.isEmpty || messageController.text == "") {
//           return;
//         }
//         var messageSendRequestParam = {
//           "senderId": currentuserid.value,
//           "roomId": roomId,
//           "message": messageController.text,
//           "messageType": "MESSAGE"
//         };
//         // Logger().f("sending params : $messageSendRequestParam");
//         chatSocket.value!.emit("testing", messageSendRequestParam);
//         messageController.text = "";
//       } catch (erro) {
//         // Logger().e("Error at sending message: $erro");
//       }
//     }

//     // Future<void> sendmessage() async {
//     //   if (messageController.text == "") return;
//     //   var req = {
//     //     "senderId": currentuserid.value,
//     //     "receiverId": 8,
//     //     "messageType": "MESSAGE",
//     //     "message": messageController.text,
//     //   };
//     //   if (roomId != 0) req["roomId"] = roomId;
//     //   chatSocket.value!.emit(
//     //       "isUserJoined", {"userId": currentuserid.value, "roomId": roomId});
//     //   chatSocket.value!.emit(
//     //       "typingStopped", {"roomId": roomId, "userId": currentuserid.value});
//     //   chatSocket.value!.emit("messageToRoom", req);
//     //   Logger().i("step 6 => Sending message to socket");
//     //   messageController.text = "";
//     //   scrollToEnd();
//     // }

//     Future<void> init() async {
//       isLoading.value = true;
//       currentuserid.value = await userStateW.getUserData(UserData.id, context);
//       await groupChatW.findGroupByGroupId(context, roomId);
//       isMemberOfGroup.value = await groupChatW.isUserMemberOfRoom(
//           context, currentuserid.value, roomId);

//       final messagedata = await apiCall(
//         query:
//             "query getChatHistory(\$roomid:Int!){getChatHistory (id:\$roomid){ senderId,message, imageurl, type,createdAt,sender {username,ph_number,profile,}}}  ",
//         variables: {"roomid": roomId},
//         headers: {"content-type": "*/*"},
//       );

//       if (messagedata.status) {
//         for (int i = 0; i < messagedata.data["getChatHistory"].length; i++) {
//           roommessages.value = [
//             ...roommessages.value,
//             {
//               "id": messagedata.data["getChatHistory"][i]["senderId"],
//               "message": messagedata.data["getChatHistory"][i]["message"],
//               "type": messagedata.data["getChatHistory"][i]["type"],
//               "senderName": messagedata.data["getChatHistory"][i]["sender"]
//                   ["username"],
//               "ph_number": messagedata.data["getChatHistory"][i]["sender"]
//                   ["ph_number"],
//               "profile_pic": messagedata.data["getChatHistory"][i]["sender"]
//                   ["profile"],
//               "imageurl": messagedata.data["getChatHistory"][i]["imageurl"],
//               "createdAt": messagedata.data["getChatHistory"][i]["createdAt"]
//             }
//           ];
//         }
//       } else {
//         Logger().e(messagedata.message);
//       }

//       chatSocket.value!.emit("joinRoom", {"roomId": roomId});
//       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//         scrollToEnd();
//       });
//       isLoading.value = false;
//     }

//     Future<void> sendMedia(List<XFile> medias) async {
//       for (final media in medias) {
//         // File? mediaFile = await media.file;
//         // if (mediaFile == null) return;
//         final uploadResponse = await uploadFileAtS3(
//             File(media.path), currentuserid.value.toString());

//         if (!uploadResponse.status) return;
//         Logger().i(uploadResponse.data);
//         var req = {
//           "senderId": currentuserid.value,
//           "messageType": "IMAGE",
//           "imageurl": uploadResponse.data["Location"],
//           "roomId": roomId
//         };
//         Logger().i("sending message params $req");
//         chatSocket.value!.emit("shareMediaToRoom", req);
//       }
//     }

//     Future<void> initSocket() async {
//       chatSocket.value = io.io(
//           websocketUrl,
//           io.OptionBuilder()
//               .setTransports(['websocket'])
//               .setQuery({
//                 'deviceId': "123",
//               })
//               .disableAutoConnect()
//               .build());
//       // liveChatScoket.chatSocket = chatSocket.value;

//       if (chatSocket.value == null) return;
//       chatSocket.value!.connect();

//       chatSocket.value!.onConnect((message) {
//         Logger().f("Step 1   -> Socket is connected");
//       });

//       chatSocket.value!.onError((message) {
//         Logger().e("Step 1 fail: $message");
//       });

//       chatSocket.value!.onDisconnect((message) {
//         Logger().e("Socket disconnected");
//       });

//       chatSocket.value!.on("messageToRoom", (streamMessage) {
//         Logger().f("live message  -> $streamMessage");
//       });

//       chatSocket.value!.on("testingListen", (streamMessage) {
//         // Logger().f("live message  -> $streamMessage");
//         scrollToEnd();
//         List listOfMessage = streamMessage as List;
//         listOfMessage = listOfMessage.reversed.toList();
//         roommessages.value = [...roommessages.value, ...listOfMessage];
//         // Logger().f(streamMessage);
//       });

//       chatSocket.value!.on("roomInfoMessage", (message) {
//         Logger().i("info message listening -> $message");
//         roommessages.value = [...roommessages.value, message];
//       });

//       Logger().f("ending at init socket ");
//     }

//     useEffect(() {
//       initSocket();
//       init();
//       return () {
//         chatSocket.value!.disconnect();
//       };
//     }, const []);

//     Logger().d(roommessages.value);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),

//       // __________ Top Info Bar ___________
//       appBar: AppBar(
//         elevation: 0.5,
//         backgroundColor: const Color.fromARGB(255, 1, 121, 220),
//         automaticallyImplyLeading: false,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: InkWell(
//             onTap: () => context.pop(),
//             focusColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             splashColor: Colors.transparent,
//             hoverColor: Colors.transparent,
//             child: const Icon(
//               Icons.arrow_back_sharp,
//               weight: 1,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         leadingWidth: 50,
//         title: InkWell(
//           onTap: () {
//             context.push("/contact/groupChat/$roomId/groupDetails/$roomId");
//           },
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: SizedBox(
//                   width: 35,
//                   height: 35,
//                   child: CachedNetworkImage(
//                     imageUrl: groupChatW.currentGroup["roomLogo"] ?? "",
//                     progressIndicatorBuilder:
//                         (context, url, downloadProgress) =>
//                             CircularProgressIndicator(
//                                 value: downloadProgress.progress),
//                     errorWidget: (context, url, error) => Image.asset(
//                       "assets/images/user.png",
//                       fit: BoxFit.cover,
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 12,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     // longtext("Name of reciever", 16),
//                     longtext(groupChatW.currentGroup["roomName"] ?? "", 19),
//                     // groupChatW.currentGroup["roomName"],
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       letterSpacing: -0.3,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 2,
//                   ),
//                   Text(
//                     longtext("last seen recently", 18),
//                     style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           const SizedBox(width: 8),
//           PopupMenuButton<String>(
//             color: Colors.white,
//             shadowColor: Colors.white,
//             iconColor: Colors.white70,
//             icon: const Icon(Icons.more_vert_rounded),
//             elevation: 1,
//             tooltip: "More option",
//             popUpAnimationStyle: AnimationStyle(
//                 curve: Curves.easeInToLinear, duration: Durations.long1),
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               PopupMenuItem<String>(
//                 onTap: () => context.push('/contact/blocked'),
//                 value: 'Blocked User',
//                 child: const Text('Blocked User'),
//               ),
//             ],
//           ),
//           const SizedBox(width: 7)
//         ],
//       ),

//       // __________ bottom message sending field ___________
//       bottomSheet: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
//         margin: const EdgeInsets.only(bottom: 3),
//         height: 50,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 1,
//               blurRadius: 7,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: !isMemberOfGroup.value
//             ? joinButton(context, roomId, [currentuserid.value], groupChatW,
//                 isMemberOfGroup)
//             : inputMessageField(() async {
//                 final result = await ImagePicker().pickMultiImage();
//                 sendMedia(result);
//               },
//                 overlay, _showOverlay, context, messageController, sendmessage),
//       ),

//       // ______________ Chats _______________
//       body: Container(
//         width: size.width,
//         height: size.height,
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: AssetImage("assets/images/chat page bg.jpeg"))),
//         child: isLoading.value
//             ? const SizedBox(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Expanded(
//                     child: ListView.builder(
//                       controller: scrollController,
//                       itemCount: roommessages.value.length,
//                       itemBuilder: (context, index) {
//                         DateTime createdAt = dateFormater(
//                             roommessages.value[index]["createdAt"]);
//                         String formattedTime =
//                             DateFormat('h:mm a').format(createdAt);
//                         bool showSenderInfo = prevMessage.value["id"] !=
//                                 roommessages.value[index]["id"] ||
//                             prevMessage.value["type"] == "INFO";
//                         prevMessage.value = roommessages.value[index];

//                         if (roommessages.value[index]["type"] == "INFO") {
//                           return InfoChatbox(
//                             message: roommessages.value[index]["message"],
//                             senderName: roommessages.value[index]["senderName"],
//                           );
//                         } else if (roommessages.value[index]["type"] ==
//                             "IMAGE") {
//                           return UserGroupMediaChatbox(
//                               time: formattedTime,
//                               messageType: roommessages.value[index]["type"],
//                               showSenderInfo: showSenderInfo,
//                               imageUrl: roommessages.value[index]["imageurl"],
//                               listOfImages: listOfImages,
//                               senderName: roommessages.value[index]
//                                   ["senderName"],
//                               phNumber: roommessages.value[index]["ph_number"],
//                               profilePic: roommessages.value[index]
//                                   ["profile_pic"],
//                               isCurrentUser: currentuserid.value ==
//                                   roommessages.value[index]["id"]);
//                         } else {
//                           return GroupChatbox(
//                             time: formattedTime,
//                             message: roommessages.value[index]["message"],
//                             senderName: roommessages.value[index]["senderName"],
//                             phNumber: roommessages.value[index]["ph_number"],
//                             profilePic: roommessages.value[index]
//                                 ["profile_pic"],
//                             messageType: roommessages.value[index]["type"],
//                             showSenderInfo: showSenderInfo,
//                             isCurrentUser: currentuserid.value ==
//                                 roommessages.value[index]["id"],
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 59)
//                 ],
//               ),
//       ),
//     );
//   }

//   Row inputMessageField(
//       void Function() onTap,
//       ValueNotifier<bool> overlay,
//       void Function(BuildContext context) _showOverlay,
//       BuildContext context,
//       TextEditingController messageController,
//       Future<void> Function() sendmessage) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         const SizedBox(width: 5),
//         InkWell(
//           onTap: onTap,
//           child: const Icon(
//             Icons.add,
//             weight: 1,
//           ),
//         ),
//         Expanded(
//           child: TextFormField(
//             controller: messageController,
//             onEditingComplete: () => sendmessage(),
//             cursorWidth: 0.9,
//             decoration: InputDecoration(
//               hintText: "Type a message",
//               hintStyle: const TextStyle(
//                   fontWeight: FontWeight.w500, color: Colors.grey),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//             ),
//             onFieldSubmitted: (value) {},
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.send, color: Colors.blue),
//           onPressed: () {
//             sendmessage();
//           },
//         ),
//       ],
//     );
//   }

//   InkWell joinButton(BuildContext context, int groupId, List<int> userId,
//       GroupChatProvier userW, ValueNotifier<bool> isMemberOfGroup) {
//     return InkWell(
//       focusColor: Colors.white,
//       highlightColor: Colors.white,
//       splashColor: Colors.white,
//       hoverColor: Colors.white,
//       onTap: () async {
//         final isAdded = await userW.addMembersToGroup(context, groupId, userId);
//         isMemberOfGroup.value = isAdded;
//       },
//       child: const Row(
//         children: [
//           Spacer(),
//           Text(
//             "JOIN GROUP",
//             style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
//           ),
//           Spacer()
//         ],
//       ),
//     );
//   }
// }
