import 'package:azaFashions/models/Listing/FilterModel.dart';
import 'package:azaFashions/ui/Filter/MyFilter.dart';
import 'package:flutter/material.dart';

class PriceRange extends StatefulWidget {
  double min, max;
  String id;
  static List<FilterModel> selectedPrice = List<FilterModel>();

  PriceRange({this.min, this.max, this.id});

  @override
  _PriceRangeState createState() => _PriceRangeState();
}

class _PriceRangeState extends State<PriceRange> {
  RangeValues gradesRange;
  CircleThumbShape circleThumbShape = CircleThumbShape(thumbRadius: 10.0);

  @override
  void initState() {
    gradesRange = RangeValues(widget.min, widget.max);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              "Select Price Range",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  fontFamily: "Helvetica",
                  color: Colors.black),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                    width: width * 0.3,
                    height: 25,
                    child: IntrinsicWidth(
                      child: TextField(
                        textAlign: TextAlign.left,
                        enabled: false,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          enabled: false,
                          // contentPadding: EdgeInsets.only(left: 35),
                          border: new OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(0)),
                              borderSide: new BorderSide(
                                  color: Colors.black54,
                                  style: BorderStyle.solid)),
                          labelStyle:
                          TextStyle(color: Colors.black, fontSize: 14),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "\u20B9 ${gradesRange.start.round()}",
                        ),
                      ),
                    )),
                Container(
                    width: width * 0.3,
                    height: 25,
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        // contentPadding: EdgeInsets.only(left: 25),
                        border: new OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            borderSide: new BorderSide(color: Colors.black54)),
                        labelStyle:
                        TextStyle(color: Colors.black, fontSize: 14),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "\u20B9 ${gradesRange.end.round()}",
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xff000000),
                  inactiveTrackColor: Colors.grey,
                  trackShape: RectangularSliderTrackShape(),
                  trackHeight: 1.5,
                  thumbColor: Colors.black,
                  activeTickMarkColor: Colors.black,
                  tickMarkShape: RoundSliderTickMarkShape(),
                  rangeThumbShape: circleThumbShape),
              child: RangeSlider(
                onChangeEnd: (RangeValues value) {
                  setState(() {
                    print("AJAY");
                  });
                },
                min: widget.min,
                max: widget.max,
                divisions: 10,
                labels:
                RangeLabels(gradesRange.start.round().toString(), gradesRange.end.round().toString()),
                values: gradesRange,
                onChanged: (RangeValues value) {
                  setState(() {
                    gradesRange = value;
                    print("gradesRange:$gradesRange");
                    PriceRange.selectedPrice.clear();

                    PriceRange.selectedPrice.add(FilterModel(widget.id,
                        "${gradesRange.start.round()}-${gradesRange.end.round()}"));
                    // PriceRange.selectedPrice = [FilterModel(widget.id,
                    //     "${gradesRange.start.round()},${gradesRange.end.round()}")];
                    // if (PriceRange.selectedPrice.length > 0) {
                    //   for (int i = 0;
                    //       i < PriceRange.selectedPrice.length;
                    //       i++) {
                    //     if (PriceRange.selectedPrice[i].parent_id ==
                    //         widget.id) {
                    //       PriceRange.selectedPrice[i].selectedValue = PriceRange
                    //               .selectedPrice[i].selectedValue
                    //               .trimRight() +
                    //           "," +
                    //           "${gradesRange.start.round()},${gradesRange.end.round()}";
                    //     }
                    //   }
                    // } else {
                    //
                    //
                    //   // PriceRange.selectedPrice.add(FilterModel(widget.id,
                    //   //     "${gradesRange.start.round()},${gradesRange.end.round()}"));
                    // }
                  });
                  updateTheData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateTheData() {
    setState(() {
      if(PriceRange.selectedPrice!=null && PriceRange.selectedPrice.length>0){
        setState(() {
          final index =  MyFilter.filterModel.indexWhere((element) => element.parent_id == PriceRange.selectedPrice.first.parent_id);
          print("INDEX VALUE: $index");
          if(index!=-1 ){
            MyFilter.filterModel[index].selectedValue = PriceRange.selectedPrice[0].selectedValue;
          }
          else{
            MyFilter.filterModel.addAll(PriceRange.selectedPrice);
          }
        });
        PriceRange.selectedPrice.clear();
      }

    });
  }
}

class CircleThumbShape extends RangeSliderThumbShape {
  final double thumbRadius;

  const CircleThumbShape({
    this.thumbRadius = 6.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
        Animation<double> enableAnimation,
        bool isDiscrete,
        bool isEnabled,
        bool isOnTop,
        TextDirection textDirection,
        SliderThemeData sliderTheme,
        Thumb thumb,
        bool isPressed}) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);
  }
}
