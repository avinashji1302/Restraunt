import 'dart:convert';
import 'dart:io';

import 'package:app/Notifcation/firebase_notifcation.dart';
import 'package:app/config/api_constants.dart';
import 'package:app/config/shared_pref.dart';
import 'package:app/screens/home/view/home_page.dart';
import 'package:app/screens/login/model/login_model.dart' show LoginModel;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Notifcation/bluetooth_printer.dart';

class LoginProvider extends ChangeNotifier {
  String? token;
  bool isLoading = false;
  String? error;

  Future<void> login(BuildContext context, String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
     // final deviceToken = await FirebaseNotifcation().getDeviceToken();
      //await PrinterService().connectAndPrintDummy();
    //   debugPrint("Login Successful token: $deviceToken");

      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/login"),
        body: {
          "email": email,
          "password": password,
      //   "fcm_token": deviceToken
        },
      );

      if (response.statusCode == 200) {
        final model = LoginModel.fromJson(jsonDecode(response.body));

        token = model.accessToken; // ✅ SAVE TOKEN
        await SharedPref().saveToken(token!); // Save token to shared preferences

        debugPrint("Login Successful $model ${response.body} token: ${await SharedPref().getToken()}");

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
        error = null;
      } else {
        error = "Login failed";
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }


  Future<void> sendTokenToBackend(String token) async {
    debugPrint("Sending FCM token to backend: $token");
    final String? authToken = await SharedPref().getToken();
    if (authToken == null) {
      debugPrint("No auth token found. Cannot send FCM token to backend.");
      return;
    }
  await http.post(
    Uri.parse('${ApiConstants.baseUrl}/save-fcm-token'),
    headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "fcm_token": token,
      "device_type": Platform.isAndroid ? "android" : "ios"
    }),
  );
}

}
