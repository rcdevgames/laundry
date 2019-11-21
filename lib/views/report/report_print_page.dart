import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/print_bloc.dart';
import 'package:laundry/blocs/report_bloc.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/report_model.dart';
import 'package:responsive_screen/responsive_screen.dart';

class ReportPrintPage extends StatelessWidget {
  Report data;
  ReportPrintPage(this.data);
  final _key = new GlobalKey<ScaffoldState>();

  List<String> month = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    final bloc = BlocProvider.getBloc<ReportBloc>();
    final printBloc = BlocProvider.getBloc<PrintBloc>();
    printBloc.loadUser();

    Widget _buildDashWidget() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          wp(8).toInt(),
              (_) => Container(
            width: 7,
            height: 2,
            color: Colors.grey,
            margin: EdgeInsets.only(left: 3 / 2, right: 3 / 2),
          ),
        ),
      );
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Cetak Laporan", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          child: Card(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                StreamBuilder<Auth>(
                  stream: printBloc.getUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("${snapshot.data.name[0].toUpperCase()}${snapshot.data.name.substring(1)} Laundry", style: TextStyle(fontSize: 20));
                    } return Text("");
                  }
                ),
                SizedBox(height: 5),
                Text("Indonesia", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                _buildDashWidget(),
                SizedBox(height: 5),
                StreamBuilder<String>(
                  stream: bloc.getMonth,
                  builder: (context, snapshot) {
                    print("Periode : ${snapshot.data}");
                    if (snapshot.hasData && snapshot.data.isNotEmpty) {
                      return Text("Periode : ${month[int.tryParse(snapshot.data) - 1]} ${DateTime.now().year}", style: TextStyle(fontSize: 18));
                    }  return Text("Periode : ${DateTime.now().year}", style: TextStyle(fontSize: 18));
                  }
                ),
                SizedBox(height: 5),
                _buildDashWidget(),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Transaksi Process"),
                      Text(rupiah(data.transactionProses)),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Transaksi Selesai"),
                      Text(rupiah(data.transactionDone)),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Pengeluaran"),
                      Text(rupiah(data.expenses)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _buildDashWidget(),
                SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    if (data.profit < 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: wp(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Rugi"),
                            Text(rupiah(data.profit)),
                          ],
                        ),
                      );
                    } else{
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: wp(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Laba"),
                            Text(rupiah(data.profit)),
                          ],
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // Text(tanggal(DateTime.now(), shortMonth: true)),
                      Text(DateTime.now().toIso8601String()),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<String>(
        stream: bloc.getMonth,
        builder: (context, snapshot) {
          return FloatingActionButton.extended(
            label: Text("Print", style: TextStyle(color: Colors.white)),
            icon: Icon(Icons.print, color: Colors.white),
            onPressed: () => printBloc.printReport(context, data, snapshot.hasData && snapshot.data.isNotEmpty ? "${month[int.tryParse(snapshot.data) - 1]} ${DateTime.now().year}" : DateTime.now().year.toString()),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}