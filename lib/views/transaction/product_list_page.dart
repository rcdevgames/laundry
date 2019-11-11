import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/transaction_bloc.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/load_animation.dart';
import 'package:laundry/widget/loading.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _key = new GlobalKey<ScaffoldState>();
  final _refreshKey = new GlobalKey<RefreshIndicatorState>();
  final _search = new TextEditingController();
  final bloc = BlocProvider.getBloc<TransactionBloc>();

  @override
  void initState() { 
    super.initState();
    bloc.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Daftar Produk", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: bloc.getProduct,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              key: _refreshKey,
              onRefresh: bloc.fetchProducts,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    onTap: () => Navigator.pop(context, snapshot.data[i]),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Durasi", style: TextStyle(fontSize: 12)),
                        Text(snapshot.data[i].totalTime.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(snapshot.data[i].time??"", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    title: Text(snapshot.data[i].name),
                    subtitle: Text("Harga : ${rupiah(snapshot.data[i].price)}"),
                  ),
                ),
              ),
            );
          } else if(snapshot.hasError) {
            return Center(
              child: ErrorPage(
                message: snapshot.error,
                buttonText: "Ulangi",
                onPressed: () {
                  bloc.fetchProducts();
                },
              ),
            );
          } else {
            return LoadingBlock();
          }
        }
      ),
    );
  }
}