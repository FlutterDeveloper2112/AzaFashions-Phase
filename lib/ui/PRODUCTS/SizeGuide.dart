import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SizeGuide extends StatefulWidget {
  @override
  _SizeGuideState createState() => _SizeGuideState();
}

class _SizeGuideState extends State<SizeGuide> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  bool select = false;
  String selectType;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Theme(
      data: ThemeData(fontFamily: "Helvetica"),
      child: MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          appBar: AppBarWidget().myAppBar(context, "Size Guide", scaffoldKey),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    addRadioButton(1, "Inches"),
                    addRadioButton(0, "Centimeters"),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Size Guide - Womens Clothing",
                              style: TextStyle(fontSize: 16),
                            ),
                          )),
                    ),
                  ],
                ),
                GridView.count(
                  childAspectRatio: 4 / 2,
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [...sizeGuide()],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Womens Clothing Conversion Chart",
                              style: TextStyle(fontSize: 16),
                            ),
                          )),
                    ),
                  ],
                ),
                GridView.count(
                  childAspectRatio: 4 / 2,
                  crossAxisCount: 5,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [...conversion()],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    color: Colors.black,
                    height: height * 0.2,
                    width: width * 0.7,
                    child: Image.asset(
                      "images/size.png",
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    )),
                SizedBox(
                  height: 20,
                ),
                Container(
                    color: Colors.red,
                    // height: height * 0.5,
                    width: width * 0.6,
                    child: Image.asset(
                      "images/size.png",
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Prefer To Customize This ?",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Select custom from the size options, and get this piece made according to your measurements and specifications",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List measurementType = ["Inches", "Centimeters"];
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[ 
        Radio(
          activeColor: Colors.black,
          value: measurementType[btnValue],
          groupValue: selectType,
          onChanged: (value) {
            setState(() {
              selectType = value;
              print(selectType);
            });
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "$title",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 15,
                fontFamily: "Helvetica",
                color: Colors.black54),
          ),
        )
      ],
    );
  }

  Container bottomButtons() {
    return Container(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/whatsapp.png",
                    width: 30,
                    height: 20,
                  ),
                  Text("Whatsapp")
                ],
              ),
            ),
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.mail_outline), Text("Email")],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildCell(String title) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xfff5f5f5),
          border: Border.all(color: Colors.grey[300], width: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: title == "BUST" ||
                    title == "WAIST" ||
                    title == "HIP" ||
                    title == "US" ||
                    title == "UK" ||
                    title == "FRANCE" ||
                    title == "ITALY"
                ? TextStyle(fontWeight: FontWeight.bold)
                : TextStyle(),
          ),
        ],
      ),
    );
  }

  List<Widget> sizeGuide() {
    return [
      buildCell(""),
      buildCell("BUST"),
      buildCell("WAIST"),
      buildCell("HIP"),
      ...sizeGuideRow("XS", "32", "25", "35"),
      ...sizeGuideRow("S", "34", "26", "37"),
      ...sizeGuideRow("M", "36", "28", "39"),
      ...sizeGuideRow("L", "38", "30", "40"),
      ...sizeGuideRow("XL", "40", "32", "42"),
      ...sizeGuideRow("XXL", "42", "34", "44"),
      ...sizeGuideRow("3XL", "44", "36", "47"),
      ...sizeGuideRow("4XL", "46", "38", "49"),
      ...sizeGuideRow("5XL", "48", "40", "51"),
      ...sizeGuideRow("6XL", "50", "42", "53"),
    ];
  }

  List<Widget> sizeGuideRow(
      String size, String bust, String waist, String hip) {
    return [
      buildCell(size),
      buildCell(bust),
      buildCell(waist),
      buildCell(hip),
    ];
  }

  List<Widget> conversion() {
    return [
      buildCell(""),
      buildCell("US"),
      buildCell("UK"),
      buildCell("FRANCE"),
      buildCell("ITALY"),
      ...conversionRow("XXS", "2", "6", "34", "38"),
      ...conversionRow("XS", "4", "8", "36", "40"),
      ...conversionRow("S", "6", "10", "38", "42"),
      ...conversionRow("M", "8", "12", "40", "44"),
      ...conversionRow("L", "10", "14", "42", "46"),
      ...conversionRow("XL", "12", "16", "44", "48"),
      ...conversionRow("XXL", "14", "18", "46", "50"),
      ...conversionRow("3XL", "16", "20", "48", "52"),
      ...conversionRow("4XL", "18", "22", "50", "54"),
      ...conversionRow("5XL", "20", "24", "52", "56"),
      ...conversionRow("6XL", "22", "26", "54", "58"),
    ];
  }

  List<Widget> conversionRow(
      String size, String us, String uk, String france, String italy) {
    return [
      buildCell(size),
      buildCell(us),
      buildCell(uk),
      buildCell(france),
      buildCell(italy),
    ];
  }
}
