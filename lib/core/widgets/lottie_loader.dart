import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatelessWidget {
  final double width;
  final double height;

  const LottieLoader({this.width = 100, this.height = 100, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lottie/loader.json',
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
