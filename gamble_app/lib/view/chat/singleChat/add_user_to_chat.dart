// ignore_for_file: dead_code

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class AddUserTOChat extends HookConsumerWidget {
  // final Map pageFuntinoInfo;
  const AddUserTOChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<int> userId = useState(0);
    ValueNotifier<bool> isLoading = useState(false);
    ValueNotifier<bool> isSearching = useState(false);
    ValueNotifier<List> searchedRoom = useState<List>([]);
    ValueNotifier<List> selectedItem = useState<List>([]);

    final size = MediaQuery.of(context).size;
    final usersearchController = useTextEditingController();

    Future<void> init() async {}

    void searchUser() async {}

    useEffect(() {
      init();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 121, 220),
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.grey,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.white,
              size: 21,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 8),
          child: TextFormField(
            onEditingComplete: () => searchUser(),
            controller: usersearchController,
            autofocus: true,
            textAlignVertical: TextAlignVertical.top,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            cursorWidth: 1,
            decoration: InputDecoration(
                fillColor: Colors.pink,
                suffix: InkWell(
                    onTap: () {
                      searchedRoom.value = [];
                      usersearchController.text = "";
                    },
                    child: const Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 16,
                    )),
                hintText: "Search person to add...",
                alignLabelWithHint: true,
                hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54),
                contentPadding: const EdgeInsets.only(top: 10),
                // barrierColor: Colors.black38,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
        leadingWidth: 40,
      ),
      floatingActionButton: InkWell(
        onTap: () async {},
        child: AnimatedContainer(
          height: selectedItem.value.isEmpty ? 0 : 45,
          width: selectedItem.value.isEmpty ? 0 : 45,
          alignment: Alignment.center,
          transformAlignment: Alignment.bottomCenter,
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ),
          ),
          child: Icon(
            Icons.arrow_forward_sharp,
            color: Colors.white,
            size: selectedItem.value.isEmpty ? 0 : 26,
          ),
        ),
      ),
      body: Column(
        children: [
          //  ----------- above selected user ...............
          selectedItem.value.isEmpty
              ? const SizedBox()
              : Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  color: const Color.fromARGB(255, 1, 121, 220),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedItem.value
                            .map(
                              (item) => SizedBox(
                                width: 72,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            child: CachedNetworkImage(
                                              width: 50,
                                              height: 50,
                                              imageUrl: item["profile"] ?? " ",
                                              // imageUrl:
                                              //     "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Image.asset(
                                                "assets/images/user.png",
                                                fit: BoxFit.cover,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 243, 33, 86),
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 2,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 11,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item["name"] ?? " ",
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        height: 1.2,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                            .toList()),
                  ),
                ),

          isSearching.value || isLoading.value
              ? SizedBox(
                  height: size.height * 0.4,
                  width: size.width,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                )
              : searchedRoom.value.isEmpty
                  // .............  already existed room .............
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            bool isItemSelected = false;
                            return Column(
                              children: [
                                Offstage(
                                  offstage: false,
                                  child: ListTile(
                                    onTap: () {},
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 6),
                                    splashColor: const Color.fromARGB(
                                        255, 246, 242, 255),
                                    hoverColor: const Color.fromARGB(
                                        255, 246, 242, 255),
                                    focusColor: const Color.fromARGB(
                                        255, 246, 242, 255),
                                    tileColor: isItemSelected
                                        ? const Color.fromARGB(
                                            255, 246, 242, 255)
                                        : Colors.white,
                                    dense: true,
                                    leading: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            width: 40,
                                            height: 40,
                                            imageUrl: "",
                                            // imageUrl: "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "assets/profile.png",
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        !isItemSelected
                                            ? const SizedBox()
                                            : Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                        color: Colors.white,
                                                        width: 2,
                                                      )),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 11,
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                                    title: Text("Demo user",
                                        // "User name",
                                        style: const TextStyle(
                                          fontSize: 15.6,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    subtitle: Text("poker master",
                                        // "Hi, how trade going?",
                                        style: const TextStyle(
                                            fontSize: 13.6,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                const Divider(
                                  thickness: 0.4,
                                  height: 0,
                                  endIndent: 35,
                                  indent: 35,
                                  color: Color.fromARGB(50, 0, 0, 0),
                                )
                              ],
                            );
                          }),
                    )
                  // .............  Searched room .............
                  : Expanded(
                      child: ListView.builder(
                          itemCount: searchedRoom.value.length,
                          itemBuilder: (context, index) {
                            bool isItemSelected = selectedItem.value
                                .contains(searchedRoom.value[index]);
                            // Logger().f(searchedRoom.value[index]);
                            return Column(
                              children: [
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
                                  tileColor: isItemSelected
                                      ? const Color.fromARGB(255, 246, 242, 255)
                                      : Colors.white,
                                  dense: true,
                                  leading: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100)),
                                        child: CachedNetworkImage(
                                          width: 40,
                                          height: 40,
                                          imageUrl: searchedRoom.value[index]
                                                  ["profile"] ??
                                              " ",
                                          // imageUrl: "https://i.pinimg.com/originals/f5/1e/cb/f51ecb1e3eed6716ed6cd0548da4c4a0.jpg",
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            "assets/images/user.png",
                                            fit: BoxFit.cover,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      !isItemSelected
                                          ? const SizedBox()
                                          : Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    )),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 11,
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                  title: Text(
                                      searchedRoom.value[index]["username"] ??
                                          " ",
                                      // "User name",
                                      style: const TextStyle(
                                        fontSize: 15.6,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  subtitle: Text(
                                      searchedRoom.value[index]["bio"] ??
                                          "Investing into future",
                                      // "Hi, how trade going?",
                                      style: const TextStyle(
                                          fontSize: 13.6,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w500)),
                                ),
                                const Divider(
                                  thickness: 0.4,
                                  height: 0,
                                  endIndent: 35,
                                  indent: 35,
                                  color: Color.fromARGB(50, 0, 0, 0),
                                )
                              ],
                            );
                          }),
                    )
        ],
      ),
    );
  }
}
