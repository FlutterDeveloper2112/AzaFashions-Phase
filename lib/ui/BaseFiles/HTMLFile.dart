import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
class HTMLFile extends StatefulWidget {
  final String content;

  const HTMLFile({Key key, this.content}) : super(key: key);

  @override
  _HTMLFileState createState() => _HTMLFileState();
}

class _HTMLFileState extends State<HTMLFile> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setCurrentScreen(screenName: "About Aza");
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text("About Aza"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(child: Builder(
          builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Html(
                data: "${widget.content}",
                defaultTextStyle: TextStyle(fontSize: 15),
            )
          ],
        );
        return Html(
          data: widget.content,
          padding: EdgeInsets.all(8.0),
          useRichText: true,
        );
          },
        )),
      ),
    );
  }
}
