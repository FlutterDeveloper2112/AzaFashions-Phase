import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hexcolor/hexcolor.dart';

class LuxurySale extends StatefulWidget {
  String heading, sub_heading, start_timestamp, end_timestamp;

  LuxurySale(this.heading, this.sub_heading, this.start_timestamp, this.end_timestamp);

  @override
  _LuxurySaleState createState() => _LuxurySaleState();
}

class _LuxurySaleState extends State<LuxurySale> {
  Duration diff;

  int hrs, min, sec;
  Timer _timer;


  startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (hrs == 0 && min == 0 && sec == 0) {
          _timer.cancel();
        }
        else{
          if (sec < 1) {
            if (mounted) {
              setState(() {
                sec = 59;
                if (min < 1 && hrs != 0) {
                  hrs--;
                  min = 59;
                } else {
                  min--;
                }
              });
            }
          } else {
            if (mounted) {
              setState(() {
                sec--;
              });
            }
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    DateTime today = DateTime.now();
    DateTime parseDate = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.end_timestamp)*1000);
    Duration difference = parseDate.difference(today);

    hrs = difference.inHours;
    min = difference.inMinutes.remainder(60);
    sec = difference.inSeconds.remainder(60);

    print(widget.end_timestamp);
    print(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.end_timestamp)*1000));

    if(mounted){
      startTimer();

    }

    super.initState();
  }

  Column timerSale(String time, String hours) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            width: 40,
            color: Colors.grey[300],
            child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                      color: const Color(0xaaad2810),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ),
        Text(
          hours,
          style: TextStyle(color: const Color(0x99999999), fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 12, color: Colors.grey[300]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(right: 15.0, left: 10),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ),
                  Text(
                    "Big Luxury Sale",
                    style: TextStyle(
                        fontFamily: "PlayfairDisplay", fontSize: 20,fontStyle: FontStyle.italic),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, right: 10),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 5),
                    child: Text(
                      "ENDS IN",
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                  Wrap(
                    children: [
                      timerSale("$hrs", "Hours"),
                      timerSale("$min", "Minutes"),
                      timerSale("$sec", "Seconds"),
                    ],
                  )
                ],
              )
            ],
          )),

    );
  }

  Column timer(String time, String hours) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 43,
            width: 41,
            color: HexColor("#ededed"),
            child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                      color: HexColor("#ad2810"),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ),
        Text(
          hours,
          style: TextStyle(color:  HexColor("#ededed"), fontSize: 12,
            fontFamily: 'Helvetica',),
        )
      ],
    );
  }


}
