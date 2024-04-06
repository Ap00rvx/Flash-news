import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:news_project/Features/Boomarks/Providers/Bookmarkprovider.dart';
import 'package:news_project/Model/news_model.dart';
import 'package:provider/provider.dart';

class NewsScreenofBookMarks extends StatefulWidget {
  const NewsScreenofBookMarks({super.key, required this.index});
  final index;
  @override
  State<NewsScreenofBookMarks> createState() => _NewsScreenofBookMarksState();
}

class _NewsScreenofBookMarksState extends State<NewsScreenofBookMarks> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(builder: (context, value, child) {
      final h = MediaQuery.sizeOf(context).height;
      final list_news = value.box.values.toList();
      final w = MediaQuery.sizeOf(context).width;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            list_news[widget.index].title.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            
          ],
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
                      list_news[widget.index].title.toString(),
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
                            imageUrl: list_news[widget.index].image.toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      list_news[widget.index].text.toString(),
                      style: GoogleFonts.poppins(
                          color: Colors.black, fontSize: 18),
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
