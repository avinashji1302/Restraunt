import 'package:app/screens/home/model/home_model.dart';
import 'package:app/screens/home/viewmodel/home_provider.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'bluetooth_printer.dart';
import 'local_notifications.dart';



@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {

  debugPrint("🔔 BACKGROUND MESSAGE RECEIVED");
  debugPrint("Title: ${message.notification?.title}");
  debugPrint("Body: ${message.notification?.body}");
  debugPrint("Data: ${message.data}");

  final String title =
      message.notification?.title ??
      message.data['title'] ??
      'No Title';

  final String body =
      message.notification?.body ??
      message.data['body'] ??
      'No Body';

final homeProvider = HomeProvider();
  debugPrint("🛠 get order  local notifications");
      homeProvider.getOrders();
          Order order = homeProvider.orders.first;

  try {
    debugPrint("🛠 Initializing local notifications");
    await LocalNotifications.initialize();


    debugPrint("📢 Showing notification");

    
   //await LocalNotifications.showNotification(message.data['custom data']??"null", body);
    // AUTO PRINT
    await PrinterService().connectAndPrintDummy(order);
    debugPrint("✅ Notification shown successfully");
  } catch (e, stack) {
    debugPrint("❌ Notification error: $e");
    debugPrint(stack.toString());
  }

  
}



class FirebaseNotifcation {
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initFirebaseNotification() async{

    NotificationSettings settings = await messaging.requestPermission(alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,);

      if(settings.authorizationStatus==AuthorizationStatus.authorized){
      debugPrint("User granted Permssion");
      }

      if(settings.authorizationStatus==AuthorizationStatus.provisional){
              debugPrint("User granted provisional Permssion");
      }

      if(settings.authorizationStatus==AuthorizationStatus.denied){
              debugPrint("User granted denieed Permssion");
              AppSettings.openAppSettings();
      }

       debugPrint("Permission: ${settings.authorizationStatus}");

    /// 🔥 FOREGROUND LISTENER
    FirebaseMessaging.onMessage.listen(firebaseForegroundHandler);

    /// 🔥 Token
    await getDeviceToken();
  }



    /// FOREGROUND HANDLER
Future<void> firebaseForegroundHandler(
      RemoteMessage message) async {
    debugPrint("🟢 FOREGROUND MESSAGE RECEIVED");
    debugPrint("Title: ${message.notification?.title}");
    debugPrint("Body: ${message.notification?.body}");
    debugPrint("Data: ${message.data}");



     final homeProvider = HomeProvider();
    await  homeProvider.getOrders();

    Order order = homeProvider.orders.first;

     SnackBar(content:  Text(message.notification?.body ?? "No Body"));

     try {
    debugPrint("🛠 Initializing local notifications");
    await LocalNotifications.initialize();


    debugPrint("📢 Showing notification");

    
   await LocalNotifications.showNotification(message.data['custom data']??"null", message.notification?.body ?? "No Body");

    // Auto print
    await PrinterService().connectAndPrintDummy(order);

    debugPrint("✅ Notification shown successfully");
  } catch (e, stack) {
    debugPrint("❌ Notification error: $e");
    debugPrint(stack.toString());
  }


    /// ⚠️ NOTE:
    /// Firebase DOES NOT show notification UI in foreground
    /// You must show it manually (Snackbar / Dialog / LocalNotification)
  }






  Future<String?> getDeviceToken() async{
    String? token= await messaging.getToken();
    debugPrint("Device Token $token");
    return token;
  }
 
}