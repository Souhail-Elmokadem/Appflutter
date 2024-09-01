import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TourAvatar extends StatefulWidget {
  final String imageUrl;

  const TourAvatar({required this.imageUrl, Key? key}) : super(key: key);

  @override
  _TourAvatarState createState() => _TourAvatarState();
}

class _TourAvatarState extends State<TourAvatar> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[200], // Set a background color for visibility
      child: _hasError
          ? const Icon(Icons.error) // Display the error icon if there's an error
          : Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Use Future.microtask to delay the setState call
          Future.microtask(() {
            if (mounted) {
              setState(() {
                _hasError = true;
              });
            }
          });
          return const SizedBox(); // Return an empty box or a placeholder
        },
      ),
    );
  }
}
