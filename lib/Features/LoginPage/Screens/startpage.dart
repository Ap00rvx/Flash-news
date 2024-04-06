import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_project/Features/HomePage/Provider/news_provider.dart';
import 'package:news_project/Features/LoginPage/Screens/LoginPage.dart';
// import 'package:news_project/screens/homepage.dart';
import 'package:news_project/Features/HomePage/Screens/navbar.dart';
import 'package:news_project/Features/LoginPage/Screens/SignUpPage.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Future<String?> getImageUrlForUser() async {
    final em = FirebaseAuth.instance.currentUser!.email.toString();

    final userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: em)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      final imageUrl = userData['imgUrl'] as String?;
      print(imageUrl);
      return imageUrl;
    } else {
      // Handle the case when the user's document is not found
      return null;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    // final h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade600,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Flash News',
          style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.hasData) {
              ConnectivityResult? _result = snapshot.data;
              if (_result == ConnectivityResult.mobile ||
                  _result == ConnectivityResult.wifi) {
                return Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: Container(
                                child: Image.asset('assets/startcard.jpg')),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'News From Around the World\nJust for You',
                                style: GoogleFonts.poppins(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              indent: w * 0.2,
                              endIndent: w * 0.2,
                            ),
                            Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.11),
                              alignment: Alignment.center,
                              child: Text(
                                'Best to Read ,take your time to read little more about the world ',
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              indent: w * 0.2,
                              endIndent: w * 0.2,
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                              onPressed: () {
                                Provider.of<NewsProvider>(context,
                                        listen: false)
                                    .get_news('india');
                                Get.off(StreamBuilder(
                                  stream: _auth.authStateChanges(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return RootPage();
                                    } else {
                                      return SignUpPage();
                                    }
                                  },
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange),
                              child: Text(
                                "Get Started",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Internet Not available '),
                      ElevatedButton(
                          onPressed: () async {
                            ConnectivityResult result =
                                await Connectivity().checkConnectivity();
                            print(result.toString());
                          },
                          child: Text('ReFresh'))
                    ],
                  ),
                );
              }
            } else {
              return const Center(
                  child: SpinKitFoldingCube(
                color: Colors.orange,
                size: 40,
              ));
            }
          }),
    );
  }
}
