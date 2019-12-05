import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/print_bloc.dart';
import 'package:laundry/models/auth_model.dart';
import 'package:laundry/models/new_transaction_model.dart';
import 'package:responsive_screen/responsive_screen.dart';

class TransactionPrintPage extends StatefulWidget {
  NewTransaction data;
  TransactionPrintPage(this.data);

  @override
  _TransactionPrintPageState createState() => _TransactionPrintPageState();
}

class _TransactionPrintPageState extends State<TransactionPrintPage> {
  final _key = new GlobalKey<ScaffoldState>();
  final bloc = BlocProvider.getBloc<PrintBloc>();

  String zeroPad(int data) {
    if (data.toString().length < 2) return "0"+data.toString();
    return data.toString();
  }

  String timeFormat(DateTime date) {
    return zeroPad(date.hour) + ":" + zeroPad(date.minute) + ":" + zeroPad(date.second);
  }

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
  void initState() { 
    super.initState();
    bloc.loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

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
        title: Text("Cetak Bukti Transaksi", style: TextStyle(color: Colors.white)),
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
                  stream: bloc.getUser,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    children: <Widget>[
                      Text("Kode Trx : ${widget.data.id}"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    children: <Widget>[
                      Text("Tanggal : ${tanggal(widget.data.createdAt, shortMonth: true)} ${timeFormat(widget.data.createdAt)}"),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Nama Produk"),
                      Text("(Kg) Total Biaya"),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                _buildDashWidget(),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.data.productName),
                      Text("(${widget.data.qty}Kg) ${rupiah(widget.data.total)}"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("@${rupiah(widget.data.price)}"),
                      Text(""),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _buildDashWidget(),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Sub Total"),
                      Text(rupiah(widget.data.total)),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: wp(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      // Text(tanggal(DateTime.now(), shortMonth: true)),
                      Text(""),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Print", style: TextStyle(color: Colors.white)),
        icon: Icon(Icons.print, color: Colors.white),
        onPressed: () => bloc.printTransaction(context, widget.data),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}