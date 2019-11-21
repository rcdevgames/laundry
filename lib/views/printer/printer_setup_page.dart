import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:laundry/blocs/print_bloc.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/loading.dart';

class SettingPrinterPage extends StatefulWidget {
  @override
  _SettingPrinterPageState createState() => _SettingPrinterPageState();
}

class _SettingPrinterPageState extends State<SettingPrinterPage> {
  final _key = new GlobalKey<ScaffoldState>();
  final _refreshKey = new GlobalKey<RefreshIndicatorState>();
  final bloc = BlocProvider.getBloc<PrintBloc>();

  @override
  void initState() { 
    super.initState();
    bloc.fetchAllDevice();
  }

  @override
  void dispose() { 
    super.dispose();
    BlocProvider.disposeBloc<PrintBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Printer Setting", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          StreamBuilder<BluetoothDevice>(
          stream: bloc.getDevice,
            builder: (context, snapshot) {
              return FlatButton(
                colorBrightness: Brightness.dark,
                child: Text("Test Print"),
                onPressed: !snapshot.hasData ? null : bloc.testPrint,
              );
            }
          )
        ],
      ),
      body: StreamBuilder(
        stream: bloc.getDevices,
        builder: (context, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              key: _refreshKey,
              onRefresh: bloc.fetchAllDevice,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return StreamBuilder<List<bool>>(
                    stream: bloc.getLoading,
                    builder: (context, loading) {
                      return ListTile(
                        leading: Icon(Icons.bluetooth),
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].address),
                        trailing: StreamBuilder<BluetoothDevice>(
                          stream: bloc.getDevice,
                          builder: (context, val) {
                            if (val.hasData) {
                              if (val.data.address == snapshot.data[index].address) {
                                return RaisedButton(
                                  colorBrightness: Brightness.dark,
                                  color: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  onPressed: loading.hasData && loading.data[index] ? null : () => bloc.disconnect(context, index),
                                  child: Text(loading.hasData && loading.data[index] ? "Disconnecting" : "Disconnected"),
                                );  
                              } return SizedBox();
                            } else{
                              return RaisedButton(
                                colorBrightness: Brightness.dark,
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                onPressed: loading.hasData && loading.data[index] ? null : () => bloc.connect(context, snapshot.data[index], index),
                                child: Text(loading.hasData && loading.data[index] ? "Connecting" : "Connect"),
                              );
                            }
                          }
                        ),
                      );
                    }
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorPage(
                onPressed: () {
                  bloc.setDevices(null);
                  bloc.fetchAllDevice();
                },
                buttonText: "Ulangi",
                message: snapshot.error.toString(),
              ),
            );
          } return LoadingBlock();
        }
      ),
    );
  }
}