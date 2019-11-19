import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/util/session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

class PrintBloc extends BlocBase {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  final _devices = BehaviorSubject<List<BluetoothDevice>>();
  final _device = BehaviorSubject<BluetoothDevice>();
  final _loading = BehaviorSubject<bool>.seeded(false);
  final _bt_able = BehaviorSubject<bool>.seeded(false);
  final _bt_connected = BehaviorSubject<bool>.seeded(false);

  //Getter
  Stream<List<BluetoothDevice>> get getDevices => _devices.stream;
  Stream<BluetoothDevice> get getDevice => _device.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<bool> get getBTAble => _bt_able.stream;
  Stream<bool> get getBTConnect => _bt_connected.stream;

  //Setter

  Function(List<BluetoothDevice>) get setDevices => _devices.sink.add;
  Function(BluetoothDevice) get setDevice => _device.sink.add;
  Function(bool) get setLoading => _loading.sink.add;

  @override
  void dispose() { 
    super.dispose();
    _devices.close();
    _device.close();
    _loading.close();
    _bt_able.close();
    _bt_connected.close();
  }

  //Function
  Future fetchAllDevice() async {
    print("Connected : ${await bluetooth.isConnected}");
    if (!await bluetooth.isAvailable) {
      _devices.sink.addError("Bluetooh is Not Available");
    } else if (!await bluetooth.isOn) {
      _devices.sink.addError("Bluetooh is OFF");
    }else {
      try {
        var bind = await sessions.load("printer");
        var devices = await bluetooth.getBondedDevices();
        setDevices(devices);
        print(bind);
        if (bind != null) {
          devices.forEach((i) {
            if (i.address == bind) {
              bluetooth.connect(i);
              setDevice(i);
            }
          });
        }
      } on PlatformException catch (e) {
        print(e.toString());
        _devices.sink.addError(e.toString().replaceAll("Exception: ", ""));
      } catch (e) {
        print("Error : " + e.toString());
      }
    }
  }

  connect(BuildContext context, BluetoothDevice device) async {
    try {
      await bluetooth.connect(device);
      setDevice(device);
      sessions.save("printer", device.address);
    } catch (e) {
      showAlert(
        context: context,
        title: "Error Connecting Bluetooth",
        body: e.toString()
      );
    }
  }
  
  disconnect(BuildContext context) async {
    try {
      await bluetooth.disconnect();
      setDevice(null);
      sessions.remove("printer");
    } catch (e) {
      showAlert(
        context: context,
        title: "Error Connecting Bluetooth",
        body: e.toString()
      );
    }
  }

  testPrint() async {
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
        bluetooth.printCustom("Laundry Print Test",1,1);
        bluetooth.printCustom("Indonesia",1,1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printLeftRight("Cuci Gosok", "7Kg ${rupiah(21000)}",1);
        bluetooth.printLeftRight("@${rupiah(3000)}", "",1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Total", rupiah(21000),1);
        bluetooth.printNewLine();
        // bluetooth.printCustom("Scan Disini",1,1);
        // bluetooth.printCustom("Download aplikasi klik rupiah",0,1);
        // bluetooth.printNewLine();
        // bluetooth.printQRcode(history.uuid);
        bluetooth.printCustom("Customer Copy",0,2);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
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