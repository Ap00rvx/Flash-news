import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class SignUpAnimation extends StatefulWidget {
  const SignUpAnimation({super.key});

  @override
  State<SignUpAnimation> createState() => _SignUpAnimationState();
}

class _SignUpAnimationState extends State<SignUpAnimation> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.network('https://lottie.host/5b4407b0-e58e-40b6-9662-f2d19bf18979/DtG3llRbH1.json'),
    );
  }
}