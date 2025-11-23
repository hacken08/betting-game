import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamble_app/components/buttons.dart';
import 'package:gamble_app/components/textinput.dart';
import 'package:gamble_app/utils/alerts.dart';
import 'package:gamble_app/utils/utilsmethod.dart';
import 'package:gamble_app/view/utils/validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

void showEditProfileDialog({
  required BuildContext context,
  // required GlobalKey<FormState> formKey,
  void Function({String? name, String? email, File? profile})? onEditSave,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  showModalBottomSheet(
    isDismissible: true,
    useRootNavigator: true,
    enableDrag: true,
    context: context,
    elevation: 0,
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    isScrollControlled: true,
    builder: (context) {
      final size = MediaQuery.of(context).size;
      File? profileImage;
      // final nameController = TextEditingController();

      Future<void> changeImage(void Function(void Function()) setState) async {
        try {
          final image =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          if (image == null) return;
          // final cropedImagePath = await cropImage(context, image.path);
          // final cropedImagePath = image.path;
          setState(() => profileImage = File(image.path));
        } on PlatformException catch (e) {
          if (context.mounted) {
            erroralert(context, "Error", 'Failed to pick image: $e');
          }
        }
      }

      return StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width,
                  child: Center(
                    child: Container(
                      height: 67,
                      width: 67,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color(0xFF17C6ED),
                      ),
                      child: InkWell(
                        onTap: () async => await changeImage(setState),
                        child: profileImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  profileImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputFieldwithLable(
                        controller: nameController,
                        // validation: validateName,
                        hinttext: "Enter name",
                        label: "Name",
                      ),
                      const SizedBox(height: 25),
                      InputFieldwithLable(
                        controller: emailController,
                        validation: validateEmailId,
                        hinttext: "Enter email",
                        label: "Email",
                      ),
                      const SizedBox(height: 25),
                      SimpleButton(
                        child: Text("Save"),
                        onPressed: () {
                          if (!formKey.currentState!.validate() ||
                              (nameController.text.isEmpty &&
                                  emailController.text.isEmpty)) return;
                          if (onEditSave == null) return;

                          onEditSave(
                            email: emailController.text,
                            name: nameController.text,
                            profile: profileImage,
                          );
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

void showChangePasswordDialog({
  required BuildContext context,
  void Function({
    required String currentPassword,
    required String newPassword,
    required String reEnterPassword,
  })? onEditSave,
}) {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final reEnterPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    isDismissible: true,
    useRootNavigator: true,
    enableDrag: true,
    context: context,
    elevation: 0,
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    isScrollControlled: true,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      return StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width - 20,
                  child: const Text(
                    "Change Your Password",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.5,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: size.width,
                  child: Text(
                    "You need to enter your old password to change your password.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputFieldwithLable(
                        controller: currentPasswordController,
                        validation: validatePassword,
                        hinttext: "Enter current password",
                        obsecureValue: true,
                        label: "Current Password",
                      ),
                      const SizedBox(height: 20),
                      InputFieldwithLable(
                        controller: newPasswordController,
                        validation: validatePassword,
                        hinttext: "Enter new password",
                        obsecureValue: true,
                        label: "New Password",
                      ),
                      const SizedBox(height: 20),
                      InputFieldwithLable(
                        controller: reEnterPasswordController,
                        obsecureValue: true,
                        validation: (String? value) {
                          if (value == null ||
                              value != newPasswordController.text)
                            return "Your password doesn't match";
                          return validatePassword(value);
                        },
                        hinttext: "Enter re-enter password",
                        label: "Re-enter Password",
                      ),
                      const SizedBox(height: 30),
                      SimpleButton(
                        child: Text("CONFIRM"),
                        onPressed: () {
                          if (!formKey.currentState!.validate() ||
                              (currentPasswordController.text.isEmpty &&
                                  newPasswordController.text.isEmpty &&
                                  reEnterPasswordController.text.isEmpty))
                            return;
                          if (onEditSave == null) return;
                          onEditSave(
                            reEnterPassword: reEnterPasswordController.text,
                            currentPassword: currentPasswordController.text,
                            newPassword: newPasswordController.text,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
