import 'package:azaFashions/bloc/ProfileBloc/AddressBloc.dart';
import 'package:azaFashions/enum/ConnectivityStatus.dart';
import 'package:azaFashions/models/Profile/CountryList.dart';
import 'package:azaFashions/models/Profile/ProfileAddressList.dart';
import 'package:azaFashions/services/ConnectivityService.dart';
import 'package:azaFashions/ui/HEADERS/AppBar/AppBarWidget.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/BillingAddress.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/MyAddress.dart';
import 'package:azaFashions/ui/PROFILE/ADDRESS/ShippingAddress.dart';
import 'package:azaFashions/ui/PROFILE/ProfileUI.dart';
import 'package:azaFashions/utils/CustomBottomSheet.dart';
import 'package:azaFashions/utils/ToastMsg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';


class AddAddress extends StatefulWidget {

  String addressType;
  String addressMode;
  AddressModel addressModel;

  AddAddress(this.addressMode, this.addressType, [this.addressModel]);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddress> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _country = ['India', 'America', 'USA', 'Japan'];

  // List<String> _state = ['Maharashtra', 'Andrapradesh', 'Telangana', 'Goa'];
  String _selectedCountry;
  String _selectedState;
  List<CountryState> country = [];

  CountryState selectedCountry = CountryState();

  TextEditingController controller = new TextEditingController();

  static bool checkedAddress = false;
  String selectAddType;
  String selectType;
  String otherAddress;


  List<DropdownMenuItem> items = [];
  List<CountryState> searchData = [];

  int id;
  String filter = "";
  bool editable = true;
  final connectivity=new ConnectivityService();
  var connectionStatus;



  @override
  void initState() {
    analytics.setCurrentScreen(screenName: "Add Address");
    setState(() {
      ProfileUI.isEdited = false;
    });
    if (widget.addressModel != null) {
      _selectedState = widget.addressModel.stateName;
      print(_selectedState);
      selectedCountry.name = widget.addressModel.countryName;
      if (widget.addressModel.isDefault == 1) {
        selectType = "Default";
      } else {
        selectType = "Other";
      }
      checkedAddress = widget.addressModel.selection_type == "identical" ? true : false;
      selectAddType = widget.addressModel.type=="Others"?"Other":widget.addressModel.type;
    } else {
      _selectedCountry = _country[0];
      checkedAddress = false;
    }
    if (widget.addressType == "Shipping Address") {
      otherAddress = "billing";
    } else if (widget.addressType == "Billing Address") {
      otherAddress = "shipping";
    }
    // ignore: unnecessary_statements
    connectivity.connectionStatusController;

    super.initState();
  }

  @override
  void dispose() {
    addressBloc.clearControllerData();
    connectivity.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print(widget.addressType);
    connectionStatus = Platform.isIOS?connectivity.checkConnectivity1():Provider.of<ConnectivityStatus>(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (ProfileUI.isEdited) {
          bool res = await CustomBottomSheet().saveChanges(context);
          if (res) {
            Navigator.of(context).pop();
          }
        }
        else{
          Navigator.of(context).pop();
        }
      },

      child:MediaQuery(
        data:  MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            key: scaffoldKey,
            appBar: AppBarWidget()
                .myAppBar(context, "${widget.addressType}", scaffoldKey),
            body: Column(children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: <Widget>[
                        formUI(context),
                        lowerHalf(context),
                      ]))),
            ])),
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Center(
      child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: Platform.isIOS?25:25,),
          child: Container(
              color: Colors.grey[400],
              width: MediaQuery.of(context).size.width / 1,
              height: 43,
              child: StreamBuilder<bool>(
                stream: addressBloc.checkAddress,
                builder: (context, snapshot) => RaisedButton(
                  onPressed: () async {
                    if(connectionStatus.toString()!="ConnectivityStatus.Offline"){
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (widget.addressMode == "EDIT") {
                        addressBloc.updateAddress(
                            widget.addressType,
                            selectType,
                            selectAddType=="Other"?"Others":selectAddType,
                            _selectedState,
                            selectedCountry.name,
                            widget.addressModel,checkedAddress);

                        addressBloc.addAddressFetchers.listen((event) {
                          if (event.error.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(event.success),
                              duration: Duration(seconds: 1),
                            ));
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context).pop(true);

                            });
                          } else {
                            ScaffoldMessenger.of(context).removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(event.error),
                              duration: Duration(seconds: 1),
                            ));
                          }
                        });
                      }
                      else if (widget.addressMode == "ADD") {
                        bool val = await addressBloc.validateBeforeSubmitting(context,selectedCountry.name,_selectedState,selectType,selectAddType);
                        print(val);
                        if (val) {
                          addressBloc.fetchAddAddress(
                              widget.addressType,
                              selectAddType=="Other"?"Others":selectAddType,
                              selectType,
                              _selectedState,
                              selectedCountry.name,
                              checkedAddress);

                          Navigator.of(context).pop(true);

                        }
                      }
                    }
                    else{
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("No Internet Connection!")));
                    }


                  },
                  child: Text(
                    (widget.addressMode == 'EDIT')
                        ? 'UPDATE ADDRESS'
                        : 'ADD ADDRESS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Helvetica",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ),
              ))),
    );
  }

  Widget formUI(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
            ),
            //AddressType
            Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 25, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Save Address Type As ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(children: <Widget>[
                    addaddressType(1, 'Default'),
                    addaddressType(0, 'Other'),
                  ]))
            ]),
            Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 25, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Save Address As ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(children: <Widget>[
                    addRadioButton(0, 'Home'),
                    addRadioButton(1, 'Office'),
                    addRadioButton(2, 'Other')
                  ]))
            ]),
            //Firstname
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "First Name ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  StreamBuilder<String>(
                      stream: addressBloc.firstName,
                      builder: (context, snapshot) => TextFormField(
                        key: Key(widget.addressModel != null
                            ? widget.addressModel.firstName
                            : null),
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                              RegExp(r"[a-zA-Z]+|\s"))
                        ],
                        textCapitalization: TextCapitalization.words,
                        initialValue: widget.addressModel != null
                            ? widget.addressModel.firstName
                            : null,
                        onChanged:(String val){
                          setState(() {
                            ProfileUI.isEdited = true;
                          });
                          addressBloc.firstNameChanged(val);
                        },
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: snapshot.error),
                      ))
                ])),
            //Lastname
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Last Name ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  StreamBuilder<String>(
                      initialData: widget.addressModel != null
                          ? widget.addressModel.lastName
                          : null,
                      stream: addressBloc.lastName,
                      builder: (context, snapshot) => TextFormField(
                        key: Key(
                          widget.addressModel != null
                              ? widget.addressModel.lastName
                              : null,
                        ),
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                              RegExp(r"[a-zA-Z]+|\s"))
                        ],
                        initialValue: widget.addressModel != null
                            ? widget.addressModel.lastName
                            : null,
                        onChanged: (String val){
                          setState(() {
                            ProfileUI.isEdited = true;
                          });
                          addressBloc.lastNameChanged(val);
                        },
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: snapshot.error),
                      ))
                ])),

            //Email
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  StreamBuilder<String>(
                      initialData: widget.addressModel != null
                          ? widget.addressModel.email
                          : null,
                      stream: addressBloc.email,
                      builder: (context, snapshot) => TextFormField(
                        key: Key(
                          widget.addressModel != null
                              ? widget.addressModel.email
                              : null,
                        ),
                        initialValue: widget.addressModel != null
                            ? widget.addressModel.email
                            : null,
                        onChanged: (String val){
                          setState(() {
                            ProfileUI.isEdited = true;
                          });
                          addressBloc.emailChanged(val);
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: snapshot.error),
                      ))
                ])),

            //MobileNoField
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Mobile No. ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  StreamBuilder<String>(
                      initialData: widget.addressModel != null
                          ? widget.addressModel.mobileNo
                          : null,
                      stream: addressBloc.mobile,
                      builder: (context, snapshot) {
                        return TextFormField(
                          key: Key(
                            widget.addressModel != null
                                ? widget.addressModel.mobileNo
                                : null,
                          ),
                          initialValue: widget.addressModel != null
                              ? widget.addressModel.mobileNo
                              : null,
                          maxLength: 10,
                          onChanged: (String val){
                            setState(() {
                              ProfileUI.isEdited = true;
                            });
                            addressBloc.mobileChanged(val);
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter(
                                RegExp(r"[0-9]"))
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counter: Offstage(),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorText: snapshot.error),
                        );
                      })
                ])),
            //Country
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Country",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      return showDialog(
                        builder: (BuildContext context) {
                          filter = "";
                          country.clear();
                          searchData.clear();
                          addressBloc.fetchCountry();
                          return Dialog(
                            child: StatefulBuilder(
                              builder: (context, StateSetter setState) {
                                return new Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Padding(
                                        padding: new EdgeInsets.only(
                                            top: 8.0, left: 16.0, right: 16.0),
                                        child: new TextField(
                                          onChanged: (String query) {
                                            // filterQuery(query, setState);
                                            setState(() {
                                              filter = query;
                                            });
                                          },
                                          style: new TextStyle(
                                              fontSize: 18.0, color: Colors.black),
                                          decoration: InputDecoration(
                                            prefixIcon: new Icon(Icons.search),
                                            suffixIcon: new IconButton(
                                              icon: new Icon(Icons.close),
                                              onPressed: () {
                                                controller.clear();
                                                Navigator.of(context,
                                                    rootNavigator: true)
                                                    .pop();
                                                // FocusScope.of(context).requestFocus(new FocusNode());
                                              },
                                            ),
                                            hintText: "Search...",
                                          ),
                                          // controller: controller,
                                        )),
                                    new Expanded(
                                      child: new Padding(
                                          padding: new EdgeInsets.only(top: 8.0),
                                          child: StreamBuilder<CountryStateList>(
                                              stream: addressBloc.countries,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.active) {
                                                  country.addAll(
                                                      snapshot.data.countryState);
                                                  searchData.isNotEmpty
                                                      ? searchData
                                                      : searchData.addAll(country);
                                                  return StatefulBuilder(
                                                    builder: (context,
                                                        StateSetter setState) =>
                                                        ListView.builder(
                                                            itemCount:
                                                            searchData.length,
                                                            itemBuilder:
                                                                (BuildContext
                                                            context,
                                                                int index) {
                                                              if (filter == null ||
                                                                  filter == "") {
                                                                return _buildCountryRow(
                                                                    searchData[
                                                                    index],
                                                                    context);
                                                              } else {
                                                                if (searchData[
                                                                index]
                                                                    .name
                                                                    .toLowerCase()
                                                                    .startsWith(filter
                                                                    .toLowerCase())) {
                                                                  return _buildCountryRow(
                                                                      searchData[
                                                                      index],
                                                                      context);
                                                                } else {
                                                                  return new Container();
                                                                }
                                                              }
                                                            }),
                                                  );
                                                } else {
                                                  return Center(
                                                    child:
                                                    CircularProgressIndicator(),
                                                  );
                                                }
                                              })),
                                    )
                                  ],
                                );
                              },
                            ),
                          );
                        },
                        barrierDismissible: true,
                        context: context,
                      );
                    },
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          enabled: false,
                          labelText:
                          selectedCountry == "" || selectedCountry == null
                              ? "Please Select Country"
                              : selectedCountry.name,
                          labelStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ])),
            //AddressLineOne
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Address Line 1 ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  StreamBuilder<String>(
                      initialData: widget.addressModel != null
                          ? widget.addressModel.addressOne
                          : null,
                      stream: addressBloc.addressOne,
                      builder: (context, snapshot) {
                        return TextFormField(
                          key: Key(widget.addressModel != null
                              ? widget.addressModel.addressOne
                              : null),
                          initialValue: widget.addressModel != null
                              ? widget.addressModel.addressOne
                              : null,
                          onChanged: (String val){
                            setState(() {
                              ProfileUI.isEdited = true;
                            });
                            addressBloc.addressOneChanged(val);
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorText: snapshot.error),
                        );
                      })
                ])),
            //Address Line 2
            // Padding(
            //     padding: EdgeInsets.only(left: 25, right: 25, top: 5),
            //     child: Column(children: <Widget>[
            //       Align(
            //         alignment: Alignment.centerLeft,
            //         child: Text(
            //           "Address Line 2 ",
            //           textAlign: TextAlign.start,
            //           style: TextStyle(
            //               fontSize: 15,
            //               fontFamily: "Helvetica",
            //               color: Colors.grey[400]),
            //         ),
            //       ),
            //       StreamBuilder<String>(
            //           stream: addressBloc.addressTwo,
            //           builder: (context, snapshot) => TextFormField(
            //             onChanged: addressBloc.addressTwoChanged,
            //             keyboardType: TextInputType.text,
            //             decoration: InputDecoration(
            //                 enabledBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.black),
            //                 ),
            //                 focusedBorder: UnderlineInputBorder(
            //                   borderSide: BorderSide(color: Colors.black),
            //                 ),
            //                 errorText: snapshot.error),
            //           ))
            //     ])),
            //City
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "City / Town ",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  StreamBuilder<String>(
                      initialData: widget.addressModel != null
                          ? widget.addressModel.cityName
                          : null,
                      stream: addressBloc.city,
                      builder: (context, snapshot) => TextFormField(
                        key: Key(
                          widget.addressModel != null
                              ? widget.addressModel.cityName
                              : null,
                        ),
                        initialValue: widget.addressModel != null
                            ? widget.addressModel.cityName
                            : null,
                        onChanged: (String val){
                          setState(() {
                            ProfileUI.isEdited = true;
                          });
                          addressBloc.cityChanged(val);
                        },
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                              RegExp(r"[a-zA-Z]+|\s"))
                        ],
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: snapshot.error),
                      ))
                ])),
            //State
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "State",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  TextFormField(
                    onTap: () {
                      setState(() {
                        editable = true;
                      });
                      return showDialog(
                        builder: (BuildContext context) {
                          filter = "";
                          country.clear();
                          searchData.clear();
                          if (widget.addressModel == null) {
                            if (id == null) {
                              ToastMsg().getLoginSuccess(
                                  context, "Please Select Country First");
                              editable = false;
                            } else {
                              addressBloc.fetchState(id);
                              return StreamBuilder<CountryStateList>(
                                  stream: addressBloc.states,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      country.addAll(snapshot.data.countryState);
                                      searchData.isNotEmpty
                                          ? searchData
                                          : searchData.addAll(country);
                                      if (snapshot.data.countryState.isEmpty) {
                                        Navigator.pop(context);
                                        return Center();
                                      }
                                      else{
                                        return Dialog(
                                          child: StatefulBuilder(
                                            builder: (context, StateSetter setState) {

                                              return new Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                                children: <Widget>[
                                                  new Padding(
                                                      padding: new EdgeInsets.only(
                                                          top: 8.0,
                                                          left: 16.0,
                                                          right: 16.0),
                                                      child: new TextField(
                                                        onChanged: (String query) {
                                                          // filterQuery(query, setState);
                                                          setState(() {
                                                            filter = query;
                                                          });
                                                        },
                                                        style: new TextStyle(
                                                            fontSize: 18.0,
                                                            color: Colors.black),
                                                        decoration: InputDecoration(
                                                          prefixIcon:
                                                          new Icon(Icons.search),
                                                          suffixIcon: new IconButton(
                                                            icon:
                                                            new Icon(Icons.close),
                                                            onPressed: () {
                                                              controller.clear();
                                                              setState(() {
                                                                editable = false;
                                                              });
                                                              Navigator.of(context,
                                                                  rootNavigator:
                                                                  true)
                                                                  .pop();
                                                              // FocusScope.of(context).requestFocus(new FocusNode());
                                                            },
                                                          ),
                                                          hintText: "Search...",
                                                        ),
                                                        // controller: controller,
                                                      )),
                                                  new Expanded(
                                                    child: new Padding(
                                                        padding: new EdgeInsets.only(
                                                            top: 8.0),
                                                        child: StatefulBuilder(
                                                          builder: (context,
                                                              StateSetter
                                                              setState) =>
                                                              ListView.builder(
                                                                  itemCount:
                                                                  searchData
                                                                      .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                  context,
                                                                      int index) {
                                                                    if (filter ==
                                                                        null ||
                                                                        filter ==
                                                                            "") {
                                                                      return _buildStateRow(
                                                                        searchData[
                                                                        index],
                                                                        context,
                                                                      );
                                                                    } else {
                                                                      if (searchData[
                                                                      index]
                                                                          .name
                                                                          .toLowerCase()
                                                                          .startsWith(
                                                                          filter
                                                                              .toLowerCase())) {
                                                                        return _buildStateRow(
                                                                          searchData[
                                                                          index],
                                                                          context,
                                                                        );
                                                                      } else {
                                                                        return new Container();
                                                                      }
                                                                    }
                                                                  }),
                                                        )),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  });
                            }
                          } else {
                            addressBloc.fetchState(widget.addressModel.countryID);
                            return StreamBuilder<CountryStateList>(
                                stream: addressBloc.states,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    country.addAll(snapshot.data.countryState);
                                    searchData.isNotEmpty
                                        ? searchData
                                        : searchData.addAll(country);
                                    if (snapshot.data.countryState.isEmpty) {
                                      Navigator.pop(context);
                                      return Center();
                                    }
                                 else{
                                      return Dialog(
                                        child: StatefulBuilder(
                                          builder: (context, StateSetter setState) {
                                            return new Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                new Padding(
                                                    padding: new EdgeInsets.only(
                                                        top: 8.0,
                                                        left: 16.0,
                                                        right: 16.0),
                                                    child: new TextField(
                                                      onChanged: (String query) {
                                                        // filterQuery(query, setState);
                                                        setState(() {
                                                          filter = query;
                                                        });
                                                      },
                                                      style: new TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.black),
                                                      decoration: InputDecoration(
                                                        prefixIcon:
                                                        new Icon(Icons.search),
                                                        suffixIcon: new IconButton(
                                                          icon: new Icon(Icons.close),
                                                          onPressed: () {
                                                            controller.clear();
                                                            setState(() {
                                                              editable = false;
                                                            });
                                                            Navigator.of(context,
                                                                rootNavigator:
                                                                true)
                                                                .pop();

                                                            // FocusScope.of(context).requestFocus(new FocusNode());
                                                          },
                                                        ),
                                                        hintText: "Search...",
                                                      ),
                                                      // controller: controller,
                                                    )),
                                                new Expanded(
                                                  child: new Padding(
                                                      padding: new EdgeInsets.only(
                                                          top: 8.0),
                                                      child: StatefulBuilder(
                                                        builder: (context,
                                                            StateSetter
                                                            setState) =>
                                                            ListView.builder(
                                                                itemCount:
                                                                searchData.length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                context,
                                                                    int index) {
                                                                  if (filter ==
                                                                      null ||
                                                                      filter == "") {
                                                                    return _buildStateRow(
                                                                      searchData[
                                                                      index],
                                                                      context,
                                                                    );
                                                                  } else {
                                                                    if (searchData[
                                                                    index]
                                                                        .name
                                                                        .toLowerCase()
                                                                        .startsWith(filter
                                                                        .toLowerCase())) {
                                                                      return _buildStateRow(
                                                                        searchData[
                                                                        index],
                                                                        context,
                                                                      );
                                                                    } else {
                                                                      return new Container();
                                                                    }
                                                                  }
                                                                }),
                                                      )),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                });
                          }
                          Navigator.pop(context);
                          return Container();
                        },
                        barrierDismissible: true,
                        context: context,
                      );
                    },
                    // enabled: selectedCountry.id != null ? false : true,
                    readOnly: !editable
                        ? true
                        : false,
                    decoration: InputDecoration(
                        hintText: selectedCountry == "" || selectedCountry == null
                            ? "Please Select State"
                            : _selectedState,
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        // labelText:editable?"": selectedCountry == "" || selectedCountry == null
                        //     ? "Please Select State"
                        //     : _selectedState,
                        // helperText: selectedCountry.id == null?"Please Select the Country First":"",
                        labelStyle: TextStyle(color: Colors.black)),
                    // Not necessary for Option 1
                    onChanged: (newValue) {
                      setState(() {
                        _selectedState = newValue;
                      });
                    },
                  ),
                ])),

            //Postal Code
            Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Postal Code / Zip Code",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Helvetica",
                          color: Colors.grey[400]),
                    ),
                  ),
                  StreamBuilder<String>(
                      initialData: widget.addressModel != null
                          ? widget.addressModel.postalCode
                          : null,
                      stream: addressBloc.postalCode,
                      builder: (context, snapshot) => TextFormField(
                        key: Key(
                          widget.addressModel != null
                              ? widget.addressModel.postalCode
                              : null,
                        ),
                        initialValue: widget.addressModel != null
                            ? widget.addressModel.postalCode
                            : null,
                        onChanged: (String val){
                          setState(() {
                            ProfileUI.isEdited = true;
                          });
                          addressBloc.postalCodeChanged(val);
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp(r"[0-9]"))
                        ],
                        decoration: InputDecoration(
                            counter: Offstage(),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: snapshot.error),
                      ))
                ])),
            widget.addressType == "My Address"
                ? Center()
                : widget.addressMode == "ADD" || widget.addressMode =="EDIT"
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 10, top: 10),
                  child: Container(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        value: checkedAddress,
                        onChanged: (bool val) {
                          setState(() {
                            checkedAddress = val;
                          });
                        }),
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 5, right: 10, top: 15, bottom: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "My ${otherAddress} address is the same as my ${widget.addressType}.",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              fontFamily: "Helvetica",
                              color: Colors.black),
                        ),
                      )),
                )
              ],
            )
                : widget.addressMode == "EDIT" &&
                widget.addressModel.selection_type == "identical"
                ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.only(left: 15, right: 10, top: 10),
                  child: Container(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        value: checkedAddress,
                        onChanged: (bool val) {
                          setState(() {
                            checkedAddress = val;
                          });
                        }),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 5, right: 10, top: 10, bottom: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "My ${otherAddress} address is the same as my ${widget.addressType}.",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            fontFamily: "Helvetica",
                            color: Colors.black),
                      ),
                    ))
              ],
            )
                : Center(),
          ],
        ));
  }

  ListTile _buildCountryRow(CountryState name, BuildContext context) {
    return new ListTile(
      onTap: () {
        setState(() {
          selectedCountry.name = name.name;
          selectedCountry.id = name.id;
          id = name.id;
          print(AddressModel().countryID);
          searchData.clear();
          _selectedState = "";
          ProfileUI.isEdited = true;
          Navigator.of(context, rootNavigator: true).pop();

          country.clear();
          if (widget.addressModel != null) {
            widget.addressModel.countryID = name.id;
            widget.addressModel.addressOne = "";
            widget.addressModel.addressTwo = "";
            widget.addressModel.postalCode = "";
            widget.addressModel.cityName = "";
          }
        });
      },
      title: new Text(
        name.name,
      ),
    );
  }

  ListTile _buildStateRow(CountryState name, BuildContext context) {
    return new ListTile(
      onTap: () {
        this.setState(() {
          _selectedState = name.name;
          _selectedCountry = "";
          editable = false;
          Navigator.of(context, rootNavigator: true).pop();
          searchData.clear();
          country.clear();
          ProfileUI.isEdited = true;
          if (widget.addressModel != null) {
            // widget.addressModel.countryID = name.id;
            widget.addressModel.addressOne = "";
            widget.addressModel.addressTwo = "";
            widget.addressModel.postalCode = "";
            widget.addressModel.cityName = "";
          }
        });
      },
      title: new Text(
        name.name,
      ),
    );
  }

  List addType = ["Home", "Office", "Other"];

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.black,
          value: addType[btnValue],
          groupValue: selectAddType,
          onChanged: (value) {
            setState(() {
              selectAddType = value;
            });
          },
        ),
        Text(
          "$title",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 14, fontFamily: "Helvetica", color: Colors.black),
        ),
      ],
    );
  }

  List addressType = ["Other", "Default"];

  Row addaddressType(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.black,
          value: addressType[btnValue],
          groupValue: selectType,
          onChanged: (value) {
            setState(() {
              print("DEFAULT TYPE : $value");
              selectType = value;
            });
          },
        ),
        Text(
          "$title",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 14, fontFamily: "Helvetica", color: Colors.black),
        ),
      ],
    );
  }
}
