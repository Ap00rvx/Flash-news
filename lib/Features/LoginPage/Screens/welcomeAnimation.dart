import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class WelcomeAnimation extends StatefulWidget {
  const WelcomeAnimation({super.key});

  @override
  State<WelcomeAnimation> createState() => _WelcomeAnimationState();
}

class _WelcomeAnimationState extends State<WelcomeAnimation> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.network('https://lottie.host/72bc60d6-c151-4438-95e6-182d5289ae1a/TjSOJT0t6l.json'),
    );
  }
}