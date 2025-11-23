// ignore_for_file: no_leading_underscores_for_local_identifiers, depend_on_referenced_packages, prefer_const_declarations, unused_local_variable, dead_code
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/chat/chatbox.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatPage extends HookConsumerWidget {
  final int reciver;

  const ChatPage({super.key, required this.reciver});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<Duration> duration = useState(const Duration());
    ValueNotifier<Duration> position = useState(const Duration());
    ValueNotifier<bool> isPlaying = useState(true);
    ValueNotifier<bool> isPause = useState(false);

    ValueNotifier<int> userId = useState<int>(0);
    ValueNotifier<String> profilephoto = useState<String>("");
    ValueNotifier<String> name = useState<String>("");
    ValueNotifier<String> username = useState<String>("");
    ValueNotifier<bool> isLoading = useState<bool>(false);
    ValueNotifier<bool> overlay = useState<bool>(false);
    ValueNotifier<int> currentuserid = useState<int>(0);
    ValueNotifier<int?> lastSenderId = useState(0);
    ValueNotifier<bool> isTyping = useState(false);
    ValueNotifier<int> roomid = useState<int>(0);
    ValueNotifier<bool> emojiShowing = useState(false);
    ValueNotifier<List<dynamic>> roommessages = useState<List<dynamic>>([]);
    ValueNotifier<List> mediaList = useState([]);
    ValueNotifier<Map> currentMessage = useState<Map>({});
    ValueNotifier<io.Socket?> chatSocket = useState<io.Socket?>(null);

    final width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final keyBoardPadding = MediaQuery.of(context).padding.bottom;

    ScrollController scrollController = useScrollController();
    TextEditingController messageController = useTextEditingController();
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ValueNotifier<bool> isKeyboardVisible = useState(false);
    isKeyboardVisible.value = mediaQuery.viewInsets.bottom > 0;
    List<ImageProvider> mediaImageOfTheGroup = [];
    bool isSender = false;
    bool spaceAfterSend = false;

    void scrollToEnd() {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    OverlayEntry? _overlayEntry;
    OverlayState overlayState = OverlayState();
    void _showOverlay(BuildContext context) {
      overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
                bottom: isKeyboardVisible.value
                    ? mediaQuery.size.height -
                        mediaQuery.viewInsets.bottom -
                        250
                    : 80,
                right: 10,
                left: 10,
                child: Material(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            _overlayEntry!.remove();
                            overlay.value = false;
                          },
                          leading: const Icon(Icons.photo),
                          title: const Text('Media'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.bubble_chart),
                          title: const Text('Create Suggestion'),
                          onTap: () {
                            context.push(
                                '/contact/chat/$reciver/suggest/${roomid.value}');
                            _overlayEntry!.remove();
                            overlay.value = false;
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text('Location'),
                          onTap: () {
                            _overlayEntry!.remove();
                            overlay.value = false;
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.insert_drive_file),
                          title: const Text('Document'),
                          onTap: () {
                            _overlayEntry!.remove();
                            overlay.value = false;
                          },
                        ),
                        const Divider(
                          thickness: 0.3,
                          height: 5,
                          color: Color.fromARGB(72, 0, 0, 0),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.close,
                          ),
                          title: const Text('Close'),
                          onTap: () {
                            _overlayEntry!.remove();
                            overlay.value = false;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ));
      overlayState.insert(_overlayEntry!);
    }

    Future<void> init() async {}

    Future<void> sendmessage() async {
      if (messageController.text == "") return;
      var req = {
        "senderId": currentuserid.value,
        "receiverId": userId.value,
        "messageType": "MESSAGE",
        "message": messageController.text,
      };
      if (roomid.value != 0) req["roomId"] = roomid.value;
      chatSocket.value!.emit(
          "isUserJoined", {"userId": userId.value, "roomId": roomid.value});
      chatSocket.value!.emit(
          "typingStopped", {"roomId": roomid.value, "userId": userId.value});
      chatSocket.value!.emit("messageToRoom", req);
      // Logger().i("step 6 => Sending message to socket");
      messageController.text = "";
      scrollToEnd();
    }

    Future<void> sendMedia(List<XFile> medias) async {
      for (final media in medias) {
        // File? mediaFile = await media.file;
        // if (mediaFile == null) return;
        // final uploadResponse = await uploadFileAtS3(
        //   File(media.path),
        //   currentuserid.value.toString(),
        // );

        // if (!uploadResponse.status) return;
        // // Logger().i(uploadResponse.data);
        // var req = {
        //   "senderId": currentuserid.value,
        //   "receiverId": userId.value,
        //   "messageType": "IMAGE",
        //   "imageurl": uploadResponse.data["Location"],
        // };
        // if (roomid.value != 0) req["roomId"] = roomid.value;
        // // Logger().i("sending message params $req");
        // chatSocket.value!.emit("shareMediaToRoom", req);
      }
    }

    Future<void> intisocket() async {
      // final androidInfo = await DeviceInfoPlugin().androidInfo;

      chatSocket.value = io.io(
          "websocketUrl",
          io.OptionBuilder()
              .setTransports(['websocket'])
              .setQuery({
                'deviceId': "123",
              })
              .disableAutoConnect()
              .build());

      if (!chatSocket.value!.connected) {
        chatSocket.value!.connect();
        Logger().d('connecting....');
      }
      // Logger().f("socket connected - ${chatSocket.value!.active}");

      chatSocket.value!.on("checkUserJoined", (message) {
        if (!message["isJoined"]) {
          chatSocket.value!.emit("joinRoom", roomid.value);
        }
      });

      chatSocket.value!.onConnect((message) {
        Logger().i("Socket is connected  $message");
      });

      chatSocket.value!.onDisconnect((_) {
        Logger().e('Socket disconnected');
      });

      chatSocket.value!.onError((error) {
        Logger().e('Socket error: $error');
      });

      // Logger().f(chatSocket.value!.flags);

      chatSocket.value!.on("newRoomMessage", (message) {
        message = message as List;
        message = message.reversed.toList();

        // Logger().d("message stream --> $message");

        for (final newMessage in message) {
          if (newMessage["type"] == "IMAGE") {
            mediaImageOfTheGroup.add(NetworkImage(newMessage["imageurl"]));
          }
        }
        roommessages.value = [...roommessages.value, ...message];
        // currentMessage.value = message;
        scrollToEnd();
      });

      // chatSocket.value!.on("newLatestMessage", (message) {
      //   Logger().f("latest message event listner  $message ");
      // });

      chatSocket.value!.on("roomInfoMessage", (message) {
        roommessages.value = [...roommessages.value, message];
      });
      chatSocket.value!.on("typingStatus", (message) {
        // Logger().i(message);
        if (message["userId"] != userId.value) {
          isTyping.value = message["isTyping"];
        }
        scrollToEnd();
      });

      if (roomid.value != 0) {
        chatSocket.value!.on("newRoomCreated", (roomId) {
          chatSocket.value!.emit("joinRoom", roomId);
          roomId.value = roomId;
        });
      }
    }

    useEffect(() {
      intisocket();
      init();
      return () {
        Logger().f("Leaving room emit");
        chatSocket.value!.emit("leaveRoom", {"roomId": roomid.value});
        chatSocket.value!.disconnect();
      };
    }, []);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      // __________ Top Info Bar ___________
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 1, 121, 220),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: InkWell(
            onTap: () => context.pop(),
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            child: const Icon(
              Icons.arrow_back_sharp,
              weight: 1,
              color: Colors.white,
            ),
          ),
        ),
        leadingWidth: 50,
        title: InkWell(
          onTap: () =>
              context.push("/contact/chat/$reciver/userInfo", extra: reciver),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CachedNetworkImage(
                    imageUrl: profilephoto.value,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/user.png",
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // longtext("Name of reciever", 16),
                    longtext("Demo user", 16),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  isTyping.value
                      ? Text(
                          longtext("Typing...", 18),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          longtext("last seen recently", 18),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            color: Colors.white,
            shadowColor: Colors.white,
            iconColor: Colors.white70,
            icon: const Icon(Icons.more_vert_rounded),
            elevation: 1,
            tooltip: "More option",
            popUpAnimationStyle: AnimationStyle(
                curve: Curves.easeInToLinear, duration: Durations.long1),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                onTap: () {
                  // context.push('/contact/blocked')
                  comingalert(context);
                },
                value: 'Blocked User',
                child: const Text('Blocked User'),
              ),
            ],
          ),
          const SizedBox(width: 7)
        ],
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 0),
        margin: const EdgeInsets.only(bottom: 0),
        height: emojiShowing.value ? 315 : 52,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 5),
                InkWell(
                  onTap: () async {
                    final result = await ImagePicker().pickMultiImage();
                    sendMedia(result);
                  },
                  child: const Icon(Icons.add, color: Colors.black87),
                ),
                // const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    onEditingComplete: () => sendmessage(),
                    onChanged: (val) {
                      // Logger().i("Typing....");
                      // chatSocket.value!.emit("typingStarted",
                      //     {"roomId": roomid.value, "userId": userId.value});
                    },
                    cursorWidth: 0.9,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                    ),
                    onFieldSubmitted: (value) {},
                  ),
                ),
                InkWell(
                  onTap: () {
                    emojiShowing.value = !emojiShowing.value;
                  },
                  child: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.black54,
                    // weight: 1,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    sendmessage();
                  },
                ),
              ],
            ),
            Offstage(
              offstage: !emojiShowing.value,
              child: EmojiPicker(
                textEditingController: messageController,
                scrollController: scrollController,
                config: Config(
                  height: 257,
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    buttonMode: ButtonMode.MATERIAL,
                    verticalSpacing: 2,
                    gridPadding: const EdgeInsets.all(8),
                    emojiSizeMax: 28 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.2
                            : 1.0),
                  ),
                  // swap: true,
                  emojiTextStyle: const TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.w500,
                  ),
                  skinToneConfig: const SkinToneConfig(),
                  categoryViewConfig: const CategoryViewConfig(
                    dividerColor: Colors.transparent,
                  ),
                  bottomActionBarConfig: const BottomActionBarConfig(),
                  searchViewConfig: const SearchViewConfig(),
                ),
              ),
            ),
          ],
        ),
      ),

      // ______________ Chats _______________
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/chat page bg.jpeg"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: roommessages.value.length,
                itemBuilder: (context, index) {
                  // DateTime createdAt = dateFormater(
                  //     roommessages.value[index]["createdAt"],);
                  // String formattedTime =
                  //     DateFormat('h:mm a').format(createdAt);

                  if (false) {
                    return InfoChatbox(
                        message: "Today",
                        senderName: roommessages.value[index]["senderName"]);
                  } else if (false) {
                    return UserMediaChatbox(
                      time: "12:00pm",
                      listOfImages: mediaImageOfTheGroup,
                      imageUrl: "",
                      isCurrentUser: false,
                    );
                  } else {
                    return UserChatbox(
                      time: "12:00pm",
                      message: "hi, this is poker master",
                      isCurrentUser: true,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 56)
          ],
        ),
      ),
    );
  }
}
