import 'dart:convert';
import 'dart:io';

import 'package:azaFashions/utils/CountryInfo.dart';
import 'package:azaFashions/utils/SessionDetails.dart';
import 'package:azaFashions/utils/Tapsila.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderFile{

  SessionDetails _sessionDetails = SessionDetails();
  SharedPreferences _sharedPreferences;

  //String baseUrl = "https://dormammu.azafashions.com/v1/";
  String baseUrl="http://qapi.azaonline.in/v1/";

  String x_trail = "X-Trail-ID";
  String customerId = "X-Customer-ID";
  String currency_code = "X-Currency-Code";
  String country_code = "X-Country-Code";


  String x_ts = "X-TS";
  String x_ts_value;

  String deviceid = "X-Device-ID";
  String deviceid_value = "";


  String app_platform = "X-Platform";
  String app_platform_value = "app";

  String app_version = "X-App-Version";
  String app_version_value = "1.0.0";

  String app_os = "X-App-OS";
  String app_os_value = "";

  String app_os_version = "X-App-OS-Version";
  String app_os_version_value = "";

  String app_model = "X-App-Model";
  String app_model_value = "";

  String x_hm = "X-HM";
  String x_hm_value = "";


  Future<String> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      app_os_value="ios";
      var iosDeviceInfo = await deviceInfo.iosInfo;
      app_os_version_value=iosDeviceInfo.systemVersion.toString();
      app_model_value=iosDeviceInfo.model.toString();
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      app_os_value="android";
      var androidDeviceInfo = await deviceInfo.androidInfo;
      app_os_version_value=androidDeviceInfo.version.baseOS.toString();
      app_model_value=androidDeviceInfo.model.toString();
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
  getXhmValue() async{

  var firstHmacKey = utf8.encode("${Tapsila().API_SECRET_KEY}#${Tapsila().API_SALT}");
  print("FIRST HMAC KEY:${Tapsila().API_SECRET_KEY}#${Tapsila().API_SALT}");// API_SECRET_KEY + '#' + API_SALT
    var currentTime=DateTime.now().millisecondsSinceEpoch.toString();
    x_ts_value=currentTime.toString();
    var timestamp = utf8.encode("$currentTime"); // X-TS

    print("Encoded TimeStamp: $timestamp  Actual Timestamp:$currentTime");// PAYLOAD

    var hmacSha512 = new Hmac(sha512, firstHmacKey); // HMAC-SHA512
    var crypt_hash = hmacSha512.convert(timestamp); // CRYPT_HASH
    print("crypt_hash: $crypt_hash"); // PAYLOAD

    await  _getDeviceId().then((value) {deviceid_value=value;print("X-DeviceId: $value $deviceid_value");});

    var plainPayload = utf8.encode("app" + "$crypt_hash" + "$deviceid_value"); // X-Platform + CRYPT_HASH + X-Device-ID
    var payload = md5.convert(plainPayload);
    print("Payload: $payload");// PAYLOAD

    var utf8EncodedPayload = utf8.encode("$payload");
    //var secondHmacKey = utf8.encode("aK4U7AvAOP4xOgwQvonKcFoUXgz2wNgUPALtr4quiUblFopn9Bf5zZy0UHW9eUzv");
    var secondHmacKey = utf8.encode("${Tapsila().API_SECRET_KEY}");
    print("SECOND HMAC KEY: ${Tapsila().API_SECRET_KEY}");
    // API_SECRET_KEY
    var hmacSha384 = new Hmac(sha384, secondHmacKey); // HMAC-SHA384
    var x_hm = hmacSha384.convert(utf8EncodedPayload); // X-HM
    print("HMAC digest as hex string: $x_hm");
    x_hm_value=x_hm.toString();

  }

 Future<Map<String, String>> getHeaderDetails(BuildContext context) async {
    _sharedPreferences = await SharedPreferences.getInstance();
      await getXhmValue();

      Map<String, String> headers = {
        "Content-type": "application/json",
        x_trail: _sharedPreferences.getString("XTrailId")!=null?_sharedPreferences.getString("XTrailId"):"",
        customerId: _sharedPreferences.getString("CustomerId")!=null?_sharedPreferences.getString("CustomerId"):"0",
        x_ts: x_ts_value,
        deviceid: deviceid_value,
        app_platform: app_platform_value,
        app_version: app_version_value,
        app_os: app_os_value,
        app_os_version: app_os_version_value,
        app_model: app_model_value,
        x_hm: x_hm_value,
        currency_code:CountryInfo.currencyCode!=null?CountryInfo.currencyCode:"null",
        country_code:CountryInfo.countryDialCode!=null?CountryInfo.countryDialCode:"null"
      };
      print("Headers: $headers");

      return headers;


  }







}
