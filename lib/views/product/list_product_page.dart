import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/product_bloc.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/load_animation.dart';
import 'package:laundry/widget/loading.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _key = new GlobalKey<ScaffoldState>();
  final _refreshKey = new GlobalKey<RefreshIndicatorState>();
  final bloc = BlocProvider.getBloc<ProductBloc>();

  @override
  void initState() { 
    super.initState();
    bloc.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    BlocProvider.disposeBloc<ProductBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text("Daftar Produk", style: TextStyle(color: Colors.white)),
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: RefreshIndicator(
            key: _refreshKey,
            onRefresh: bloc.fetchData,
            child: StreamBuilder(
              stream: bloc.getProducts,
              builder: (context, AsyncSnapshot<Products> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data.data.length,
                    separatorBuilder: (ctx, i) => Divider(),
                    itemBuilder: (ctx, i) => Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Durasi", style: TextStyle(fontSize: 12)),
                            Text(snapshot.data.data[i].totalTime.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(snapshot.data.data[i].time??"", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        title: Text(snapshot.data.data[i].name),
                        subtitle: Text("Harga : ${rupiah(snapshot.data.data[i].price)}"),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Edit',
                          color: Colors.blue,
                          icon: Icons.edit,
                          onTap: () => navService.navigateTo("/form-product", snapshot.data.data[i]),
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => bloc.deleteData(_key, snapshot.data.data[i].id),
                        ),
                      ],
                    ),
                  );
                } else if(snapshot.hasError) {
                  return Center(
                    child: ErrorPage(
                      message: snapshot.error,
                      buttonText: "Ulangi",
                      onPressed: () {
                        bloc.setProducts(null);
                        bloc.fetchData();
                      },
                    ),
                  );
                } else {
                  return ListView.separated(
                    itemCount: 3,
                    separatorBuilder: (ctx, i) => Divider(),
                    itemBuilder: (ctx, i) => ListTile(
                      title: Skeleton(height: 10, width: 120),
                      subtitle: Skeleton(height: 10, width: 200),
                    ),
                  );
                }
              }
            ),
          ),
          floatingActionButton: StreamBuilder(
            stream: bloc.getProducts,
            builder: (context, AsyncSnapshot<Products> snapshot) {
              if (snapshot.hasData) {
                return FloatingActionButton(
                  onPressed: () => navService.navigateTo("/form-product"),
                  child: Icon(Icons.add, color: Colors.white),
                );
              } return SizedBox();
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