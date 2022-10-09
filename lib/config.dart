import 'package:flutter/material.dart';

class Config {
  // copy your server url from admin panel
  static String apiServerUrl = "https://app.dromedichealthcare.com/api";
  // copy your api key from admin panel
  static String apiKey = "dromedic_healthcare_app";

  //enter onesignal app id below
  static String oneSignalAppId = "";
  // find your ios APP id from app store
  static const String iosAppId = "";
  static const bool enableGoogleLogin = true;
  static const bool enableFacebookLogin = true;

  static var supportedLanguageList = [
    const Locale("en", "US"),
    const Locale("bn", "BD"),
    const Locale("ar", "SA"),
  ];
  static const String initialCountrySelection = "UG";
}
