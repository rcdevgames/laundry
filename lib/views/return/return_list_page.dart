import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:bn_refresh_indicator/bn_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/return_bloc.dart';
import 'package:laundry/models/transaction_model.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/loading.dart';

class RetrurnListPage extends StatefulWidget {
  @override
  _RetrurnListPageState createState() => _RetrurnListPageState();
}

class _RetrurnListPageState extends State<RetrurnListPage> {
  final _key = new GlobalKey<ScaffoldState>();
  final _refreshKey = new BnRefreshController();
  final bloc = BlocProvider.getBloc<ReturnBloc>();

  @override
  void initState() { 
    super.initState();
    bloc.fetchProcessTrasaction();
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.disposeBloc<ReturnBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text("Daftar Pengembalian", style: TextStyle(color: Colors.white)),
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: StreamBuilder(
            stream: bloc.getProcessTRX,
            builder: (context, AsyncSnapshot<Transactions> snapshot) {
              if (snapshot.hasData) {
                return BnRefreshIndicator(
                  refreshController: _refreshKey,
                  onRefresh: bloc.fetchProcessTrasaction,
                  onLoadMore: () => (snapshot.hasData && snapshot.data.nextPageUrl != null) ? bloc.fetchProcessTrasaction(snapshot.data.nextPageUrl) : null,
                  child: ListView.builder(
                    itemCount: snapshot.data.data.length,
                    // separatorBuilder: (ctx, i) => Divider(),
                    itemBuilder: (ctx, i) => Card(
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Tanggal", style: TextStyle(fontSize: 10)),
                            Text(snapshot.data.data[i].createdAt.day.toString(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            Text(tanggal(snapshot.data.data[i].createdAt).split(" ")[1] +" "+tanggal(snapshot.data.data[i].createdAt).split(" ")[2], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800))
                          ],
                        ),
                        title: Text(snapshot.data.data[i].invoiceNo),
                        subtitle: Text(rupiah(snapshot.data.data[i].amount)),
                        trailing: IconButton(
                          icon: Icon(FontAwesomeIcons.undo),
                          onPressed: () => showAlert(
                            context: context,
                            barrierDismissible: false,
                            title: "Pengembalian",
                            body: "Apakah anda yakin?",
                            actions: [
                              AlertAction(
                                text: "Cancel",
                                onPressed: () => null
                              ),
                              AlertAction(
                                text: "Confirm",
                                onPressed: () => bloc.doFinish(context, snapshot.data.data[i].id)
                              )
                            ]
                          ),
                        ),
                      )
                    ),
                  ),
                );
              } if (snapshot.hasError) {
                return ErrorPage(
                  onPressed: () => null,
                  buttonText: "Ulangi",
                  message: snapshot.error,
                );
              } return LoadingBlock();
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