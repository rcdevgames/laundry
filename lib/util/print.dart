import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:indonesia/indonesia.dart';
import 'package:flutter/services.dart';

class Print {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<void> init() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
      bluetooth.connect(devices[0]);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  zeroAdd(val) {
    return (val < 10) ? "0$val":val;
  }

  printHistory(history, user) {
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
        bluetooth.printCustom("Struk Bukti Bayar Pajak",1,1);
        bluetooth.printCustom("Pemerintah Kota Bekasi",1,1);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printCustom("${tanggal(history.createdAt)} ${zeroAdd(history.createdAt.hour)}:${zeroAdd(history.createdAt.minute)}:${zeroAdd(history.createdAt.second)}", 1, 0);
        bluetooth.printCustom(user.name, 1, 0);
        bluetooth.printCustom("NPWPD : ${user.restaurants.npwpd}", 1, 0);
        bluetooth.printCustom("--------------------------------",1,1);
        bluetooth.printNewLine();
        bluetooth.printLeftRight("Pajak dibayarkan", rupiah(history.amount),1);
        bluetooth.printNewLine();
        bluetooth.printCustom("Scan Disini",1,1);
        bluetooth.printCustom("Download aplikasi klik rupiah",0,1);
        // bluetooth.printNewLine();
        // bluetooth.printQRcode(history.uuid);
        bluetooth.printCustom("Print Copy",0,2);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  printTransaction(trx, user) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    var isConnected = await bluetooth.isConnected;
    print(isConnected);
    if (isConnected) {
      bluetooth.printCustom("Struk Bukti Bayar Pajak",1,1);
      bluetooth.printCustom("Pemerintah Kota Bekasi",1,1);
      bluetooth.printCustom("--------------------------------",1,1);
      bluetooth.printCustom("${tanggal(trx.createdAt)} ${zeroAdd(trx.createdAt.hour)}:${zeroAdd(trx.createdAt.minute)}:${zeroAdd(trx.createdAt.second)}", 1, 0);
      bluetooth.printCustom(user.name, 1, 0);
      bluetooth.printCustom("NPWPD : ${user.restaurants.npwpd}", 1, 0);
      bluetooth.printCustom("--------------------------------",1,1);
      bluetooth.printNewLine();
      bluetooth.printLeftRight("Pajak dibayarkan", rupiah(trx.amount),1);
      bluetooth.printNewLine();
      bluetooth.printCustom("Scan Disini",1,1);
      bluetooth.printCustom("Download aplikasi klik rupiah",0,1);
      // bluetooth.printNewLine();
      // bluetooth.printQRcode(trx.uuid);
      bluetooth.printCustom("Print Copy",0,2);
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.paperCut();
    }
  }
  Future autoPrint(trx, user) async {
    await init();
    var isConnected = await bluetooth.isConnected;
    print(isConnected);
    if (isConnected) {
      bluetooth.printCustom("Struk Bukti Bayar Pajak",1,1);
      bluetooth.printCustom("Pemerintah Kota Bekasi",1,1);
      bluetooth.printCustom("--------------------------------",1,1);
      bluetooth.printCustom("${tanggal(trx.createdAt)} ${zeroAdd(trx.createdAt.hour)}:${zeroAdd(trx.createdAt.minute)}:${zeroAdd(trx.createdAt.second)}", 1, 0);
      bluetooth.printCustom(user.name, 1, 0);
      bluetooth.printCustom("NPWPD : ${user.restaurants.npwpd}", 1, 0);
      bluetooth.printCustom("--------------------------------",1,1);
      bluetooth.printNewLine();
      bluetooth.printLeftRight("Pajak dibayarkan", rupiah(trx.amount),1);
      bluetooth.printNewLine();
      bluetooth.printCustom("Scan Disini",1,1);
      bluetooth.printCustom("Download aplikasi klik rupiah",0,1);
      // bluetooth.printNewLine();
      // bluetooth.printQRcode(trx.uuid);
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.printNewLine();
      bluetooth.paperCut();
    }else{
      await Future.delayed(const Duration(milliseconds: 500));
      autoPrint(trx, user);
    }
  }
}


final printer = new Print();