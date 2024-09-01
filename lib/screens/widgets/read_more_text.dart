import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLength;

  const ReadMoreText({
    required this.text,
    this.maxLength = 70,
    Key? key,
  }) : super(key: key);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textToShow = _isExpanded || widget.text.length <= widget.maxLength
        ? widget.text
        : '${widget.text.substring(0, widget.maxLength)}... ';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: textToShow,
            style: TextStyle(color: Colors.black87,fontFamily: 'sf-ui',fontWeight: FontWeight.w100), // Your text style here
            children: [
              if (widget.text.length > widget.maxLength)
                TextSpan(
                  text: _isExpanded ? 'Read Less' : 'Read More',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = _toggleExpanded,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
