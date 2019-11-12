import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/transaction_bloc.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/loading.dart';
import 'package:loader_search_bar/loader_search_bar.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final _key = new GlobalKey<ScaffoldState>();
  final _refreshKey = new GlobalKey<RefreshIndicatorState>();
  final bloc = BlocProvider.getBloc<TransactionBloc>();

  @override
  void initState() { 
    super.initState();
    bloc.fetchCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: SearchBar(
        defaultBar: AppBar(
          title: Text("Daftar Customer", style: TextStyle(color: Colors.white)),
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        onQueryChanged: (query) {
          bloc.filterCustomer(query);
        },
        searchHint: "Cari Kata Kunci..",
      ),
      body: StreamBuilder(
        stream: bloc.getCustomer,
        builder: (context, AsyncSnapshot<List<Customer>> snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              key: _refreshKey,
              onRefresh: bloc.fetchProducts,
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    onTap: () => Navigator.pop(context, snapshot.data[i]),
                    title: Text(snapshot.data[i].name??""),
                    subtitle: Text(snapshot.data[i].phoneNumber??""),
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