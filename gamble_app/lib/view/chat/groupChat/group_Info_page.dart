// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:trading_trads/services/api.dart';
// import 'package:trading_trads/states/chats/groupstate.dart';
// import 'package:trading_trads/states/chats/liveSocketChat.dart';
// import 'package:trading_trads/states/userstate.dart';
// import 'package:trading_trads/utils/alerts.dart';
// import 'package:trading_trads/utils/utilsmethod.dart';

// class Groupinfopage extends HookConsumerWidget {
//   const Groupinfopage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ValueNotifier<File?> profileImage = useState<File?>(null);
//     // ValueNotifier<bool> isLoading = useState(false);
//     ValueNotifier<int> userid = useState(0);
//     ValueNotifier<bool> isGroupCreating = useState(false);

//     final groupNameController = useTextEditingController();
//     final groupChatW = ref.watch(groupChatState);
//     final liveSocket = ref.watch(liveSocketChatState);
//     final userW = ref.watch(userState);

//     void init() async {
//       userid.value = await userW.getUserData(UserData.id, context);
//     }

//     Future<void> createGroup() async {
//       UploadResponse responseImg;
//       isGroupCreating.value = true;
//       simepleAlert(context, "Group is createing, Pleas wait...");
//       if (groupNameController.text.isEmpty) {
//         return erroralert(context, "Fail", "Please enter group name");
//       }
//       responseImg =
//           await uploadFile(profileImage.value!, userid.value.toString());
//       if (!responseImg.status) {
//         return erroralert(context, "Error", responseImg.message);
//       }
//       bool isGroupCreated = await groupChatW.createGroup(
//           context, userid.value, groupNameController.text, responseImg.data);
//       if (isGroupCreated) {
//         liveSocket.chatSocket!.emit(
//             "newGroupCreated", {"roomId": groupChatW.newGroupCreated["id"]});
//         context.pop();
//         context
//             .replace("/contact/groupChat/${groupChatW.newGroupCreated["id"]}");
//       }
//       isGroupCreating.value = false;
//     }

//     Future<void> changeImage() async {
//       try {
//         final image =
//             await ImagePicker().pickImage(source: ImageSource.gallery);
//         if (image == null) return;
//         final cropedImagePath = await cropImage(context, image.path);
//         // final cropedImagePath = image.path;
//         profileImage.value = File(cropedImagePath!);
//       } on PlatformException catch (e) {
//         if (context.mounted) {
//           erroralert(context, "Error", 'Failed to pick image: $e');
//         }
//       }
//     }

//     useEffect(() {
//       init();
//       return null;
//     }, []);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 1, 121, 220),
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         shadowColor: Colors.grey,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 10.0),
//           child: IconButton(
//             onPressed: () => context.pop(),
//             icon: const Icon(
//               Icons.arrow_back_sharp,
//               color: Colors.white,
//               size: 21,
//             ),
//           ),
//         ),
//         leadingWidth: 40,
//       ),
//       body: Column(
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(
//                     right: 20, left: 20, bottom: 20, top: 10),
//                 decoration: const BoxDecoration(
//                     color: Color.fromARGB(255, 1, 121, 220),
//                     border: Border(bottom: BorderSide(color: Colors.grey))),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     profileImage.value == null
//                         ? InkWell(
//                             onTap: () async {
//                               await changeImage();
//                             },
//                             child: Container(
//                               height: 67,
//                               width: 67,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(100),
//                                 color: const Color.fromARGB(255, 0, 109, 198),
//                               ),
//                               child: const Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           )
//                         : InkWell(
//                             onTap: () async {
//                               await changeImage();
//                             },
//                             child: SizedBox(
//                               width: 70,
//                               height: 70,
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(100),
//                                 child: Image.file(
//                                   profileImage.value!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                     const SizedBox(
//                       width: 19,
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 15.0),
//                         child: TextFormField(
//                           // onEditingComplete: () => searchUser(),
//                           controller: groupNameController,
//                           autofocus: true,
//                           textAlignVertical: TextAlignVertical.top,
//                           style: const TextStyle(color: Colors.white),
//                           cursorColor: Colors.white,
//                           cursorWidth: 1,
//                           decoration: const InputDecoration(
//                               hintText: "Group name",
//                               hintStyle: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.white54),
//                               contentPadding: EdgeInsets.only(top: 10),
//                               // barrierColor: Colors.black38,
//                               enabledBorder: InputBorder.none,
//                               focusedBorder: InputBorder.none),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 right: 20,
//                 bottom: -16,
//                 child: InkWell(
//                   onTap: isGroupCreating.value ? null : () => createGroup(),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(100),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3), // 30% opacity
//                           spreadRadius: 1,
//                           blurRadius: 2,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.check_sharp,
//                       color: Colors.blue,
//                       size: 25,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: ListView.builder(
//                 itemCount: groupChatW.selectedMember.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     onTap: () {},
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//                     splashColor: const Color.fromARGB(255, 246, 242, 255),
//                     hoverColor: const Color.fromARGB(255, 246, 242, 255),
//                     focusColor: const Color.fromARGB(255, 246, 242, 255),
//                     tileColor: Colors.white,
//                     dense: false,
//                     leading: ClipRRect(
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(100)),
//                       child: CachedNetworkImage(
//                         width: 47,
//                         imageUrl:
//                             groupChatW.selectedMember[index]["profile"] ?? " ",
//                         // imageUrl:
//                         //     "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
//                         progressIndicatorBuilder:
//                             (context, url, downloadProgress) =>
//                                 CircularProgressIndicator(
//                                     value: downloadProgress.progress),
//                         errorWidget: (context, url, error) => Image.asset(
//                           "assets/images/user.png",
//                           fit: BoxFit.cover,
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text(groupChatW.selectedMember[index]["name"] ?? " ",
//                         // "User name",
//                         style: const TextStyle(
//                           fontSize: 15.6,
//                           fontWeight: FontWeight.w500,
//                         )),
//                     subtitle: Text(
//                         groupChatW.selectedMember[index]["bio"] ??
//                             "Investing in the future",
//                         // "Hi, how trade going?",
//                         style: const TextStyle(
//                             fontSize: 13.6,
//                             color: Colors.black45,
//                             fontWeight: FontWeight.w500)),
//                   );
//                 }),
//           ),
//           Text("${groupChatW.selectedMember.length} members"),
//           const SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     );
//   }
// }
