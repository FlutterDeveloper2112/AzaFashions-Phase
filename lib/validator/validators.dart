import 'dart:async';
import 'package:azaFashions/bloc/LoginBloc/RegisterationBloc.dart';
import 'package:azaFashions/models/Login/IntroModelList.dart';


mixin Validators{

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
          if (password.length > 7 && password.length <= 14) {
            print("PASSWORD:$password");
            sink.add(password);
          }
          else {
            sink.addError('Incorrect Password');
          }
        }


  );


  var emailValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink) {
        print("SINK value :$email");
        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (regex.hasMatch(email)) {
          print("EMAIL:$email");
          sink.add(email);
        }
        else {
          sink.addError('Enter Valid Email');
        }
      }
  );


  var nameValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink) {
        if (name.length > 2) {
          sink.add(name);
        }
        else {
          sink.addError('Invalid Name');
        }
      }
  );
  var lastnameValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (name, sink) {
        if (name.length > 2) {
          sink.add(name);
        }
        else {
          sink.addError('Invalid LastName');
        }
      }
  );

  var dobValidator =
  StreamTransformer<String, String>.fromHandlers(handleData: (dob, sink) {
    print("validator called");
    if(dob!=null){
      print("IF called");
      bool val  = regisBloc.validateDOB(dob);
      print(val);
      if(val){
        sink.add(dob);
      }
      else{
        sink.addError("Invalid Date Of Birth");
      }
    }
  });

  var cityValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (city, sink) {
        if (city.length > 3) {
          sink.add(city);
        }
        else {
          sink.addError('Invalid Name');
        }
      }
  );
  var postalCodeValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (postalCode, sink) {
        if (IntroModelList.currency_iso_code=="INR"?postalCode.length==6:postalCode.length >=4) {
          sink.add(postalCode);
        }
        else {
          sink.addError('Invalid Pincode');
        }
      }
  );
  var  addressValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (address, sink) {
        if (address.length > 5) {
          sink.add(address);
        }
        else {
          sink.addError('Invalid Address');
        }
      }
  );


  var mobileValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (mobile, sink) {
        if (mobile.length == 10 && (mobile.startsWith("9") || mobile.startsWith("8") || mobile.startsWith("7"))) {
          sink.add(mobile);
        }
        else {
          sink.addError('Invalid Mobile Number');
        }
      }
  );

  var regisPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        Pattern upper = r'(?=.*?[A-Z])', number = r'(?=.*?[0-9])', specialcharacter = r'(?=.*?[!@#\$&*~])';

        if (password.length > 0 && password!="" && password!=null && password.length > 7 && password.length <= 14) {
          /*sink.add(password);*/

          if (RegExp(upper).hasMatch(password)) {
            regisBloc.upperValidate = true;
          }
          if (RegExp(specialcharacter).hasMatch(password)) {
            regisBloc.specialValidate = true;
          }
          if (RegExp(number).hasMatch(password)) {
            regisBloc.numericValidate = true;
          }
          if (password.length > 7 && password.length <= 14) {
            regisBloc.lengthValidate = true;
          }
          if (regisBloc.upperValidate == true &&
              regisBloc.lengthValidate == true &&
              regisBloc.numericValidate == true &&
              regisBloc.specialValidate == true) {
            sink.add(password);
          }
        }

      else{
          regisBloc.upperValidate =false;
          regisBloc.numericValidate =false;
          regisBloc.lengthValidate =false;
          regisBloc.specialValidate =false;
          sink.addError("Please ensure password meets all the prerequisites .");
       }
  }
  );

}