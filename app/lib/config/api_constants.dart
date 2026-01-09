import 'package:flutter/services.dart';

class ApiConstants {
   static String baseUrl = "https://qrcodegenerator.bytechcoderstechnology.com/api";



   //logo
   Future<Uint8List> loadImageBytes(String path) async {
  final data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}

}




