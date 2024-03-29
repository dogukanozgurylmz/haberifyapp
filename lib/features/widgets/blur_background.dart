import 'dart:ui';

import 'package:flutter/material.dart';

class BlurBackground extends StatelessWidget {
  const BlurBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blur"),
      ),
      body: Stack(
        children: [
          buildBackgroundImage(),
          const Center(
            child: BlurBackgroundWidget(
              opacity: 0.2,
              blur: 10,
              borderRadius: 20,
              child: SizedBox(height: 300, width: 300),
            ),
          ),
        ],
      ),
    );
  }

  Image buildBackgroundImage() {
    return Image.network(
      "https://images5.alphacoders.com/432/432500.jpg",
      fit: BoxFit.cover,
      height: double.infinity,
    );
  }
}

class BlurBackgroundWidget extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;
  final double borderRadius;

  const BlurBackgroundWidget(
      {Key? key,
      required this.blur,
      required this.opacity,
      required this.child,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff303231).withOpacity(opacity),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: child,
        ),
      ),
    );
  }
}
