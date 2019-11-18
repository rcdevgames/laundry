import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/report_bloc.dart';
import 'package:laundry/models/report_model.dart';
import 'package:laundry/widget/loading.dart';
import 'package:responsive_screen/responsive_screen.dart';

class ReportPage extends StatelessWidget {
  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    final bloc = BlocProvider.getBloc<ReportBloc>();

    Widget card({Color color, Widget child}) {
    return SizedBox(
      height: hp(16),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 8,
              height: hp(15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3))
              ),
              child: SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 20, 5),
              child: child
            )
          ],
        ),
      ),
    );
  }
    
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text("Laporan", style: TextStyle(color: Colors.white)),
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: StreamBuilder(
            stream: bloc.getReport,
            builder: (context, AsyncSnapshot<Report> snapshot) {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(23.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Bulan"),
                            SizedBox(height: 3),
                            SizedBox(
                              width: wp(50),
                              child: StreamBuilder(
                                stream: bloc.getMonth,
                                builder: (context, AsyncSnapshot<String> snapshot) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<String>(
                                      value: snapshot.data,
                                      onChanged: bloc.setMonth,
                                      items: List.generate(13, (i) => DropdownMenuItem(
                                        value: i == 0 ? "":i.toString(),
                                        child: Text(i == 0 ? "All":i.toString()),
                                      )).toList(),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                                        contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8)
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: wp(50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: bloc.fetchReport,
                                    child: Text("Filter"),
                                    color: Colors.lightBlue,
                                    colorBrightness: Brightness.dark,
                                  ),
                                  RaisedButton(
                                    onPressed: () => bloc.setMonth(""),
                                    child: Text("reset"),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: card(
                            color: Colors.amber,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Transaksi Proses"),
                                Text(rupiah(snapshot.data?.transactionProses?.toString()??0), style: TextStyle(fontWeight: FontWeight.w700)),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.person),
                                    Text(snapshot.data?.transactionProsesTotal?.toString()??"0")
                                  ],
                                )
                              ],
                            )
                          ),
                        ),
                        Expanded(
                          child: card(
                            color: Colors.lightGreen,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Transaksi Selesai"),
                                Text(rupiah(snapshot.data?.transactionDone?.toString()??0), style: TextStyle(fontWeight: FontWeight.w700)),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.person),
                                    Text(snapshot.data?.transactionDoneTotal?.toString()??"0")
                                  ],
                                )
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        card(
                          color: Colors.grey,
                          child: SizedBox(
                            width: wp(35),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Pengeluaran"),
                                Text(rupiah(snapshot.data?.expenses?.toString()??0), style: TextStyle(fontWeight: FontWeight.w700)),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.attach_money),
                                    Text(snapshot.data?.expensesTotal?.toString()??"0")
                                  ],
                                )
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: card(
                            color: Colors.red,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Rugi"),
                                SizedBox(height: 20),
                                Text(rupiah(snapshot.data != null && snapshot.data?.profit < 0 ? (snapshot.data?.profit?.toString()??0) : 0), style: TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            )
                          ),
                        ),
                        Expanded(
                          child: card(
                            color: Colors.green,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Laba"),
                                SizedBox(height: 20),
                                Text(rupiah(snapshot.data != null && snapshot.data?.profit > 0 ? (snapshot.data?.profit?.toString()??0) : 0), style: TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Total Customer"),
                                  Text(snapshot.data?.customerTotal?.toString()??"0", style: TextStyle(fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text("Total Produk"),
                                  Text(snapshot.data?.productTotal?.toString()??"0", style: TextStyle(fontWeight: FontWeight.w700))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          ),
        ),
        StreamBuilder(
          initialData: false,
          stream: bloc.isLoading,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return Loading(snapshot.data);
          }
        )
      ],
    );
  }
}