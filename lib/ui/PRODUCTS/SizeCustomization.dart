import 'package:azaFashions/bloc/ProductBloc/CustomizationBloc.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:flutter/material.dart';

class Customization extends StatefulWidget {
  int productId;
  String rootCategory;


  Customization({this.rootCategory = "Men",this.productId});

  @override
  _CustomizationState createState() => _CustomizationState();
}

class _CustomizationState extends State<Customization> {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  bool select = false;
  String selectType;
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    widget.rootCategory = "Men";
    print(widget.rootCategory);
    final width = MediaQuery.of(context).size.width;
    List measurementType = ["inch", "centimeters"];
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
                  fontSize: 15, fontFamily: "Helvetica", color: Colors.black54),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBarWidget().myAppBar(context, "Customization", scaffoldKey),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                addRadioButton(0, "Inches"),
                addRadioButton(1, "Centimeters"),
              ],
            ),

            if(widget.rootCategory=="Men")menMeasurements(width),
            if(widget.rootCategory=="Women")womenMeasurements(width),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                      "Please specify any additional customisation requests here"),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        )
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 35,
                  // color: Colors.red,
                  child: Checkbox(
                      activeColor: Colors.black,
                      checkColor: Colors.white,
                      value: agree,
                      onChanged: (bool val) {
                        setState(() {
                          agree = val;
                        });
                      }),
                ),
                Expanded(
                  child: Text(
                    "Need help? Place your order without measurements. We will call to assist you with the form.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        fontFamily: "Helvetica",
                        color: Colors.black),
                  ),
                )
              ],
            ),
            StreamBuilder<bool>(
                stream: customizationBloc.measurements,
                builder: (context, snapshot) {
                  return Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: const Color(0xeee0e0e0),
                      onPressed: () async {
                        print(snapshot.hasData);
                      //  await customizationBloc.addMeasurement(selectType,"nope",widget.rootCategory,widget.productId,agree);
                        if(snapshot.hasData && selectType!=null){
                        //  await customizationBloc.addMeasurement(selectType,"nope",widget.rootCategory,widget.productId,agree);
                          Navigator.pop(context);
                        }
                        else{
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter details properly"),));
                        }

                      },
                      child: Text(
                        'SAVE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Helvetica",
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  Widget womenMeasurements(double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GridView.count(
        childAspectRatio: 3 / 2,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 40,
        children: [
          buildTextFields(
              width,
              "Shoulder Length",
              customizationBloc.shoulderLength,
              customizationBloc.shoulderLengthChanged),
          buildTextFields(
              width,
              "Arm Hole",
              customizationBloc.armHoleLength,
              customizationBloc.armHoleChanged),
          buildTextFields(width, "Bust", customizationBloc.bustSize,
              customizationBloc.bustSizeChanged),
          buildTextFields(width, "Waist", customizationBloc.waist,
              customizationBloc.waistChanged),
          buildTextFields(width, "Hips", customizationBloc.hips,
              customizationBloc.hipsChanged),
          buildTextFields(
              width,
              "Sleeve Length",
              customizationBloc.sleeveLength,
              customizationBloc.sleeveLengthChanged),
          buildTextFields(width, "Biceps", customizationBloc.biceps,
              customizationBloc.bicepsChanged),
          buildTextFields(
              width,
              "Your Height",
              customizationBloc.yourHeightLength,
              customizationBloc.yourHeightChanged),
          buildTextFields(
              width,
              "Front Neck Depth",
              customizationBloc.frontNeck,
              customizationBloc.frontNeckChanged),
          buildTextFields(
              width,
              "Back Neck Depth",
              customizationBloc.backNeckDepth,
              customizationBloc.backNeckDepthChanged),
          buildTextFields(
              width,
              "Kurta Length",
              customizationBloc.kurtaLength,
              customizationBloc.kurtaLengthChanged),
          buildTextFields(
              width,
              "Bottom Length",
              customizationBloc.bottomLength,
              customizationBloc.bottomLengthChanged),
        ],
      ),
    );
  }

  Widget menMeasurements(double width) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GridView.count(
        childAspectRatio: 3 / 2,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 40,
        children: [
          buildTextFields(
              width,
              "Shoulder",
              customizationBloc.shoulderLength,
              customizationBloc.shoulderLengthChanged),
          buildTextFields(
              width,
              "Chest",
              customizationBloc.chest,
              customizationBloc.chestChanged),
          buildTextFields(width, "Front Shoulder To Waist", customizationBloc.frontShoulderToWaist,
              customizationBloc.frontShoulderToWaistChanged),
          buildTextFields(width, "Waist", customizationBloc.waist,
              customizationBloc.waistChanged),
          buildTextFields(width, "Arm Length", customizationBloc.armLength,
              customizationBloc.armLengthChanged),
          buildTextFields(
              width,
              "Hip",
              customizationBloc.hips,
              customizationBloc.hipsChanged),
          buildTextFields(width, "Crotch", customizationBloc.crotchDepth,
              customizationBloc.crotchDepthChanged),
          buildTextFields(
              width,
              "Waist To Knee",
              customizationBloc.waistToKnee,
              customizationBloc.waistToKneeChanged),
          buildTextFields(
              width,
              "Knee Line",
              customizationBloc.kneeLine,
              customizationBloc.kneeLineChanged),
          buildTextFields(
              width,
              "Neck Circumference",
              customizationBloc.neckCircumference,
              customizationBloc.neckCircumferenceChanged),
          buildTextFields(
              width,
              "Nape To Waist",
              customizationBloc.napeToWaist,
              customizationBloc.napeToWaistChanged),
          buildTextFields(
              width,
              "Back Width",
              customizationBloc.backWidth,
              customizationBloc.backWidthChanged),
          buildTextFields(
              width,
              "Top Arm Circumference",
              customizationBloc.topArmCircumference,
              customizationBloc.topArmCircumferenceChanged),
          buildTextFields(
              width,
              "Waist To Floor",
              customizationBloc.waistToFloor,
              customizationBloc.waistToFloorChanged),
        ],
      ),
    );
  }

  Container buildTextFields(double width, String text, Stream<String> stream,
      Function(String) onChanged) {
    return Container(
      width: width * 0.33,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 05, left: 3),
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontFamily: "Helvetica"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: StreamBuilder<String>(
                stream: stream,
                builder: (context, snapshot) {
                  return Container(
                    height: snapshot.error!=null?MediaQuery.of(context).size.height * 0.08:MediaQuery.of(context).size.height * 0.06,
                    child: TextFormField(
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                          counterText: "",
                          errorText: snapshot.error,
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),

                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder:OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          )
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
