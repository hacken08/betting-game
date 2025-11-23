import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SimpleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final double width;
  final double height;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;

  const SimpleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.style,
    this.width = double.infinity,
    this.height = 40,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle defaultStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size(width, height)),
      backgroundColor: WidgetStatePropertyAll(Color(0xFF17C6ED)),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      elevation: WidgetStatePropertyAll(2),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        style: defaultStyle.merge(style),
        child: child,
      ),
    );
  }
}

class SelectionButon extends HookConsumerWidget {
  final String label;
  final void Function() onButtonClick;
  final Widget? icon;
  final TextStyle? newStyle;
  final BoxDecoration? customDecoration;

  SelectionButon({
    super.key,
    this.newStyle,
    this.customDecoration,
    this.icon,
    required this.label,
    required this.onButtonClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BoxDecoration defaultDecoration = BoxDecoration(
      border: Border.all(
        color: const Color.fromARGB(106, 29, 29, 29),
        width: 0.8,
      ),
      borderRadius: BorderRadius.circular(9),
    );

    // Merging custom decoration with default one
    BoxDecoration mergedDecoration = defaultDecoration.copyWith(
      color: customDecoration?.color ?? defaultDecoration.color,
      border: customDecoration?.border ?? defaultDecoration.border,
      borderRadius:
          customDecoration?.borderRadius ?? defaultDecoration.borderRadius,
      boxShadow: customDecoration?.boxShadow ?? defaultDecoration.boxShadow,
      gradient: customDecoration?.gradient ?? defaultDecoration.gradient,
      image: customDecoration?.image ?? defaultDecoration.image,
    );

    return Container(
      height: 31,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 11,
      ),
      decoration: mergedDecoration,
      child: InkWell(
        onTap: () => onButtonClick(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ).merge(newStyle),
                ),
                icon != null ? icon! : SizedBox(),  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
