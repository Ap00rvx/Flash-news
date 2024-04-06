import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Snack {
  show(String text, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            MyAnimatedContainer()
          ],
        ),
        showCloseIcon: true,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.white,
        closeIconColor: Colors.red));
  }
}

class MyAnimatedContainer extends StatefulWidget {
  @override
  _MyAnimatedContainerState createState() => _MyAnimatedContainerState();
}

class _MyAnimatedContainerState extends State<MyAnimatedContainer> {
  double _width = 0;
  // Initial width

  @override
  void initState() {
    super.initState();

    // Start the animation
    Future.delayed(Duration.zero, () {
      setState(() {
        _width = MediaQuery.sizeOf(context).width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 3, milliseconds: 500),
      width: _width,
      height: 5,
      color: Colors.orange.shade200,
    );
  }
}
