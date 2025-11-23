import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificaionPage extends HookConsumerWidget {
  const NotificaionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => {context.go("/home")},
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "Notification",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
            NotificationTab(),
          ],
        ),
      )),
    );
  }
}

class NotificationTab extends HookConsumerWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Image.asset("assets/profile.png"),
          ),
          const SizedBox(
            width: 6,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Text(
                        "Notification Name what if it's become so long",
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(1),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "MON 12 2020",
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Tagline of the user this is can be long then why this is fine for its",
                  textScaler: const TextScaler.linear(1),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
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
