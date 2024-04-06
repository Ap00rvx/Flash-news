import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Thankyou extends StatefulWidget {
  const Thankyou({super.key});

  @override
  State<Thankyou> createState() => _ThankyouState();
}

class _ThankyouState extends State<Thankyou> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LottieBuilder.network(
          'https://lottie.host/136e3111-1e94-4ba0-86ed-d17e908b1a90/1Mmt8CMxIF.json',
        ),
      ),
    );
  }
}
