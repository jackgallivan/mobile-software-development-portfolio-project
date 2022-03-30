import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;

  const LargeButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  /* BUILD */
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 72,
              width: 72,
              child: FittedBox(child: child),
            ),
          ),
        ],
      ),
    );
  }
}
