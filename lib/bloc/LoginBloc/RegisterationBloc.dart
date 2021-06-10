import 'dart:async';
import 'package:azaFashions/models/Login/Registration.dart';
import 'package:azaFashions/models/Login/UserLogin.dart';
import 'package:azaFashions/repository/LoginRepo.dart';
import 'package:azaFashions/repository/ProfileRepo.dart';
import 'package:azaFashions/validator/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class RegisBloc extends Object with Validators {
  bool specialValidate = false,
      numericValidate = false,
      lengthValidate = false,
      upperValidate = false;

  BuildContext context;
  final _repository = LoginRepo();
  final _profilerepository = ProfileRepo();

  var _regisfetcher = BehaviorSubject<UserLogin>();
  var _passwordFetcher = BehaviorSubject<UserLogin>();
  var _updateAccount = BehaviorSubject<UserLogin>();

  var _mobileController = BehaviorSubject<String>();
  var _nameController = BehaviorSubject<String>();
  var _lastNameController = BehaviorSubject<String>();
  var _emailController = BehaviorSubject<String>();
  var _dob = BehaviorSubject<String>();
  var _gender = BehaviorSubject<String>();
  var _oldPasswordController = BehaviorSubject<String>();
  var _newPasswordController = BehaviorSubject<String>();
  var _confirmPasswordController = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;

  Function(String) get oldPasswordChanged => _oldPasswordController.sink.add;

  Function(String) get newPasswordChanged => _newPasswordController.sink.add;

  Function(String) get confirmPasswordChanged => _confirmPasswordController.sink.add;

  Function(String) get nameChanged => _nameController.sink.add;

  Function(String) get lastNameChanged => _lastNameController.sink.add;

  Function(String) get dob => _dob.sink.add;

  Function(String) get gender => _gender.sink.add;

  Function(String) get mobileChanged => _mobileController.sink.add;

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  Stream<String> get oldPassword => _oldPasswordController.stream.transform(passwordValidator);

  Stream<String> get newPassword => _newPasswordController.stream.transform(regisPassword);

  Stream<String> get confirmPassword => _confirmPasswordController.stream.transform(passwordValidator);

  Stream<String> get name => _nameController.stream.transform(nameValidator);

  Stream<String> get lastName => _lastNameController.stream.transform(lastnameValidator);

  Stream<String> get dateOfBirth => _dob.stream.transform(dobValidator);

  Stream<String> get userGender => _gender.stream;

  Stream<String> get mobile => _mobileController.stream.transform(mobileValidator);

  Stream<bool> get loginCheck =>
      Rx.combineLatest3(email, newPassword, name, (a, b, c) => true);

  Stream<bool> get passwordCheck =>
      Rx.combineLatest2(oldPassword, newPassword, (a, b) => true);

  Stream<UserLogin> get fetchAllData => _regisfetcher.stream;

  Stream<UserLogin> get fetchPassword => _passwordFetcher.stream;

  Stream<UserLogin> get fetchAccountData=> _updateAccount.stream;

  Stream<bool> get detailsCheck => Rx.combineLatest6(name, lastName, mobile, email, dateOfBirth, userGender, (a, b, c, d, e, f) => true);


  validateBeforeSubmitting(BuildContext context,bool mobile)async{
    if(_nameController.value==null && /*_lastNameController.value==null &&*/ _emailController.value==null && _newPasswordController.value==null && mobile==false){
      Scaffold.of(context).removeCurrentSnackBar();
     Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your details."),
        duration: Duration(seconds: 1),
      ));

      return false;
    }
    else {
      if (_nameController.value == null || _nameController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your name."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
     /* if (_lastNameController.value == null || _lastNameController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your last name."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
*/
      if (_emailController.value == null || _emailController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your email address."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (_newPasswordController.value == null || _newPasswordController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your password."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }if (_confirmPasswordController.value == null || _confirmPasswordController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter confirm password."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (mobile==false) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your mobile number."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }

      if (_newPasswordController.value.compareTo(_confirmPasswordController.value) != 0) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Password and Confirm Password does not match"),
          duration: Duration(seconds: 1),
        ));

        return false;
      }

      else{
        return true;
      }
    }

  }
  changePassword(BuildContext context) async {
    if (_newPasswordController.value.compareTo(_confirmPasswordController.value) != 0) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("New Password & Confirmed Password Does not Match"),
        duration: Duration(seconds: 1),
      ));
      return;
    }

    UserLogin res = await _profilerepository.passwordChange(_oldPasswordController.value, _newPasswordController.value);
    _passwordFetcher.sink.add(res);
  }

  updateUserDetails(UserLogin login) async {
    UserLogin user = UserLogin(
        firstname: _nameController?.value ?? login.firstname,
        lastname: _lastNameController?.value ?? login.lastname,
        email: _emailController?.value ?? login.email,
        mobile: _mobileController?.value ?? login.mobile,
        dob: _dob?.value ?? login.dob,
        gender: _gender?.value ?? login.gender);
    print(user.dob);
    var resp = await _profilerepository.updateAccountDetails( user);
    print(resp);
    _updateAccount.sink.add(resp);
  }

  fetchAllRegisData(String mobile) async {
    Registration registration = new Registration(
        email: _emailController.value,
        password: _newPasswordController.value,
        name: _nameController.value,
        mobile: mobile,
        dob: "",
        gender: 2,
        referrer: "");
    UserLogin itemModel =
    await _repository.geRegisCredentialsRepo(registration);
    _regisfetcher.sink.add(itemModel);
  }
  clearRegisterStream(){
    _regisfetcher.close();
    _regisfetcher = BehaviorSubject<UserLogin>();
  }
  clearAccountStream(){
    _updateAccount.close();
    _updateAccount = BehaviorSubject<UserLogin>();
  }

  clearData() {
    _regisfetcher.close();
    specialValidate = false;
    numericValidate = false;
    lengthValidate = false;
    upperValidate = false;
    _emailController.close();
    _emailController=BehaviorSubject<String>();
    _oldPasswordController.close();
    _oldPasswordController=BehaviorSubject<String>();
    _newPasswordController.close();
    _newPasswordController=BehaviorSubject<String>();
    _confirmPasswordController.close();
    _confirmPasswordController=BehaviorSubject<String>();
    _nameController.close();
    _nameController=BehaviorSubject<String>();
    _lastNameController.close();
    _lastNameController=BehaviorSubject<String>();
    _mobileController.close();
    _mobileController=BehaviorSubject<String>();
    _passwordFetcher.close();
    _passwordFetcher=BehaviorSubject<UserLogin>();
    _dob.close();
    _dob=BehaviorSubject<String>();
    _gender.close();
    _gender=BehaviorSubject<String>();
    _updateAccount.close();
    _updateAccount=BehaviorSubject<UserLogin>();
  }

  bool validateDOB(String dob) {

    try{
      int day, month, year;
      String date = dob;
      String separator = RegExp("([-])").firstMatch(date).group(0)[0];
      String format = "YYYY-MM-DD";
      var frSplit = format.split(separator);
       var dtSplit = date.split(separator);
      for (int i = 0; i < frSplit.length; i++) {

        var frm = frSplit[i].toLowerCase();

        var vl = dtSplit[i];

        if(vl==""){
          return false;
        }
        if (frm == "dd")
          day = int.parse(vl);
        else if (frm == "mm")
          month = int.parse(vl);
        else if (frm == "yyyy") year = int.parse(vl);
      }

      if (month > 12 ||
          month < 1 ||
          day < 1 ||
          day > daysInMonth(month, year) ||
          year < 1810 ||
          year > DateTime.now().year) {

        return false;
      }

      return true;
    }
    catch(e){
      return false;
    }
  }

  static int daysInMonth(int month, int year) {
    int days = 28 +
        (month + (month / 8).floor()) % 2 +
        2 % month +
        2 * (1 / month).floor();
    return (isLeapYear(year) && month == 2) ? 29 : days;
  }

  static bool isLeapYear(int year) =>
      ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
}

final regisBloc = RegisBloc();

