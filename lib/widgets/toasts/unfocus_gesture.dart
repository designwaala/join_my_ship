import 'package:flutter/material.dart';

class UnFocusGesture extends StatefulWidget {
  const UnFocusGesture({required this.child});

  final Widget child;

  @override
  _UnFocusGestureState createState() => _UnFocusGestureState();
}

class _UnFocusGestureState extends State<UnFocusGesture> {
  late FocusNode node;
  @override
  void initState() {
    node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (!node.hasFocus) FocusScope.of(context).requestFocus(node);
        },
        child: widget.child,
      );
}
