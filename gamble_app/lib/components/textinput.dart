import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InputFieldwithLable extends HookConsumerWidget {
  final TextEditingController controller;
  final String label;
  final void Function(String? value)? onChange;
  final String? Function(String? value)? validation;
  final void Function()? onEditComplete;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool obsecureValue;
  final double lableSpace;
  final String? hinttext;
  final TextStyle? hinttextStyleInput;
  final TextStyle? labelStyle;

  InputFieldwithLable({
    super.key,
    this.onChange,
    this.hinttextStyleInput,
    this.focusNode,
    this.hinttext,
    this.lableSpace = 8,
    this.onEditComplete,
    this.validation,
    this.readOnly = false,
    this.obsecureValue = false,
    required this.controller,
    required this.label,
    this.labelStyle,
  }) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<bool> showValue = useState(true);

    final style = TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.w600,
      color: Colors.grey[800],
    );

    final defaultHintStyle = TextStyle(
      color: Colors.black38,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style.merge(labelStyle)),
        SizedBox(height: lableSpace),
        TextFormField(
          controller: controller,
          onChanged: onChange,
          onEditingComplete: onEditComplete,
          focusNode: focusNode,
          obscureText: !showValue.value,
          readOnly: readOnly,
          validator: validation,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87, // Text color
          ),
          decoration: InputDecoration(
            filled: true,
            hintText: hinttext,
            hintStyle: defaultHintStyle.merge(hinttextStyleInput),
            suffixIcon: obsecureValue
                ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                      onPressed: () {
                        if (!obsecureValue) return;
                        showValue.value = !showValue.value;
                      },
                      icon: Icon(
                        showValue.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black45,
                      ),
                    ),
                )
                : null,
            fillColor: Color.fromARGB(255, 240, 243, 243), // Background color
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!), // No border
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none, // No border
            ),
          ),
        ),
      ],
    );
  }
}
