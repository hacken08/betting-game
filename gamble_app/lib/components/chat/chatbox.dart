import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:logger/logger.dart';

class UserChatbox extends HookConsumerWidget {
  final String time;
  final String message;
  final bool isCurrentUser;
  const UserChatbox({
    super.key,
    required this.time,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        bottom: 6,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.end,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserMediaChatbox extends HookConsumerWidget {
  final String time;
  final String imageUrl;
  final bool isCurrentUser;
  final List<ImageProvider> listOfImages;
  const UserMediaChatbox({
    super.key,
    required this.time,
    required this.imageUrl,
    required this.listOfImages,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        bottom: 6,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              // context.pushNamed(
              //   RouteNames.imageViewer,
              //   extra: imageUrl,
              //   pathParameters: {"reciver": "3"},
              // );
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  // scale: 5,
                  // width: 160,
                  imageUrl: imageUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.contain,
                  // boxShadow:
                ),
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          //   constraints: const BoxConstraints(maxWidth: 280),
          //   decoration: BoxDecoration(
          //     color: isCurrentUser ? Colors.blue : Colors.white,
          //     borderRadius: BorderRadius.circular(10),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey.withOpacity(0.2),
          //         spreadRadius: 1,
          //         blurRadius: 1,
          //         offset: const Offset(0, 2),
          //       ),
          //     ],
          //   ),
          //   child: Wrap(
          //     crossAxisAlignment: WrapCrossAlignment.end,
          //     alignment: WrapAlignment.end,
          //     runAlignment: WrapAlignment.end,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(left: 8.0),
          //         child: Text(
          //           time,
          //           style: TextStyle(
          //             color: isCurrentUser ? Colors.white : Colors.grey,
          //             fontSize: 12,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class UserGroupMediaChatbox extends HookConsumerWidget {
  final String time;
  final String imageUrl;
  final String? senderName;
  final String? profilePic;
  final String? phNumber;
  final String? messageType;
  final bool showSenderInfo;
  final bool isCurrentUser;
  final List<ImageProvider> listOfImages;
  const UserGroupMediaChatbox({
    super.key,
    required this.time,
    required this.imageUrl,
    required this.messageType,
    required this.listOfImages,
    required this.isCurrentUser,
    required this.senderName,
    required this.profilePic,
    required this.phNumber,
    required this.showSenderInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        // bottom: showSenderInfo ? 10 :  3,
        top: showSenderInfo ? 12 : 5,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: messageType == "INFO"
            ? MainAxisAlignment.center
            : isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !isCurrentUser && messageType != "INFO"
              ? Padding(
                  padding: const EdgeInsets.only(top: 3.0, right: 9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CachedNetworkImage(
                        imageUrl: profilePic ?? "",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/user.png",
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.only(right: messageType == "INFO" ? 0 : 9.0),
                  child: const SizedBox(width: 28),
                ),
          Container(
            // padding: const EdgeInsets.only(bottom: 7, right: 15, top: 5, left: 10),
            // padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !isCurrentUser
                    ? Text(
                        senderName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 2,
                            color: Colors.deepOrange),
                      )
                    : const SizedBox(),
                InkWell(
                  onTap: () {
                    // context.pushNamed(RouteNames.imageViewer,
                    //     extra: imageUrl, pathParameters: {"reciver": "3"});
                  },
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        // scale: 5,
                        // width: 160,
                        imageUrl: imageUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/user.png",
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.contain,
                        // boxShadow:
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GroupChatbox extends HookConsumerWidget {
  final String time;
  final String message;
  final String? senderName;
  final String? phNumber;
  final String? profilePic;
  final String? messageType;
  final bool isCurrentUser;
  final bool showSenderInfo;
  const GroupChatbox({
    super.key,
    required this.time,
    required this.message,
    required this.phNumber,
    required this.senderName,
    required this.profilePic,
    required this.messageType,
    required this.isCurrentUser,
    required this.showSenderInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(
        left: 10,
        // bottom: showSenderInfo ? 10 :  3,
        top: showSenderInfo ? 12 : 5,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: messageType == "INFO"
            ? MainAxisAlignment.center
            : isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !isCurrentUser && messageType != "INFO" && showSenderInfo
              ? Padding(
                  padding: const EdgeInsets.only(top: 3.0, right: 9),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CachedNetworkImage(
                        imageUrl: profilePic ?? "",
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/user.png",
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.only(right: messageType == "INFO" ? 0 : 9.0),
                  child: const SizedBox(width: 28),
                ),
          messageType == "INFO"
              ? Container(
                  // padding: const EdgeInsets.only(bottom: 7, right: 15, top: 5, left: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  margin: const EdgeInsets.only(bottom: 7),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(72, 166, 166, 166),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "${senderName ?? "You"} created this group $message",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                )
              : Container(
                  // padding: const EdgeInsets.only(bottom: 7, right: 15, top: 5, left: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: const Radius.circular(10),
                        bottomRight: const Radius.circular(10),
                        topLeft: Radius.circular(
                            isCurrentUser || !showSenderInfo ? 10 : 0),
                        topRight: Radius.circular(isCurrentUser ? 0 : 10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !isCurrentUser && showSenderInfo
                          ? Text(
                              senderName ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  color: Colors.deepOrange),
                            )
                          : const SizedBox(),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.end,
                        runAlignment: WrapAlignment.end,
                        children: [
                          Text(
                            message,
                            style: TextStyle(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              time,
                              style: TextStyle(
                                color:
                                    isCurrentUser ? Colors.white : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class InfoChatbox extends HookConsumerWidget {
  final String message;
  final String senderName;
  const InfoChatbox({
    super.key,
    required this.message,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        // bottom: showSenderInfo ? 10 :  3,
        top: 12,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // padding: const EdgeInsets.only(bottom: 7, right: 15, top: 5, left: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: const EdgeInsets.only(bottom: 7),
            constraints: const BoxConstraints(maxWidth: 280),
            decoration: BoxDecoration(
              color: const Color.fromARGB(72, 166, 166, 166),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSuggestTradeChat extends HookConsumerWidget {
  final int id;
  final String time;
  final bool isCurrentUser;

  const UserSuggestTradeChat({
    super.key,
    required this.id,
    required this.time,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: isCurrentUser ? size.width * 0.2 : 5,
              right: isCurrentUser ? 5 : size.width * 0.2,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                //........... Stock prprice
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 90,
                          child: Text(
                            "SBICARD",
                            overflow: TextOverflow.ellipsis,
                            textScaler: TextScaler.noScaling,
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: const Text(
                            "NSE",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 51, 51),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      "₹435.34",
                      style: TextStyle(
                        fontSize: 15.5,
                        color: Color.fromARGB(255, 58, 58, 58),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),

                const Divider(
                  thickness: 0.5,
                  height: 22,
                  color: Color.fromARGB(52, 0, 0, 0),
                ),
                const SizedBox(
                  height: 5,
                ),

                //........ Buy Targer ........
                const Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Buy at",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color.fromARGB(195, 41, 41, 41)),
                        ),
                        Text(
                          "435.34",
                          style: TextStyle(
                            fontSize: 16.5,
                            color: Color.fromARGB(255, 58, 58, 58),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          "Sell at",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color.fromARGB(195, 41, 41, 41)),
                        ),
                        Text(
                          "435.34",
                          style: TextStyle(
                            fontSize: 16.5,
                            color: Color.fromARGB(255, 58, 58, 58),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          "Qty",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color.fromARGB(195, 41, 41, 41)),
                        ),
                        Text(
                          "1",
                          style: TextStyle(
                            fontSize: 16.5,
                            color: Color.fromARGB(255, 58, 58, 58),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (isCurrentUser) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7)),
                    child: const Center(
                      child: Text(
                        'APPLY',
                        textScaler: TextScaler.noScaling,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            alignment:
                isCurrentUser ? Alignment.bottomRight : Alignment.bottomLeft,
            margin: const EdgeInsets.only(top: 2),
            child: Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
