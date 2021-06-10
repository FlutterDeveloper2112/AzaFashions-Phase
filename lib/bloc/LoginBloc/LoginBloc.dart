import 'dart:async';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/validator/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Object with Validators {
  BuildContext context;
  CustomBottomSheet _bottomSheet = new CustomBottomSheet();

  final _repository = LoginRepo();
  var _loginfetcher = BehaviorSubject<UserLogin>();
  var _emailController = BehaviorSubject<String>();
  var _passwordController = BehaviorSubject<String>();
  var _logoutFetcher = BehaviorSubject<ResponseMessage>();
  var _guestFetcher = BehaviorSubject<bool>();


  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController.sink.add;

  Stream<ResponseMessage> get fetchLogout => _logoutFetcher.stream;
  Stream<bool> get fetchGuest => _guestFetcher.stream;
  Stream<String> get email => _emailController.stream.transform(emailValidator);
  Stream<String> get password => _passwordController.stream.transform(passwordValidator);
  Stream<bool> get loginCheck => Rx.combineLatest2(email, password, (e, p) => true);
  Stream<UserLogin> get fetchAllData => _loginfetcher.stream;


  validateBeforeSubmitting(BuildContext context)async{
    if( _emailController.value==null && _passwordController.value==null ){
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your details."),
        duration: Duration(seconds: 1),
      ));

      return false;
    }
    else {
      if (_emailController.value == null || _emailController.value.isEmpty  ) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your email address."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (_passwordController.value == null || _passwordController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your password."),
          duration: Duration(seconds: 1),
        ));
        return false;
      }

      else{
        return true;
      }
    }

  }

  fetchAllLoginData(String userEmail,String userPassword,bool rememberMe) async {
    SessionDetails sessionDetails = SessionDetails();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("Remember $rememberMe");
    print("${_emailController.value} ${_passwordController.value}");
    if(rememberMe==true && rememberMe!=null){
      sessionDetails.saveLoginDetails(_emailController.value!=null? _emailController.value :userEmail, _passwordController.value!=null?_passwordController.value:userPassword, rememberMe);
    }
    else{
      sharedPreferences.remove("UserEmail");
      sharedPreferences.remove("UserPassword");
      sharedPreferences.remove("Remember");
      sharedPreferences.commit();
    }

    UserLogin itemModel = await _repository.geLoginCredentialsRepo(_emailController.value!=null? _emailController.value :userEmail, _passwordController.value!=null?_passwordController.value:userPassword);
    _loginfetcher.sink.add(itemModel);
    return itemModel;
  }

  Future<bool> getLoginDetails(BuildContext context,String screeName ) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    bool loggedIn = _sharedPreferences.getBool("browseAsGuest");
    int counter =_sharedPreferences.getInt("guestCounter");
   if (loggedIn == true && counter>1) {
        _bottomSheet.getLoginBottomSheet(context);
    } else {}
    return loggedIn;
  }

  getGuestDetails(BuildContext context) async {
    SessionDetails sessionDetails = new SessionDetails();
    sessionDetails.clearGuestData();
  }

  Future<ResponseMessage> getLogout(BuildContext context) async{
    ResponseMessage logoutStatus = await _repository.logoutRepo(context);
    _logoutFetcher.sink.add(logoutStatus);
    return logoutStatus;
  }


  void clearData() async {
    _guestFetcher.close();
    _emailController.close();
    _emailController = BehaviorSubject<String>();
    _loginfetcher.close();
    _loginfetcher = BehaviorSubject<UserLogin>();
    _passwordController.close();
    _passwordController = BehaviorSubject<String>();

  }
}

final loginBloc = LoginBloc();
