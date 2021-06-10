import 'package:shared_preferences/shared_preferences.dart';

class SupportDetails {
  getWhatsAppDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("whatsAppSupport");
  }

  getEmailSupport() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("emailSupport");
  }

  getMobileSupport() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("mobileSupport");
  }
}
