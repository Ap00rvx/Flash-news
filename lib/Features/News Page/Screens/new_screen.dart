import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:news_project/Features/HomePage/Provider/news_provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key, required this.index});
  final index;

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  int max_line = 5;
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(builder: (context, value, child) {
      final res = value.news;
      final h = MediaQuery.sizeOf(context).height;
      final w = MediaQuery.sizeOf(context).width;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            res.news![widget.index].title.toString(),
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
                      res.news![widget.index].title.toString(),
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
                            imageUrl: res.news![widget.index].image.toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Source -',
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: Text(
                          res.news![widget.index].author.toString() +
                              ',' +
                              res.news![widget.index].sourceCountry
                                  .toString()
                                  .toUpperCase(),
                          style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          res.news![widget.index].text.toString(),
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
