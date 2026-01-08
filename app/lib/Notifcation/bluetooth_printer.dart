import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class BluetoothPrinterService {
  static final BluetoothPrinterService _instance =
      BluetoothPrinterService._internal();

  factory BluetoothPrinterService() => _instance;

  BluetoothPrinterService._internal();

  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  BluetoothDevice? _device;

  Future<void> init() async {
    List<BluetoothDevice> devices = await _printer.getBondedDevices();
    if (devices.isNotEmpty) {
      _device = devices.first; // or match by MAC
    }
  }

  Future<void> connect() async {
    if (_device == null) return;

    bool isConnected = await _printer.isConnected ?? false;
    if (!isConnected) {
      await _printer.connect(_device!);
    }
  }

  Future<void> printText(String text) async {
    await connect();
    _printer.printCustom(text, 2, 0);
    _printer.paperCut();
  }
}
