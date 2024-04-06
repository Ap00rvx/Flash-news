import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:news_project/Features/HomePage/Provider/news_provider.dart';

class NewsScreen1 extends StatefulWidget {
  const NewsScreen1({super.key, required this.id , required this.title ,required this.text, required this.url});
  final id;
  final text ;
  final title ;
  final url ;

  @override
  State<NewsScreen1> createState() => _NewsScreen1State();
}

class _NewsScreen1State extends State<NewsScreen1> {
  @override
  int max_line = 5;
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(builder: (context, value, child) {
      // final res = value.news;
      final h = MediaQuery.sizeOf(context).height;
      final w = MediaQuery.sizeOf(context).width;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            widget.title ,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey.shade400,
                      child: Container(
                        width: w,
                        height: h * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                            placeholder: (context, url) =>
                                SpinKitWanderingCubes(
                              color: Colors.black,
                              size: 40,
                            ),
                            imageUrl: widget.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          widget.text,
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 18),
                          maxLines: max_line,
                          
                          overflow: TextOverflow.ellipsis,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              max_line += 10;
                            });
                          },
                          child: Text(
                            'Readmore',
                            style: GoogleFonts.poppins(
                                color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
