// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:logger/logger.dart';
// import 'package:trading_trads/components/bottomSheets/groupMemberActions.dart';
// import 'package:trading_trads/services/api.dart';
// import 'package:trading_trads/states/chats/groupstate.dart';
// import 'package:trading_trads/states/chats/liveSocketChat.dart';
// import 'package:trading_trads/states/userstate.dart';
// import 'package:trading_trads/utils/alerts.dart';
// import 'package:trading_trads/utils/utilsmethod.dart';

// class GroupDetailsPage extends HookConsumerWidget {
//   final int groupId;
//   const GroupDetailsPage({super.key, required this.groupId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Logger().f("building group_details");

//     ValueNotifier<bool> isEditEnable = useState(false);
//     ValueNotifier<File?> profileImage = useState(null);
//     ValueNotifier<int> userId = useState(0);
//     ValueNotifier<List> roomMembers = useState([]);
//     ValueNotifier<bool> isCurrentUserAdmin = useState(false);
//     ValueNotifier<bool> isLaoding = useState(false);

//     final size = MediaQuery.of(context).size;
//     final groupW = ref.watch(groupChatState);
//     final memberId = useRef(0);
//     final userW = ref.watch(userState);
//     final groupNameController = useTextEditingController();
//     final groupDecsriptionController = useTextEditingController();
//     final liveSocket = ref.watch(liveSocketChatState);

//     Future<void> init() async {
//       isLaoding.value = true;
//       userId.value = await userW.getUserData(UserData.id, context);

//       await userW.getUserInfo(context, userId.value);
//       for (int a = 0; a < roomMembers.value.length; a++) {
//         final member = roomMembers.value[a];
//         if (member["userId"].toString() == userId.value.toString()) {
//           isCurrentUserAdmin.value = member["isAdmin"];
//           memberId.value = member["id"];
//           break;
//         }
//       }
//       isLaoding.value = false;
//     }

//     void updateGroupHandler() async {
//       Map infoToUpdate = {};
//       if (groupNameController.text != groupW.currentGroup["roomName"] &&
//           groupNameController.text != "") {
//         infoToUpdate["roomName"] = groupNameController.text;
//       }
//       if (groupDecsriptionController.text !=
//               groupW.currentGroup["roomDescription"] &&
//           groupDecsriptionController.text != "Add group description") {
//         infoToUpdate["roomDescription"] = groupDecsriptionController.text;
//       }
//       if (profileImage.value != groupW.currentGroup["roomLogo"] &&
//           profileImage.value != null) {
//         UploadResponse responseImg;
//         responseImg =
//             await uploadFile(profileImage.value!, userId.value.toString());
//         infoToUpdate["roomLogo"] = responseImg.data;
//       }
//       if (infoToUpdate.isEmpty) {
//         isEditEnable.value = false;
//         return;
//       }
//       groupW.updateGroupInfo(context, groupId, infoToUpdate);
//       isEditEnable.value = false;
//     }

//     Future<void> changeImage() async {
//       try {
//         final image =
//             await ImagePicker().pickImage(source: ImageSource.gallery);
//         if (image == null) return;
//         final croopedImagepath = await cropImage(context, image.path);
//         profileImage.value = File(croopedImagepath!);
//       } on PlatformException catch (e) {
//         if (context.mounted) {
//           erroralert(context, "Error", 'Failed to pick image: $e');
//         }
//       }
//       updateGroupHandler();
//     }

//     useEffect(() {
//       roomMembers.value = groupW.currentGroup["members"] as List;
//       groupNameController.text = groupW.currentGroup["roomName"] ?? "";
//       groupDecsriptionController.text =
//           groupW.currentGroup["roomDescription"] ?? "Add group description";

//       return null;
//     }, [groupW.currentGroup]);

//     useEffect(() {
//       init();
//       return null;
//     }, []);

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 244, 245, 250),
//         body: isLaoding.value
//             ? const Expanded(child: Center(child: CircularProgressIndicator()))
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     //  ---------------- Group profile -----------------
//                     Container(
//                       width: size.width,
//                       height: size.height * 0.35,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 16),
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               fit: BoxFit.cover,
//                               onError: (exception, stackTrace) =>
//                                   const CircularProgressIndicator(),
//                               image: NetworkImage(
//                                   groupW.currentGroup["roomLogo"] ?? ""))),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           //  ......... Grop Action button ........
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               InkWell(
//                                   onTap: () => context.pop(),
//                                   child: Icon(
//                                     Icons.arrow_back_sharp,
//                                     size: 19,
//                                     shadows: [
//                                       Shadow(
//                                         blurRadius: 6,
//                                         offset: const Offset(0, 1),
//                                         color: Colors.black.withOpacity(0.9),
//                                       ),
//                                     ],
//                                     color: const Color.fromARGB(
//                                         237, 255, 255, 255),
//                                   )),
//                               const Spacer(),
//                               InkWell(
//                                 onTap: () {
//                                   // isEditEnable.value = !isEditEnable.value;
//                                   changeImage();
//                                 },
//                                 child: Icon(
//                                   Icons.add_a_photo_rounded,
//                                   size: 19,
//                                   shadows: [
//                                     Shadow(
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 1),
//                                       color: Colors.black.withOpacity(0.9),
//                                     ),
//                                   ],
//                                   color:
//                                       const Color.fromARGB(237, 255, 255, 255),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 width: 20,
//                               ),
//                               Offstage(
//                                 offstage: !isCurrentUserAdmin.value,
//                                 child: InkWell(
//                                   onTap: () {
//                                     isEditEnable.value = !isEditEnable.value;
//                                   },
//                                   child: Icon(
//                                     isEditEnable.value
//                                         ? Icons.edit_off_rounded
//                                         : Icons.edit,
//                                     size: 19,
//                                     shadows: [
//                                       Shadow(
//                                         blurRadius: 6,
//                                         offset: const Offset(0, 1),
//                                         color: Colors.black.withOpacity(0.9),
//                                       ),
//                                     ],
//                                     color: const Color.fromARGB(
//                                         237, 255, 255, 255),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 longtext(groupW.currentGroup["roomName"], 22),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 18,
//                                     shadows: [
//                                       Shadow(
//                                         blurRadius: 6,
//                                         offset: const Offset(0, 1),
//                                         color: Colors.black.withOpacity(0.9),
//                                       ),
//                                     ],
//                                     color: Colors.white),
//                               ),
//                               Text(
//                                 "${groupW.currentGroup["members"].length} members",
//                                 style: TextStyle(
//                                   color:
//                                       const Color.fromARGB(228, 255, 255, 255),
//                                   fontSize: 14,
//                                   shadows: [
//                                     Shadow(
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 1),
//                                       color: Colors.black.withOpacity(0.9),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),

//                     //  ---------------- Group Info -----------------
//                     Container(
//                       width: size.width,
//                       margin: const EdgeInsets.symmetric(vertical: 0),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 13, vertical: 14),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(6),
//                         color: Colors.white,
//                         // border: Border.all(width: 0.10, color: Colors.black45),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 0,
//                             offset: const Offset(1, 0),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Group Name",
//                             style: TextStyle(
//                                 fontSize: 11.5,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey[400]),
//                           ),
//                           const SizedBox(height: 3),
//                           isEditEnable.value
//                               ? TextFormField(
//                                   autofocus: true,
//                                   cursorWidth: 0.8,
//                                   style: const TextStyle(fontSize: 13),
//                                   controller: groupNameController,
//                                   selectionHeightStyle: BoxHeightStyle.max,
//                                   // style: TextStyle(fontSize: 12),
//                                   decoration: const InputDecoration(
//                                       suffix: Icon(
//                                         Icons.edit_sharp,
//                                         size: 17,
//                                       ),
//                                       enabledBorder: UnderlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.black54,
//                                               width: 0.4)),
//                                       focusedBorder: UnderlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.black,
//                                               width: 0.5))))
//                               : Text(
//                                   groupW.currentGroup["roomName"] ?? "",
//                                   style: const TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color.fromARGB(210, 27, 27, 27)),
//                                 ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Text(
//                             "Group Description",
//                             style: TextStyle(
//                                 fontSize: 11.5,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.grey[400]),
//                           ),
//                           const SizedBox(height: 3),
//                           isEditEnable.value
//                               ? TextFormField(
//                                   autofocus: true,
//                                   maxLength: 200,
//                                   maxLines: 3,
//                                   // expands: true,
//                                   cursorWidth: 0.8,
//                                   style: const TextStyle(fontSize: 13),
//                                   controller: groupDecsriptionController,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   selectionHeightStyle: BoxHeightStyle.max,
//                                   decoration: const InputDecoration(
//                                       suffix: Icon(
//                                         Icons.edit,
//                                         size: 17,
//                                       ),
//                                       enabledBorder: UnderlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.black54,
//                                               width: 0.4)),
//                                       focusedBorder: UnderlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: Colors.black,
//                                               width: 0.5))))
//                               : Text(
//                                   groupW.currentGroup["roomDescription"] ??
//                                       "Add group description",
//                                   style: const TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w500,
//                                       color: Color.fromARGB(187, 27, 27, 27)),
//                                 ),
//                           Row(
//                             children: [
//                               !isEditEnable.value
//                                   ? const SizedBox()
//                                   : InkWell(
//                                       onTap: () => updateGroupHandler(),
//                                       child: Container(
//                                         height: 29,
//                                         width: 60,
//                                         decoration: BoxDecoration(
//                                             color: const Color.fromARGB(
//                                                 255, 13, 136, 236),
//                                             borderRadius:
//                                                 BorderRadius.circular(6)),
//                                         child: const Center(
//                                           child: Text(
//                                             "Done",
//                                             style: TextStyle(
//                                                 fontSize: 13,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                               const SizedBox(
//                                 width: 8,
//                               ),
//                               !isEditEnable.value
//                                   ? const SizedBox()
//                                   : InkWell(
//                                       onTap: () => isEditEnable.value = false,
//                                       child: Container(
//                                         height: 29,
//                                         width: 60,
//                                         decoration: BoxDecoration(
//                                             color: Colors.transparent,
//                                             borderRadius:
//                                                 BorderRadius.circular(6)),
//                                         child: const Center(
//                                           child: Text(
//                                             "Cancel",
//                                             style: TextStyle(
//                                                 fontSize: 13,
//                                                 color: Colors.red,
//                                                 // color: const Color.fromARGB(
//                                                 //     255, 13, 136, 236),
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),

//                     //  ---------------- Group Members -----------------
//                     Container(
//                       width: size.width,
//                       // height: 300,
//                       margin: const EdgeInsets.symmetric(vertical: 12),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 13, vertical: 2),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(6),
//                         color: Colors.white,
//                         // border: Border.all(width: 0.10, color: Colors.black45),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 0,
//                             offset: const Offset(1, 0),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Offstage(
//                             offstage: !isCurrentUserAdmin.value,
//                             child: ListTile(
//                                 onTap: () {
//                                   String paramObject = jsonEncode(
//                                       {"addMembers": true, "groupId": groupId});
//                                   context.push(
//                                       "/contact/multiSelect/$paramObject");
//                                 },
//                                 // minLeadingWidth: 0,
//                                 minVerticalPadding: 0,
//                                 leading: Image.asset(
//                                   'assets/icons/account2.png',
//                                   width: 20,
//                                   color: Colors.blue[500],
//                                 ),
//                                 dense: true,
//                                 titleAlignment: ListTileTitleAlignment.center,
//                                 contentPadding: const EdgeInsets.only(left: 10),
//                                 title: Text(
//                                   "Add member",
//                                   style: TextStyle(
//                                       color: Colors.blue[600],
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 16),
//                                 )),
//                           ),
//                           Offstage(
//                             offstage: !isCurrentUserAdmin.value,
//                             child: const Divider(
//                               thickness: 0.5,
//                             ),
//                           ),
//                           for (int a = 0;
//                               a < roomMembers.value.length;
//                               a++) ...[
//                             ListTile(
//                               onTap: () => memberActionsMenu(
//                                   context,
//                                   roomMembers.value[a],
//                                   isCurrentUserAdmin.value,
//                                   groupW,
//                                   groupId,
//                                   liveSocket,
//                                   userW),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 0, vertical: 0),
//                               splashColor:
//                                   const Color.fromARGB(255, 246, 242, 255),
//                               hoverColor:
//                                   const Color.fromARGB(255, 246, 242, 255),
//                               focusColor:
//                                   const Color.fromARGB(255, 246, 242, 255),
//                               tileColor: Colors.white,
//                               dense: true,
//                               // minTileHeight: 100,
//                               leading: ClipRRect(
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(100)),
//                                 child: CachedNetworkImage(
//                                   width: 40,
//                                   height: 40,
//                                   imageUrl: roomMembers.value[a]["user"]
//                                           ["profile"] ??
//                                       " ",
//                                   // imageUrl:  "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
//                                   progressIndicatorBuilder:
//                                       (context, url, downloadProgress) =>
//                                           CircularProgressIndicator(
//                                               value: downloadProgress.progress),
//                                   errorWidget: (context, url, error) =>
//                                       Image.asset(
//                                     "assets/images/user.png",
//                                     fit: BoxFit.cover,
//                                   ),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               title: Text(
//                                   roomMembers.value[a]["user"]["username"] ==
//                                           userW.userInfo["username"]
//                                       ? "You"
//                                       : roomMembers.value[a]["user"]
//                                           ["username"],
//                                   // "User name",
//                                   style: const TextStyle(
//                                     fontSize: 15.6,
//                                     fontWeight: FontWeight.w500,
//                                   )),
//                               subtitle: Text(
//                                   roomMembers.value[a]["user"]["bio"] ??
//                                       "Investing in the future",
//                                   // "Hi, how trade going?",
//                                   style: const TextStyle(
//                                       fontSize: 13.6,
//                                       color: Colors.black45,
//                                       fontWeight: FontWeight.w500)),

//                               trailing: Offstage(
//                                 offstage: !roomMembers.value[a]["isAdmin"],
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 3, horizontal: 7),
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: const Color.fromARGB(
//                                               255, 1, 179, 7),
//                                           width: 0.2),
//                                       color: const Color.fromARGB(
//                                           54, 115, 232, 176),
//                                       borderRadius: BorderRadius.circular(4)),
//                                   child: const Text(
//                                     "Group Admin",
//                                     style: TextStyle(
//                                         fontSize: 9,
//                                         color: Color.fromARGB(255, 1, 179, 7),
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (a != roomMembers.value.length - 1) ...[
//                               const Divider(
//                                 thickness: 0.5,
//                                 indent: 40,
//                                 height: 6,
//                                 // height: 20,
//                               ),
//                             ]
//                           ]
//                         ],
//                       ),
//                     ),

//                     //  ---------------- Group exist buttons -----------------
//                     Container(
//                       width: size.width,
//                       // height: 300,
//                       margin: const EdgeInsets.symmetric(vertical: 12),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 13, vertical: 4),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(6),
//                         color: Colors.white,
//                         // border: Border.all(width: 0.10, color: Colors.black45),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             spreadRadius: 2,
//                             blurRadius: 0,
//                             offset: const Offset(1, 0),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           ListTile(
//                               onTap: () async {
//                                 // removing user from group: API REQUESTION
//                                 final isRemoved =
//                                     await groupW.leaveOrRemoveFromGroups(
//                                         context, [memberId.value], groupId);

//                                 if (!isRemoved) return;
//                                 Logger()
//                                     .f("member is removed sending message...");

//                                 //  sending done alret message on succesffull removed
//                                 if (!context.mounted) return;
//                                 doneAlert(context, "group leaved", "");

//                                 Logger().d("socket connected  -> ${liveSocket.chatSocket!.active}");
//                                 // liveSocket.intisocket();

//                                 context.pop();
//                                 context.pop();

//                                 // sending info message in group of removed user
//                                 liveSocket.chatSocket!.emit("infoMessages", {
//                                   "roomId": groupId,
//                                   "senderId": userId,
//                                   "message":
//                                       "${userW.userInfo["username"]} leave this group"
//                                 });
//                               },
//                               contentPadding: const EdgeInsets.all(0),
//                               leading: const Padding(
//                                 padding: EdgeInsets.only(top: 2.0),
//                                 child: Icon(Icons.logout,
//                                     color: Colors.red, size: 21),
//                               ),
//                               // const SizedBox(
//                               //   width: 20,
//                               // ),
//                               dense: true,
//                               title: Text(
//                                 "Exist Group",
//                                 style: TextStyle(
//                                     color: Colors.red[600],
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 16),
//                               )),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     )
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }
