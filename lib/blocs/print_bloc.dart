import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/new_transaction_model.dart';
import 'package:laundry/models/report_model.dart';
import 'package:laundry/util/nav_service.dart';
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
  final _loading_connect = BehaviorSubject<List<bool>>();
  final _users = BehaviorSubject<Auth>();

  //Getter
  Stream<List<BluetoothDevice>> get getDevices => _devices.stream;
  Stream<BluetoothDevice> get getDevice => _device.stream;
  Stream<bool> get isLoading => _loading.stream;
  Stream<bool> get getBTAble => _bt_able.stream;
  Stream<bool> get getBTConnect => _bt_connected.stream;
  Stream<List<bool>> get getLoading => _loading_connect.stream;
  Stream<Auth> get getUser => _users.stream;

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
    _loading_connect.close();
    _users.close();
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
        _loading_connect.sink.add(List.generate(devices.length, (i) => false));
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

  Future loadUser() async {
    var data = await sessions.load("auth");
    if (data != null) {
      _users.sink.add(await compute(authFromJson, data));
    }
  }

  setLoadingConnect(int index, bool val) {
    var loading = _loading_connect.value;
    loading[index] = val;
    _loading_connect.sink.add(loading);
  }

  connect(BuildContext context, BluetoothDevice device, int index) async {
    try {
      setLoadingConnect(index, true);
      await bluetooth.connect(device);
      setDevice(device);
      sessions.save("printer", device.address);
      setLoadingConnect(index, false);
    } on PlatformException catch (e) {
      setLoadingConnect(index, false);
      sessions.remove("printer");
      bluetooth.disconnect();
      showAlert(
        context: context,
        title: "Error Connecting Bluetooth",
        body: e.message
      );
    }
  }
  
  disconnect(BuildContext context, int index) async {
    try {
      setLoadingConnect(index, true);
      await bluetooth.disconnect();
      setDevice(null);
      sessions.remove("printer");
      setLoadingConnect(index, false);
    } on PlatformException catch (e) {
      setLoadingConnect(index, false);
      showAlert(
        context: context,
        title: "Error Disconnecting Bluetooth",
        body: e.message
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

  printTransaction(BuildContext context, NewTransaction trx) async {
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
        bluetooth.printCustom("${_users.value.name[0].toUpperCase()}${_users.value.name.substring(1)} Laundry",1,1);
        bluetooth.printCustom("Indonesia",1,1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printCustom("Kode Trx : ${trx.id}",0,0);
        bluetooth.printCustom("Tanggal : ${tanggal(trx.createdAt, shortMonth: true)} ${timeFormat(trx.createdAt)}",0,0);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Nama Produk", "(Kg) Total Biaya",1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printLeftRight(trx.productName, "(${trx.qty}Kg) ${rupiah(trx.total)}",1);
        bluetooth.printLeftRight("@${rupiah(trx.price)}", "",1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printLeftRight("Sub Total", rupiah(trx.total),1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      } else {
        showAlert(
          context: context,
          title: "Error Print",
          body: "Printer Tidak Terhubung!",
          actions: [
            AlertAction(
              onPressed: () => null,
              text: "Batalkan"
            ),
            AlertAction(
              onPressed: () => navService.navigateTo("/setting-printer"),
              text: "Pengaturan"
            ),
          ]
        );
      }
    });
  }

  printReport(BuildContext context, Report report, String period) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT
    await loadUser();
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printCustom("${_users.value.name[0].toUpperCase()}${_users.value.name.substring(1)} Laundry",1,1);
        bluetooth.printCustom("Indonesia",1,1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printCustom("Periode : $period",0,1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printLeftRight("Transaksi Process", rupiah(report.transactionProses),0);
        bluetooth.printLeftRight("Transaksi Selesai", rupiah(report.transactionDone),0);
        bluetooth.printLeftRight("Pengeluaran", rupiah(report.expenses),0);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printNewLine();
        if (report.profit < 0) {
          bluetooth.printLeftRight("Rugi", rupiah(report.profit),0);
        }else{
          bluetooth.printLeftRight("Laba", rupiah(report.profit),0);
        }
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printLeftRight("", DateTime.now().toIso8601String(),0);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      } else {
        showAlert(
          context: context,
          title: "Error Print",
          body: "Printer Tidak Terhubung!",
          actions: [
            AlertAction(
              onPressed: () => null,
              text: "Batalkan"
            ),
            AlertAction(
              onPressed: () => navService.navigateTo("/setting-printer"),
              text: "Pengaturan"
            ),
          ]
        );
      }
    });
  }

  String zeroPad(int data) {
    if (data.toString().length < 2) return "0"+data.toString();
    return data.toString();
  }

  String timeFormat(DateTime date) {
    return zeroPad(date.hour) + ":" + zeroPad(date.minute) + ":" + zeroPad(date.second);
  }

}