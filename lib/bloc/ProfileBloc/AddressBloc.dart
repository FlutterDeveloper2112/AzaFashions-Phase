import 'dart:async';
import 'package:azaFashions/models/Profile/CountryList.dart';
import 'package:azaFashions/models/Profile/ProfileAddressList.dart';
import 'package:azaFashions/repository/ProfileRepo.dart';
import 'package:azaFashions/utils/ResponseMessage.dart';
import 'package:azaFashions/validator/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AddressBloc extends Object with Validators {
  BuildContext context;
  bool specialValidate = false,
      numericValidate = false,
      lengthValidate = false,
      upperValidate = false;

  final _repository = ProfileRepo();
  final _addressList = PublishSubject<ProfileAddressList>();
  final _addAddressList = PublishSubject<ResponseMessage>();
  final _removeAddressList = PublishSubject<ResponseMessage>();
  final _countryList = PublishSubject<CountryStateList>();
  final _stateList = PublishSubject<CountryStateList>();

  Stream<ResponseMessage> get addAddressFetchers => _addAddressList.stream;

  Stream<ResponseMessage> get removeAddressFetchers =>
      _removeAddressList.stream;

  var _firstNameController = BehaviorSubject<String>();
  var _lastNameController = BehaviorSubject<String>();
  var _emailController = BehaviorSubject<String>();
  var _mobileController = BehaviorSubject<String>();
  var _addressOneController = BehaviorSubject<String>();
  var _addressTwoController = BehaviorSubject<String>();
  var _cityController = BehaviorSubject<String>();
  var _postalCodeController = BehaviorSubject<String>();

  Function(String) get firstNameChanged => _firstNameController.sink.add;

  Function(String) get lastNameChanged => _lastNameController.sink.add;

  Function(String) get emailChanged => _emailController.sink.add;

  Function(String) get mobileChanged => _mobileController.sink.add;

  Function(String) get addressOneChanged => _addressOneController.sink.add;

  Function(String) get addressTwoChanged => _addressTwoController.sink.add;

  Function(String) get cityChanged => _cityController.sink.add;

  Function(String) get postalCodeChanged => _postalCodeController.sink.add;

  Stream<String> get firstName =>
      _firstNameController.stream.transform(nameValidator);

  Stream<String> get lastName =>
      _lastNameController.stream.transform(lastnameValidator);

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  Stream<String> get mobile =>
      _mobileController.stream.transform(mobileValidator);

  Stream<String> get addressOne =>
      _addressOneController.stream.transform(addressValidator);

  Stream<String> get addressTwo =>
      _addressTwoController.stream.transform(addressValidator);

  Stream<String> get city => _cityController.stream.transform(cityValidator);

  Stream<String> get postalCode =>
      _postalCodeController.stream.transform(postalCodeValidator);

  Stream<CountryStateList> get countries => _countryList.stream;

  Stream<CountryStateList> get states => _stateList.stream;

  Stream<bool> get checkAddress => Rx.combineLatest7(firstName, lastName, email,
      mobile, addressOne, city, postalCode, (a, b, c, d, e, f, g) => true);

  fetchAddAddress(String addressType, String selectAddType, String type,
      String state, String country, bool checkAddress) async {
    print("checkAddress : $checkAddress  $selectAddType");
    AddressModel addressModel = new AddressModel(

        type: selectAddType,
        selection_type: checkAddress == true
            ? "identical"
            : addressType == "Billing Address" ||
            addressType == "Shipping Address"
            ? addressType.split(" ")[0].toLowerCase()
            : "",
        //  selection_type_identical: addressType=="Billing Address" || addressType=="Shipping Address"?checkAddress:false,
        firstName: _firstNameController.value,
        lastName: _lastNameController.value,
        email: _emailController.value,
        mobileNo: _mobileController.value,
        addressOne: _addressOneController.value,
        postalCode: _postalCodeController.value,
        cityName: _cityController.value,
        stateName: state,
        countryName: country,
        isDefault: type == "Default" ? 1 : 0);
    ResponseMessage response =
    await _repository.getAddAddress(context, addressModel);
    _addAddressList.sink.add(response);
  }

  Stream<ProfileAddressList> get fetchAddressData => _addressList.stream;

  fetchAddressList(String addressType) async {
    ProfileAddressList itemModel =
    await _repository.getAddressListRepo(addressType);
    print("$itemModel");
    _addressList.sink.add(itemModel);
  }

  removeAddress(BuildContext context, int addressID) async {
    ResponseMessage response =
    await _repository.removeAddressRepo(context, addressID);
    _removeAddressList.sink.add(response);
  }

  updateAddress(String addressType, String type, String selectAddType,
      String state, String country, AddressModel model,bool checkAddress) async {
    AddressModel addressModel = new AddressModel(
        selection_type: checkAddress == true
            ? "identical"
            : addressType == "Billing Address" ||
            addressType == "Shipping Address"
            ? addressType.split(" ")[0].toLowerCase()
            : "",
        //  selection_type_identical: model.selection_type_identical!=false? model.selection_type_identical:false,
        type: selectAddType,
        firstName: _firstNameController.value != null
            ? _firstNameController.value
            : model.firstName,
        lastName: _lastNameController.value != null
            ? _lastNameController.value
            : model.lastName,
        email: _emailController.value != null
            ? _emailController.value
            : model.email,
        mobileNo: _mobileController.value != null
            ? _mobileController.value
            : model.mobileNo,
        addressOne: _addressOneController.value != null
            ? _addressOneController.value
            : model.addressOne,
        postalCode: _postalCodeController.value != null
            ? _postalCodeController.value
            : model.postalCode,
        cityName: _cityController.value != null
            ? _cityController.value
            : model.cityName,
        stateName: state,
        countryName: country,
        isDefault: type == "Default" ? 1 : 0);
    var response = await _repository.getUpdateAddress(
        context, model.addressId.toInt(), addressModel);

    _addAddressList.sink.add(response);
  }

  fetchCountry() async {
    CountryStateList countryList =
    await _repository.getCountryList(context, 0, "country");
    _countryList.sink.add(countryList);
    print(countryList);
  }

  fetchState(int id) async {
    CountryStateList countryList =
    await _repository.getCountryList(context, id, "state");
    _stateList.sink.add(countryList);
  }

  void clearControllerData() async {
    _firstNameController = BehaviorSubject<String>();
    _lastNameController = BehaviorSubject<String>();
    _emailController = BehaviorSubject<String>();
    _mobileController = BehaviorSubject<String>();
    _addressOneController = BehaviorSubject<String>();
    _addressTwoController = BehaviorSubject<String>();
    _cityController = BehaviorSubject<String>();
    _postalCodeController = BehaviorSubject<String>();

    await _firstNameController.drain();
    await _lastNameController.drain();
    await _emailController.drain();
    await _mobileController.drain();
    await _addressOneController.drain();
    await _addressTwoController.drain();
    await _cityController.drain();
    await _postalCodeController.drain();
    await _countryList.drain();
    await _stateList.drain();
  }

  validateBeforeSubmitting(BuildContext context, String country, String state,
      String selectType, String selectAddType) async {
    if (selectType==null &&
        selectAddType==null &&
        country==null &&
        state==null &&
        _firstNameController.value == null &&
        _lastNameController.value == null &&
        _emailController.value == null &&
        _mobileController.value == null &&
        _addressOneController.value == null &&
        _cityController.value == null &&
        _postalCodeController.value == null) {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please enter your details."),
        duration: Duration(seconds: 1),
      ));

      return false;
    } else {
      if (selectType == null || selectType.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Address Type."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (selectAddType == null || selectAddType.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Your Save Address Type."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (_firstNameController.value == null ||
          _firstNameController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter your First Name."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }

      if (_lastNameController.value == null ||
          _lastNameController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter your Last Name."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (_emailController.value == null || _emailController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter your email address."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (_mobileController.value == null || _mobileController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter your Mobile Number."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (_addressOneController.value == null ||
          _addressOneController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please enter Address Line 1."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (country == null || country.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Your Country."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }

      if (_cityController.value == null) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter Your City."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (state == null || state.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Select Your State."),
          duration: Duration(seconds: 1),
        ));

        return false;
      }
      if (_postalCodeController.value == null ||
          _postalCodeController.value.isEmpty) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Please Enter Your Zip Code."),
          duration: Duration(seconds: 1),
        ));

        return false;
      } else {
        return true;
      }
    }
  }
}

final addressBloc = AddressBloc();
