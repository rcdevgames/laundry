import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

class PrintBloc extends BlocBase {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  final _devices = BehaviorSubject<List<BluetoothDevice>>();
  final _device = BehaviorSubject<BluetoothDevice>();
  final _loading = BehaviorSubject<bool>.seeded(false);

  //Getter
  Stream<List<BluetoothDevice>> get getDevices => _devices.stream;
  Stream<BluetoothDevice> get getDevice => _device.stream;
  Stream<bool> get isLoading => _loading.stream;

  //Setter

  Function(List<BluetoothDevice>) get setDevices => _devices.sink.add;
  Function(BluetoothDevice) get setDevice => _device.sink.add;
  Function(bool) get setLoading => _loading.sink.add;

  //Function
  Future<void> fetchAllDevice() async {
    if (await bluetooth.isAvailable || await bluetooth.isOn) {
      try {
        var devices = await bluetooth.getBondedDevices();
        setDevices(devices);
      } on PlatformException catch (e) {
        _devices.sink.addError(e.toString().replaceAll("Exception: ", ""));
      }
    }else {
      _devices.sink.addError("Bluetooh is OFF");
    }
  }

  connect(BuildContext context, BluetoothDevice device) async {
    try {
      await bluetooth.connect(device);
    } catch (e) {
      showAlert(
        context: context,
        title: "Error Connecting Bluetooth",
        body: e.toString()
      );
    }
  }
  
  disconnect(BuildContext context, BluetoothDevice device) async {
    try {
      await bluetooth.disconnect();
    } catch (e) {
      showAlert(
        context: context,
        title: "Error Connecting Bluetooth",
        body: e.toString()
      );
    }
  }

  printTransaction() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {

      }
    });
  }

  printReport() async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {

      }
    });
  }

}