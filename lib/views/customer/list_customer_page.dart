import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:laundry/blocs/customer_bloc.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/load_animation.dart';
import 'package:laundry/widget/loading.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:loader_search_bar/loader_search_bar.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final _key = new GlobalKey<ScaffoldState>();
  final _refreshKey = new GlobalKey<RefreshIndicatorState>();
  final bloc = BlocProvider.getBloc<CustomerBloc>();

  @override
  void initState() { 
    super.initState();
    bloc.fetchData();
  }

  @override
  void dispose() { 
    super.dispose();
    BlocProvider.disposeBloc<CustomerBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _key,
          appBar: SearchBar(
            defaultBar: AppBar(
              title: Text("Daftar Customer", style: TextStyle(color: Colors.white)),
              brightness: Brightness.dark,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            onQuerySubmitted: (query) {
              bloc.setCustomers(null);
              bloc.fetchData(query);
            },
            searchHint: "Cari Kata Kunci..",
          ),
          body: RefreshIndicator(
            key: _refreshKey,
            onRefresh: bloc.fetchData,
            child: StreamBuilder(
              stream: bloc.getCustomers,
              builder: (context, AsyncSnapshot<Customers> snapshot) {
                if (snapshot.hasData) {
                  return LazyLoadScrollView(
                    onEndOfPage: () => (snapshot.hasData && snapshot.data.nextPageUrl != null) ? bloc.loadMore(snapshot.data.nextPageUrl) : null,
                    child: ListView.separated(
                      itemCount: snapshot.data.data.length,
                      separatorBuilder: (ctx, i) => Divider(),
                      itemBuilder: (ctx, i) => Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: ListTile(
                          title: Text(snapshot.data.data[i].name??""),
                          subtitle: Text(snapshot.data.data[i].phoneNumber??""),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.blue,
                            icon: Icons.edit,
                            onTap: () => navService.navigateTo("/form-customer", snapshot.data.data[i]??null),
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => bloc.deleteCustomer(_key, snapshot.data.data[i].id??0),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if(snapshot.hasError) {
                  return Center(
                    child: ErrorPage(
                      message: snapshot.error,
                      buttonText: "Ulangi",
                      onPressed: () {
                        bloc.setCustomers(null);
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
            stream: bloc.getCustomers,
            builder: (context, AsyncSnapshot<Customers> snapshot) {
              if (snapshot.hasData) {
                return FloatingActionButton(
                  onPressed: () => navService.navigateTo("/form-customer"),
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