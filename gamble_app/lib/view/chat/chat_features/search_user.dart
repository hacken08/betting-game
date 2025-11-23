// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:isar/isar.dart';
// import 'package:logger/logger.dart';
// import 'package:trading_trads/database/database.dart';
// import 'package:trading_trads/database/db_models/recentsearch.dart';
// import 'package:trading_trads/services/api.dart';
// import 'package:trading_trads/states/chats/groupstate.dart';
// import 'package:trading_trads/states/userstate.dart';
// import 'package:trading_trads/utils/alerts.dart';

// // ignore: camel_case_types
// class SearchUser extends HookConsumerWidget {
//   const SearchUser({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final usersearch = useTextEditingController();
//     final size = MediaQuery.of(context).size;
//     final userStateW = ref.watch(userState);
//     final groupsW = ref.watch(groupChatState);

//     ValueNotifier<int> userid = useState(0);
//     ValueNotifier<bool> isSearching = useState<bool>(false);
//     ValueNotifier<List> users = useState<List>([]);
//     ValueNotifier<List> recentSearchs = useState<List>([]);

//     Future<void> init() async {
//       userid.value = await userStateW.getUserData(UserData.id, context);
//       recentSearchs.value = await isarDB.recentSearchs.where().findAll();
//       recentSearchs.value = recentSearchs.value.reversed.toList();
//       groupsW.searchedGroup = [];
//       // recentSearchs.value.forEach((value ) => Logger().i(value.id));
//     }

//     void searchUser() async {
//       isSearching.value = true;
//       if (usersearch.text == "" || usersearch.text.isEmpty) {
//         erroralert(
//           context,
//           "Error",
//           "Enter username in order to search",
//         );
//         isSearching.value = false;
//         return;
//       }
//       groupsW.searchedGroup = [];
//       users.value = [];

//       groupsW.searchRoomByName(context, usersearch.text);
//       Logger().f(groupsW.searchedGroup);

//       final data = await apiCall(
//           query:
//               "query searchUsername (\$searchUserInput: SearchUserInput!) {searchUsername(searchUserInput: \$searchUserInput) {id,wallet,username,profile,bio}}",
//           variables: {
//             "searchUserInput": {"username": usersearch.text}
//           },
//           headers: {
//             "content-type": "*/*"
//           });
//       if (data.status) {
//         users.value = data.data["searchUsername"];
//       }

//       usersearch.text = "";
//       isSearching.value = false;
//     }

//     Future<void> recentSearchListHandler(
//         int id, String name, String profile, bool isGroup) async {
//       final existedSearch =
//           await isarDB.recentSearchs.where().userIdEqualTo(id).findFirst();
//       int totalUserInRecentSearch = await isarDB.recentSearchs.count();

//       if (existedSearch == null) {
//         if (totalUserInRecentSearch >= 8) {
//           final howManyToRemove = totalUserInRecentSearch - 7;
//           for (int a = 0; a < howManyToRemove; a++) {
//             isarDB.writeTxn(() async =>
//                 isarDB.recentSearchs.delete(recentSearchs.value[a].id));
//           }
//         }
//         final recentSearchList = RecentSearch()
//           ..userId = id
//           ..name = name
//           ..isGroup = isGroup
//           ..path = profile;
//         await isarDB.writeTxn(() async {
//           await isarDB.recentSearchs.put(recentSearchList);
//         });
//         init();
//       }
//     }

//     useEffect(() {
//       init();
//       return null;
//     }, []);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 239, 239, 239),
//       // ___________ App Bar ___________
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         shadowColor: Colors.grey,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 10.0),
//           child: IconButton(
//             onPressed: () => context.pop(),
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//               size: 21,
//             ),
//           ),
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 8.0, left: 10),
//           child: TextFormField(
//             onEditingComplete: () => searchUser(),
//             controller: usersearch,
//             autofocus: true,
//             textAlignVertical: TextAlignVertical.top,
//             decoration: const InputDecoration(
//                 hintText: "Search",
//                 hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
//                 contentPadding: EdgeInsets.only(top: 10),
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none),
//           ),
//         ),
//         leadingWidth: 40,
//         // ____________ Search Box ____________
//       ), // AppBar end......

//       body: SingleChildScrollView(
//         child: isSearching.value
//             ? SizedBox(
//                 width: size.width,
//                 child: const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   recentSearchs.value.isEmpty
//                       ? const SizedBox()
//                       : Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 9),
//                           width: size.width,
//                           // height: 20,
//                           color: const Color.fromARGB(255, 239, 239, 239),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "Recent",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 15,
//                                     color: Color.fromARGB(255, 138, 138, 138)),
//                               ),
//                               InkWell(
//                                   onTap: () async {
//                                     await isarDB.writeTxn(() async =>
//                                         isarDB.recentSearchs.clear());
//                                     init();
//                                   },
//                                   child: const Icon(
//                                     Icons.delete,
//                                     color: Colors.red,
//                                     size: 18,
//                                   ))
//                             ],
//                           ),
//                         ),

//                   // _-_-__-_-__-_-__-_-_ recentaly searched user _-_-__-_-__-_-__-_-_
//                   recentSearchs.value.isEmpty
//                       ? const SizedBox()
//                       : Container(
//                           width: size.width,
//                           // height: 20,
//                           padding: const EdgeInsets.symmetric(vertical: 9),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: users.value.isEmpty
//                                 ? [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(
//                                           0.3), // Light grey shadow
//                                       blurRadius: 2,
//                                       spreadRadius: 0,
//                                       offset:
//                                           const Offset(0, 1), // Vertical offset
//                                     ),
//                                   ]
//                                 : [
//                                     BoxShadow(
//                                       color: Colors.grey
//                                           .withOpacity(1), // Light grey shadow
//                                       blurRadius: 0,
//                                       spreadRadius: 2,
//                                       offset:
//                                           const Offset(0, 2), // Vertical offset
//                                     ),
//                                   ],
//                           ),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               children: [
//                                 const SizedBox(width: 10),
//                                 for (int a = 0;
//                                     a < recentSearchs.value.length;
//                                     a++) ...[
//                                   InkWell(
//                                     onTap: () {
//                                       Logger()
//                                           .i(recentSearchs.value[a].isGroup);
//                                       recentSearchs.value[a].isGroup
//                                           ? context.push(
//                                               "/contact/groupChat/${recentSearchs.value[a].userId}")
//                                           : context.push(
//                                               "/contact/chat/${recentSearchs.value[a].userId}");
//                                     },
//                                     child: SizedBox(
//                                       width: 80,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                             child: CachedNetworkImage(
//                                               width: 48,
//                                               height: 48,
//                                               imageUrl:
//                                                   recentSearchs.value[a].path,
//                                               // imageUrl:     "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
//                                               progressIndicatorBuilder:
//                                                   (context, url,
//                                                           downloadProgress) =>
//                                                       CircularProgressIndicator(
//                                                           value:
//                                                               downloadProgress
//                                                                   .progress),
//                                               errorWidget:
//                                                   (context, url, error) =>
//                                                       Image.asset(
//                                                 "assets/images/user.png",
//                                                 fit: BoxFit.cover,
//                                               ),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           Text(
//                                             // "Name of person",
//                                             recentSearchs.value[a].name,
//                                             maxLines: 2,
//                                             textAlign: TextAlign.center,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 11,
//                                                 color: Colors.black54),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ]
//                               ],
//                             ),
//                           ),
//                         ),

//                   // _-_-__-_-__-_-__-_-_ Searched user _-_-__-_-__-_-__-_-_
//                   users.value.isEmpty
//                       ? const SizedBox()
//                       : Container(
//                           width: size.width,
//                           // height: 20,
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           color: const Color.fromARGB(255, 239, 239, 239),
//                           child: const Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Text(
//                                 "Searched user",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 15,
//                                     color: Color.fromARGB(255, 138, 138, 138)),
//                               )
//                             ],
//                           ),
//                         ),
//                   users.value.isEmpty
//                       ? const SizedBox()
//                       : Container(
//                           width: size.width,
//                           // height: 20,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 9, horizontal: 9),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey
//                                     .withOpacity(0.3), // Light grey shadow
//                                 blurRadius: 2,
//                                 spreadRadius: 0,
//                                 offset: const Offset(0, 1), // Vertical offset
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               for (int i = 0; i < users.value.length; i++) ...[
//                                 userid.value == users.value[i]["id"]
//                                     ? const SizedBox()
//                                     : SearchResult(
//                                         isGroup: false,
//                                         init: init,
//                                         recentSearchListHandler:
//                                             recentSearchListHandler,
//                                         profile:
//                                             users.value[i]["profile"] ?? " ",
//                                         name: users.value[i]["username"] ?? " ",
//                                         username: users.value[i]["bio"] ??
//                                             "Investing in the future",
//                                         id: users.value[i]["id"] ?? " ",
//                                       ),
//                                 users.value.length == i + 1
//                                     ? const SizedBox()
//                                     : const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 20, vertical: 2),
//                                         child: Divider(thickness: 0.6),
//                                       )
//                               ],
//                             ],
//                           ),
//                         ),

//                   // _-_-__-_-__-_-__-_-_ Searched Groups  _-_-__-_-__-_-__-_-_
//                   groupsW.searchedGroup.isEmpty
//                       ? const SizedBox()
//                       : Container(
//                           width: size.width,
//                           // height: 20,
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           color: const Color.fromARGB(255, 239, 239, 239),
//                           child: const Row(
//                             children: [
//                               SizedBox(width: 10),
//                               Text(
//                                 "Searched Group",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 15,
//                                     color: Color.fromARGB(255, 138, 138, 138)),
//                               )
//                             ],
//                           ),
//                         ),
//                   groupsW.searchedGroup.isEmpty
//                       ? const SizedBox()
//                       : Container(
//                           width: size.width,
//                           // height: 20,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 9, horizontal: 9),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey
//                                     .withOpacity(0.3), // Light grey shadow
//                                 blurRadius: 2,
//                                 spreadRadius: 0,
//                                 offset: const Offset(0, 1), // Vertical offset
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             children: [
//                               for (int i = 0;
//                                   i < groupsW.searchedGroup.length;
//                                   i++) ...[
//                                 SearchResult(
//                                   init: init,
//                                   isGroup: true,
//                                   recentSearchListHandler:
//                                       recentSearchListHandler,
//                                   profile: groupsW.searchedGroup[i]
//                                           ["roomLogo"] ??
//                                       " ",
//                                   name: groupsW.searchedGroup[i]["roomName"] ??
//                                       " ",
//                                   username: groupsW.searchedGroup[i]
//                                           ["roomDescription"] ??
//                                       groupsW.searchedGroup[i]["latestMessage"]
//                                           ["message"],
//                                   id: groupsW.searchedGroup[i]["id"] ?? " ",
//                                 ),
//                                 groupsW.searchedGroup.length == i + 1
//                                     ? const SizedBox()
//                                     : const Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 20, vertical: 2),
//                                         child: Divider(thickness: 0.6),
//                                       )
//                               ],
//                             ],
//                           ),
//                         ),

//                   // ]
//                 ],
//               ),
//       ),
//     );
//   }
// }

// // ignore: must_be_immutable
// class SearchResult extends HookConsumerWidget {
//   final String profile;
//   final String name;
//   final bool isGroup;
//   final void Function() init;
//   final String username;
//   Future<void> Function(int id, String name, String profile, bool isGroup)
//       recentSearchListHandler;
//   final int id;
//   SearchResult(
//       {super.key,
//       required this.profile,
//       required this.name,
//       required this.isGroup,
//       required this.username,
//       required this.init,
//       required this.id,
//       required this.recentSearchListHandler});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ListTile(
//       onTap: () {
//         recentSearchListHandler(id, name, profile, isGroup);
//         isGroup
//             ? context.push("/contact/groupChat/$id")
//             : context.push("/contact/chat/$id");
//       },
//       dense: true,
//       leading: ClipRRect(
//         borderRadius: const BorderRadius.all(Radius.circular(100)),
//         child: CachedNetworkImage(
//           width: 40,
//           height: 40,
//           imageUrl: profile,
//           progressIndicatorBuilder: (context, url, downloadProgress) =>
//               CircularProgressIndicator(value: downloadProgress.progress),
//           errorWidget: (context, url, error) => Image.asset(
//             "assets/images/user.png",
//             fit: BoxFit.cover,
//           ),
//           fit: BoxFit.cover,
//         ),
//       ),
//       title: Text(name,
//           style: const TextStyle(
//             fontSize: 15.6,
//             fontWeight: FontWeight.w500,
//           )),
//       subtitle: Text(username,
//           // "Hi, how trade going?",
//           style: const TextStyle(
//               fontSize: 13.6,
//               color: Colors.black45,
//               fontWeight: FontWeight.w500)),
//     );
//   }
// }
