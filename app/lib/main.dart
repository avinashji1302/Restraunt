import 'package:app/Notifcation/firebase_notifcation.dart';
import 'package:app/Notifcation/local_notifications.dart';
import 'package:app/screens/home/viewmodel/home_provider.dart';
import 'package:app/screens/login/view/login_page.dart';
import 'package:app/screens/login/viewmodel/login_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';


void main()  async{

     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
     
  //  await FirebaseNotifcation().getDeviceToken();
     
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MyApp(),
    ),
  );
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
