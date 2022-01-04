import 'package:flutter/material.dart';

class CirlceImage extends StatelessWidget {
  const CirlceImage({
    Key? key,
    this.imageProvider,
    this.imageRadius = 20,
  }) : super(key: key);

  final double imageRadius;
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: imageRadius,
      child: CircleAvatar(
        backgroundImage: imageProvider,
        radius: imageRadius - 5,
      ),
    );
  }
}
