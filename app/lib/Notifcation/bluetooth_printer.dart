// import 'package:blue_thermal_printer/blue_thermal_printer.dart';
//
// class BluetoothPrinterService {
//   static final BluetoothPrinterService _instance =
//       BluetoothPrinterService._internal();
//
//   factory BluetoothPrinterService() => _instance;
//
//   BluetoothPrinterService._internal();
//
//   final BlueThermalPrinter _printer = BlueThermalPrinter.instance;
//
//   BluetoothDevice? _device;
//
//   Future<void> init() async {
//     List<BluetoothDevice> devices = await _printer.getBondedDevices();
//     if (devices.isNotEmpty) {
//       _device = devices.first; // or match by MAC
//     }
//   }
//
//   Future<void> connect() async {
//     if (_device == null) return;
//
//     bool isConnected = await _printer.isConnected ?? false;
//     if (!isConnected) {
//       await _printer.connect(_device!);
//     }
//   }
//
//   Future<void> printText(String text) async {
//     await connect();
//     _printer.printCustom(text, 2, 0);
//     _printer.paperCut();
//   }
// }

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class PrinterService {
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  Future<void> connectAndPrintDummy(RemoteMessage message) async {
    final isConnected = await _printer.isConnected ?? false;

    if (!isConnected) {
      final devices = await _printer.getBondedDevices();

      final printer = devices.firstWhere(
        (d) => d.name == "SezniK_Veer_AAC9",
        orElse: () => throw "Printer not found",
      );

      await _printer.connect(printer);
      debugPrint("🟢 Printer connected");
    } else {
      debugPrint("🟡 Printer already connected");
    }

    // // PRINT
    _printer.printNewLine();
    _printer.printCustom("NEW ORDER", 3, 1);
    _printer.printNewLine();

    _printer.printLeftRight("Customer:", message.notification?.title ?? "", 1);
    _printer.printLeftRight("Message:", message.notification?.body ?? "", 1);

    _printer.printNewLine();
    _printer.printCustom("Thank You", 2, 1);
    _printer.printNewLine();
    //
    // _printer.printNewLine();
    // _printer.printCustom("NEW ORDER", 3, 1);
    // _printer.printNewLine();
    // _printer.printLeftRight("Order ID:", "30", 1);
    // _printer.printLeftRight("Customer:", "${message.notification?.title}", 1);
    // _printer.printLeftRight("Table:", "3", 1);
    // _printer.printLeftRight("Total:", "₹100", 1);
    // _printer.printNewLine();
    // _printer.printCustom("Items", 2, 0);
    // _printer.printCustom("Veg x 1 - ₹100", 1, 0);
    // _printer.printNewLine();
    // _printer.printCustom("Thank You", 2, 1);
    // _printer.printNewLine();
    // _printer.printNewLine();
  }
}
