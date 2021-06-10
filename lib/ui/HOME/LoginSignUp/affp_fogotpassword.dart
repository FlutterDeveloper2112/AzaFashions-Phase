
import 'dart:io';

import 'package:azaFashions/bloc/LoginBloc/ForgetPassBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HOME/LoginSignUp/afsi_signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
ForgetPassBloc forgetPass_Bloc = ForgetPassBloc();
final scaffoldKey = GlobalKey<ScaffoldState>();

var connectionStatus;
final connectivity=new ConnectivityService();
FirebaseAnalytics analytics = FirebaseAnalytics();
@override
  void initState() {
  analytics.setCurrentScreen(screenName: "Forget Password");
  // ignore: unnecessary_statements
  connectivity.connectionStatusController;
  WebEngagePlugin.trackScreen("Forget Password Screen");
  // TODO: implement initState
    super.initState();
  }

@override
void dispose() {
  connectivity.dispose();
  forgetPass_Bloc.dispose();
  // TODO: implement dispose
  super.dispose();
}
@override
  Widget build(BuildContext context) {
  connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
  return MediaQuery(
    data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        // resizeToAvoidBottomPadding : false,
        body: Column(
          mainAxisSize: MainAxisSize.max,

            children: <Widget>[
             upperHalf(context),

            Expanded(
              child:    middlehalf(context),

            )
            ],
          ),
        ),
  );
  }


  Widget upperHalf(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15,top:15),
          child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child:InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Platform.isAndroid?Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 18,
                    ):Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 18,
                    ),
                  ))),
        ),
        Container(
            height: 100,
            padding: EdgeInsets.only(top:15,left: 25),
            child: Align(
              alignment: Alignment.center,
              child:Text("Forgot Password",textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.normal,fontSize:22,fontFamily: "PlayfairDisplay",color: Colors.black),),
            )
        )
      ],
    );
  }


  Widget middlehalf(BuildContext context) {
    return Container(
      width:double.infinity ,
      child: Column(
        children: <Widget>[

        Form(
              child: formUI(context)
        )
        ],
      ),
    );
  }



 Widget formUI(BuildContext context) {

    return Column(
      children: <Widget>[
        //Description
        Padding(
            padding: EdgeInsets.only(left: 25,right: 25,bottom: 20),
            child:Container (
                padding: const EdgeInsets.only(top:10.0),
                width: double.infinity,
                child: new Text("Enter the email address you used to create your account and we will email you a link to reset your password",textAlign:TextAlign.left,style: TextStyle(fontSize:16,fontFamily: "Helvetica",color: Colors.grey[500]),),

         )),

        //UsernameField
        Padding(
            padding: EdgeInsets.only(left: 25,right: 25,top:10),
            child:Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Text("Email ",textAlign:TextAlign.start,style: TextStyle(fontSize:16,fontFamily: "Helvetica",color: Colors.grey[500]),),
                  ),
                  StreamBuilder<String>(
                      stream: forgetPass_Bloc.email,
                      builder: (context,snapshot)=> TextFormField(
                        autocorrect: false,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                        errorText: snapshot.error),
                        onChanged: forgetPass_Bloc.emailChanged,
                        keyboardType: TextInputType.emailAddress,

                      )
                  )
                ])),


        //SignInButton
        Padding(
            padding: EdgeInsets.only(left:20,right: 20,top: 25),
            child:Container(
              color: Colors.grey[500],
              width: MediaQuery.of(context).size.width/1  ,
              height: 40,
              child:StreamBuilder(
                stream: forgetPass_Bloc.loginCheck,
                builder: (context,snapshot)=>RaisedButton(
                  onPressed: (){
                    FocusScope.of(context).requestFocus(FocusNode());
                    if(connectionStatus!=null && connectionStatus!="ConnectivityStatus.Offline"){
                      if(snapshot.hasData){
                        forgetPass_Bloc.forgetPassBloc();
                        forgetPass_Bloc.forgetPassFetcher.listen((value) {
                          if(value.error.isNotEmpty){
                            scaffoldKey.currentState.removeCurrentSnackBar();
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("${value.error}"),
                              duration: Duration(seconds: 1),
                            ));

                          }
                          else{
                            scaffoldKey.currentState.removeCurrentSnackBar();
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("${value.success}"),
                              duration: Duration(seconds: 1),
                            ));

                            Future.delayed(Duration(seconds: 2),(){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {return LoginPage();}));

                            });
                          }
                        });
                      }
                      else{
                        scaffoldKey.currentState.removeCurrentSnackBar();
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("Please Enter Your Email-Id"),
                          duration: Duration(seconds: 1),
                        ));
                      }
                    }
                    else{
                      scaffoldKey.currentState.removeCurrentSnackBar();
                      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No Internet Connection. Please Try Again.")));
                    }
                  },
                  child: Text('SUBMIT', textAlign:TextAlign.center,style: TextStyle(fontFamily: "Helvetica",fontWeight:FontWeight.normal,fontSize:16,color: Colors.black),),
                ),

              )

            )
        ),

      ],
    );
  }
}