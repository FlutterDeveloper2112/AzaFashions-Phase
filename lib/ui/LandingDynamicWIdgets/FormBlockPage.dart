
import 'package:azaFashions/bloc/LandingPagesBloc/LandingPageData.dart';
import 'package:azaFashions/models/LandingPages/FormBlock.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormBlockPage extends StatefulWidget {
  FormBlock blockItem;
  String tag;

  FormBlockPage({this.blockItem, this.tag});

  @override
  ItemDesignState createState() => ItemDesignState();
}

class ItemDesignState extends State<FormBlockPage> {
  String email = "";
  String mobile = "";
  String msg = "";

  final TextEditingController _controller = TextEditingController();

  int count = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Stack(alignment: Alignment.center, children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(widget.blockItem.image),
                  //Can use CachedNetworkImage
                ),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0))),
          ),
        ),
        Positioned(
            bottom: -15,
            left: 30,
            right: 30,
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
              child: Column(children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                  child: Text(
                    "${widget.blockItem.heading}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                        fontFamily: "PlayfairDisplay",
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15),
                  child: Text(
                    "${widget.blockItem.sub_heading}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Helvetica",
                        color: Colors.black45),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: count == 2 ? 60 : 40,
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            // onChanged: regisBloc.emailChanged,
                            validator: (String value) {
                              if (count == 0) {
                                return validateEmail(value);
                              } else if (count == 1) {
                                return validateMobile(value);
                              } else {
                                return validateMessage(value);
                              }
                            },

                            maxLength: count == 1 ? 10 : 100,
                            controller: _controller,
                            keyboardType: count == 1
                                ? TextInputType.number
                                : TextInputType.emailAddress,
                            decoration: InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.all(3),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 1.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black26, width: 1.0),
                              ),
                              hintText: count == 0
                                  ? 'Your Email ID'
                                  : count == 1
                                  ? "Enter Mobile Number"
                                  : count == 2
                                  ? "Enter Message"
                                  : "",
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                              ),
                              suffixIcon: Container(
                                color: Colors.grey[400],
                                child: new IconButton(
                                    icon: new Icon(
                                      Icons.arrow_forward,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (_formKey.currentState.validate()) {
                                        if (count == 0) {
                                          email = _controller.text;
                                        } else if (count == 1) {
                                          mobile = _controller.text;
                                        } else {
                                          msg = _controller.text;
                                        }
                                        if (count >= 2) {
                                          print(email);
                                          print(mobile);
                                          print(msg);
                                          landingPageData.fetchWeddingData(
                                              email,
                                              mobile,
                                              msg,
                                              widget.blockItem.action_url);
                                          landingPageData.weddingDetail
                                              .listen((event) {
                                                if(event.error.isNotEmpty){
                                                  Scaffold.of(context).showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              "${event.error}")));
                                                }
                                                else{
                                                  Scaffold.of(context).showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              "Consultant will get in touch with you")));
                                                }

                                          });

                                          setState(() {
                                            _controller.clear();
                                            count = 0;
                                          });
                                        } else {
                                          setState(() {
                                            count++;
                                            _controller.clear();
                                          });
                                        }
                                      } else {}
                                    }),
                              ),
                            ),
                          ),
                        ))),
              ]),
            ))
      ])
    ]);
  }

  validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null) {
      return Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Enter a valid email address',
          )));
      return;
    } else {
      return null;
    }
  }

  validateMobile(String value) {
    if (value.length == 10 &&
        (value.startsWith("9") ||
            value.startsWith("8") ||
            value.startsWith("7"))) {
      return null;
    } else {
      return Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Enter a valid Mobile number')));
      return;
    }
  }

  validateMessage(String value) {
    if (value.isEmpty || value.length == 0) {
      return Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Enter a valid Message')));
      return;
    } else {
      return null;
    }
  }
}
