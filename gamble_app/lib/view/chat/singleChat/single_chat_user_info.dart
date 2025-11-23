import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class SingleChatUserInfo extends HookConsumerWidget {
  final int reciverId;
  const SingleChatUserInfo({super.key, required this.reciverId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> userId = useState(0);
    ValueNotifier<List> commonRooms = useState([]);
    ValueNotifier<Map> recieverInfo = useState({});
    ValueNotifier<bool> isLaoding = useState(false);

    final size = MediaQuery.of(context).size;

    Future<void> init() async {
      // Logger().f("enter init");

      // isLaoding.value = true;
      // userId.value = await userW.getUserData(UserData.id, context);
      // Logger().f(userId.value);

      // if (!context.mounted) return;
      // await userW.getUserInfo(context, reciverId, rebuildState: false);
      // Logger().f(userW.userInfo);

      // if (!context.mounted) return;
      // commonRooms.value = await groupW.findCommonGroupofUser(context, userId.value, reciverId);
      // recieverInfo.value = userW.userInfo;
      // userW.userInfo = {};
      // Logger().f(commonRooms.value);

      // isLaoding.value = false;
      // Logger().f("init exist");
    }

    // useEffect(() {
    //   commonRooms.value = groupW.currentGroup["members"] as List;
    //   groupNameController.text = groupW.currentGroup["roomName"] ?? "";
    //   groupDecsriptionController.text =
    //       groupW.currentGroup["roomDescription"] ?? "Add group description";
    //   return null;
    // }, [groupW.currentGroup]);

    useEffect(() {
      init();
      return null;
    }, []);

    Logger().f(commonRooms.value);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 245, 250),
        body: isLaoding.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    //  ---------------- Group profile -----------------
                    Container(
                      width: size.width,
                      height: size.height * 0.35,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 16),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) =>
                              const CircularProgressIndicator(),
                          image: AssetImage("assets/profile.png"),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //  ......... Grop Action button ........
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () => context.pop(),
                                  child: Icon(
                                    Icons.arrow_back_sharp,
                                    size: 19,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6,
                                        offset: const Offset(0, 1),
                                        color: Colors.black.withOpacity(0.9),
                                      ),
                                    ],
                                    color: const Color.fromARGB(
                                        237, 255, 255, 255),
                                  )),
                              const Spacer(),
                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                longtext("Poker master ", 22),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6,
                                        offset: const Offset(0, 1),
                                        color: Colors.black.withOpacity(0.9),
                                      ),
                                    ],
                                    color: Colors.white),
                              ),
                              Text(
                                "${commonRooms.value.length} common group",
                                // "3 commong roups",
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(228, 255, 255, 255),
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6,
                                      offset: const Offset(0, 1),
                                      color: Colors.black.withOpacity(0.9),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    //  ---------------- Group Info -----------------
                    Container(
                      width: size.width,
                      margin: const EdgeInsets.symmetric(vertical: 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                        // border: Border.all(width: 0.10, color: Colors.black45),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 0,
                            offset: const Offset(1, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Poker master",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(210, 27, 27, 27)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Bio",
                            style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "As name suggest master of gambling ",
                            // "Add group description",
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(187, 27, 27, 27)),
                          ),
                        ],
                      ),
                    ),

                    //  ---------------- Group Members -----------------
                    Container(
                      width: size.width,
                      // height: 300,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                        // border: Border.all(width: 0.10, color: Colors.black45),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 0,
                            offset: const Offset(1, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Offstage(
                            offstage: false,
                            child: ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Text(
                                  "Common groups",
                                  style: TextStyle(
                                      // color: Colors.blue[600],
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                )),
                          ),
                          Offstage(
                            offstage:
                                commonRooms.value.isNotEmpty ? true : false,
                            child: const SizedBox(
                                height: 40,
                                child: Text(
                                  "No common group you share",
                                  style: TextStyle(
                                      color: Color.fromARGB(137, 49, 49, 49),
                                      fontSize: 12),
                                )),
                          ),
                          for (final commonRoom in commonRooms.value) ...[
                            CommonGroupListTile(commonRoomsInfo: commonRoom),
                            // if (a != commonRooms.value.length - 1) ...[
                            const Divider(
                              thickness: 0.5,
                              indent: 40,
                              height: 3,
                              // height: 20,
                            ),
                            // ]
                          ]
                        ],
                      ),
                    ),

                    //  ---------------- Block buttons -----------------
                    BlockButton(size: size),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class BlockButton extends StatelessWidget {
  const BlockButton({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      // height: 300,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        // border: Border.all(width: 0.10, color: Colors.black45),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 0,
            offset: const Offset(1, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            onTap: () => comingalert(context),
            contentPadding: const EdgeInsets.all(0),
            leading: const Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Icon(Icons.block, color: Colors.red, size: 21),
            ),
            // const SizedBox(
            //   width: 20,
            // ),
            dense: true,
            title: Text(
              "Block user",
              style: TextStyle(
                  color: Colors.red[600],
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class CommonGroupListTile extends StatelessWidget {
  final Map commonRoomsInfo;
  const CommonGroupListTile({
    super.key,
    required this.commonRoomsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // onTap: () => memberActionsMenu(
      //     context,
      //     commonRooms.value[a],
      //     isCurrentUserAdmin.value,
      //     groupW,
      //     reciverId,
      //     liveSocket,
      //     userW),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      splashColor: const Color.fromARGB(255, 246, 242, 255),
      hoverColor: const Color.fromARGB(255, 246, 242, 255),
      focusColor: const Color.fromARGB(255, 246, 242, 255),
      tileColor: Colors.white,
      dense: true,
      // minTileHeight: 100,
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: CachedNetworkImage(
          width: 40,
          height: 40,
          imageUrl: commonRoomsInfo["roomLogo"] ?? " ",
          // imageUrl:  "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/user.png",
            fit: BoxFit.cover,
          ),
          fit: BoxFit.cover,
        ),
      ),
      title: Text(commonRoomsInfo["roomName"] ?? "",
          // "User name",
          style: const TextStyle(
            fontSize: 15.6,
            fontWeight: FontWeight.w500,
          )),
      subtitle: Text(
          commonRoomsInfo["roomDescription"] ?? "No group description",
          // "Hi, how trade going?",
          style: const TextStyle(
              fontSize: 13.6,
              color: Colors.black45,
              fontWeight: FontWeight.w500)),

      // trailing: Container(
      //   padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
      //   decoration: BoxDecoration(
      //       border: Border.all(
      //           color: const Color.fromARGB(255, 1, 179, 7), width: 0.2),
      //       color: const Color.fromARGB(54, 115, 232, 176),
      //       borderRadius: BorderRadius.circular(4)),
      //   child: const Text(
      //     "Group Admin",
      //     style: TextStyle(
      //         fontSize: 9,
      //         color: Color.fromARGB(255, 1, 179, 7),
      //         fontWeight: FontWeight.w500),
      //   ),
      // ),
    );
  }
}
