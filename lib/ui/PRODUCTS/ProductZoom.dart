import 'dart:io';

import 'package:azaFashions/models/ProductDetail/MediaGallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;

class ProductZoom extends StatefulWidget {
  final List<MediaGallery> imgList;

  ProductZoom({this.imgList});

  ZoomImg createState() => ZoomImg();
}

class ZoomImg extends State<ProductZoom> with SingleTickerProviderStateMixin {
  final _currentPageNotifier = ValueNotifier<int>(0);
  int totalPages;

  double _scale = 1.0;
  double _previousScale = 1.0;

  void initState() {
    totalPages = widget.imgList.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("PIXELS:${ MediaQuery.of(context).size.height/1.25} ");
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: SafeArea(
          top:true,
          child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Platform.isAndroid
                                      ? Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 20,
                                  )
                                      : Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ))),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top:10.0),
                        child: Container(
                            width: double.infinity,
                            height:540/* MediaQuery.of(context).size.height/1.25*/,
                            child: PhotoViewGallery.builder(

                                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                                onPageChanged: (i){
                                  _currentPageNotifier.value = i;
                                },
                                itemCount: widget.imgList.length, builder: (context,int index){
                              return PhotoViewGalleryPageOptions(


                                imageProvider: CachedNetworkImageProvider(
                                  widget.imgList[index].url,
                                ),
                                // Contained = the smallest possible size to fit one dimension of the screen
                                minScale: PhotoViewComputedScale.contained * 1,
                                // Covered = the smallest possible size to fit the whole screen
                                maxScale: PhotoViewComputedScale.covered * 2,
                              );
                            })

                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10),child: _buildCircleIndicator(),)


                      // ListView.builder() shall be used here.
                    ]),
              )),
        ),
      ),
    );
  }

  _buildCircleIndicator() {
    return CirclePageIndicator(
      dotColor: Colors.grey,
      selectedDotColor: Colors.black,
      itemCount: widget.imgList.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }
}
