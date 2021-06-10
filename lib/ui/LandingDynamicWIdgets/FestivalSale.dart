import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FestivalSale extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String heading, sub_heading, start_timestamp, end_timestamp;

  FestivalSale(
      this.heading, this.sub_heading, this.start_timestamp, this.end_timestamp);

  @override
  _FestivalSaleState createState() => _FestivalSaleState();
}

class _FestivalSaleState extends State<FestivalSale> {
  Duration diff;

  int hrs, min, sec;
  Timer _timer;
  int _start = 10;


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

        print("TIMER $_start");
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

    ///TimeStamp from API
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
          width: double.infinity,
          height: 115,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 12, color: Colors.grey[300]),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "FESTIVAL OF COLORS",
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                        ),
                      ),
                      Text(
                        "SALE ENDS IN",
                        style: TextStyle(
                            fontFamily: 'PlayFairDisplay',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
          )),
    );
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
}
