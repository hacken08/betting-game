import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gamble_app/components/dialogeBox/bottom_model_sheets.dart';
import 'package:gamble_app/model/user/user.dart';
import 'package:gamble_app/router/router_name.dart';
import 'package:gamble_app/service/auth.dart';
import 'package:gamble_app/states/navbar_state.dart';
import 'package:gamble_app/states/userState.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarStateW = ref.watch(navbarState);
    final userW = ref.watch(userState);
    final size = MediaQuery.of(context).size;

    ValueNotifier<bool> isLoading = useState(false);
    ValueNotifier<User?> thisUser = useState(null);
    ValueNotifier<int> userId = useState(0);

    Future<void> init() async {
      try {
        isLoading.value = true;
        userId.value = await AuthServices.getUserId(context: context);
        if (userW.thisUser == null && context.mounted) userW.getUserDataById(context, userId.value);
        thisUser.value = userW.thisUser;
        isLoading.value = false;
      } catch (error) {
        AuthServices.deleteSession();
        if (!context.mounted) return;
        context.goNamed(RouteNames.login);
      }
    }

    void handleProfileEdit({String? email, String? name, File? profile}) async {
      final isUpdated = await userW.updateUserDataById(
        context,
        userId: userId.value,
        email: email == "" ? null : email,
        name: name == "" ? null : name,
      );
      if (!isUpdated) return;
      simpleDoneAlert(context, "Profile updated successfully");
    }

    Future<void> changePasswordHandler({
      required String currentPassword,
      required String reEnterPassword,
      required String newPassword,
    }) async {
      final isPasswordChanged = await userW.changeUserPassword(
        currentPassword: currentPassword,
        reEnterPassword: reEnterPassword,
        userId: userId.value,
        newPassword: newPassword,
        context: context,
      );
      if (!isPasswordChanged) return;
      context.pop();
      simpleDoneAlert(context, "Your password has been changed successfully");
    }

    useEffect(() {
      init();
      return null;
    }, [userW.thisUser]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            navbarStateW.controller.jumpToTab(0);
          },
        ),
        title: const Text(
          "Back",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: primaryColor,
      body: SafeArea(
        child: isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CachedNetworkImage(
                                imageUrl: "",
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
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              thisUser.value?.username ?? "__",
                              textScaler: const TextScaler.linear(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              thisUser.value?.mobile ?? "__",
                              textScaler: const TextScaler.linear(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Offstage(
                              offstage: thisUser.value?.email == null,
                              child: Text(
                                thisUser.value?.email ?? "",
                                textScaler: const TextScaler.linear(1),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => showEditProfileDialog(
                            context: context,
                            onEditSave: handleProfileEdit,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const ProfileInfoTabs(
                            title: "Completed",
                            description: "64",
                          ),
                          const VerticalDivider(),
                          const ProfileInfoTabs(
                            title: "Participating",
                            description: "3",
                          ),
                          const VerticalDivider(),
                          ProfileInfoTabs(
                            title: "Wallet",
                            description: thisUser.value?.wallet.toString() ?? "__",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        // color: Theme.of(context).primaryColor,
                        color: Theme.of(context).canvasColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            // --------- refer and earn --------- //
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 227, 67, 31),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0, 2),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                  onTap: () =>
                                      context.pushNamed(RouteNames.referEarn),
                                  leading: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(Icons.share,
                                        color: Colors.white, size: 18),
                                  ),
                                  title: const Text(
                                    "Refer and earn",
                                    textScaler: TextScaler.linear(1),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  // const Spacer(),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Colors.white,
                                  )),
                            ),
                            const SizedBox(height: 25),
                            ProfileListInfo(
                              title: "Add Bank Account",
                              icon: Icons.monetization_on,
                              color: Colors.blue,
                              fun: () => context.pushNamed(RouteNames.manageAccount),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ProfileListInfo(
                              title: "Change password",
                              icon: Icons.lock,
                              color: Colors.blue,
                              fun: () => showChangePasswordDialog(
                                context: context,
                                onEditSave: changePasswordHandler,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileListInfo(
                              title: "Notification",
                              icon: Icons.format_list_bulleted_outlined,
                              color: Colors.blue,
                              fun: () {
                                // context.go("/addcash");
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileListInfo(
                              title: "Log out",
                              icon: Icons.logout,
                              color: Colors.blue,
                              fun: () {
                                logoutAlert(context, ref);
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class ProfileInfoTabs extends HookConsumerWidget {
  final String title;
  final String description;
  const ProfileInfoTabs({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          description,
          textScaler: const TextScaler.linear(1),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          title,
          textScaler: const TextScaler.linear(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class ProfileListInfo extends HookConsumerWidget {
  final String title;
  final IconData icon;
  final Color color;
  final void Function() fun;
  const ProfileListInfo({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.fun,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
          onTap: fun,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          title: Text(
            title,
            textScaler: const TextScaler.linear(1),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          // const Spacer(),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.black54,
          )),
    );
  }
}
