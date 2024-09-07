import 'package:flutter/material.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({required this.child});

  static void restartApp(BuildContext context) {
    final state = context.findAncestorStateOfType<_RestartWidgetState>();
    if (state != null) {
      state.restartApp();
    } else {
      throw Exception("RestartWidget is not found in the widget tree");
    }
  }


  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey(); // Assign a new key to force a rebuild
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
