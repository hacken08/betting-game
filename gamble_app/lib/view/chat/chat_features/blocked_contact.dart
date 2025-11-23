import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlockedUser extends HookConsumerWidget {
  const BlockedUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(Icons.arrow_back),
              onTap: () => context.pop()),
          titleSpacing: 1,
          title: const Text(
            "Blocked Traders",
            style: TextStyle(
                color: Color.fromARGB(255, 56, 56, 56),
                fontWeight: FontWeight.w500,
                fontSize: 19,
                fontFamily: 'Roboto'),
          ),
          actions: [
            InkWell(
              onTap: () {},
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: const Icon(Icons.person_add_outlined, size: 21),
            ),
            const SizedBox(width: 25)
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              thickness: 0.3,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 17.0, top: 10),
              child: Text(
                'Traders',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: Colors.black45),
              ),
            ),
            const SizedBox(height: 4),
            for (int a = 0; a < 4; a++) ...[
              ListTile(
                onTap: () {},
                dense: true,
                splashColor: const Color.fromARGB(255, 246, 242, 255),
                hoverColor: const Color.fromARGB(255, 246, 242, 255),
                focusColor: const Color.fromARGB(255, 246, 242, 255),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/profiles/sample_${1 + a}.png'),
                  radius: 22,
                ),
                title: const Text("The Bullisher",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              const SizedBox(
                height: 8,
              )
            ], // for loop

            const Divider(
              thickness: 0.3,
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Image.asset(
                    'assets/icons/blocked.png',
                    scale: 1.5,
                    color: const Color.fromARGB(137, 49, 49, 49),
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  "Blocked trader will no longer be able to send \nyou messages.",
                  style: TextStyle(
                      color: Color.fromARGB(137, 49, 49, 49), fontSize: 13),
                ),
              ],
            ),
          ],
        ));
  }
}
