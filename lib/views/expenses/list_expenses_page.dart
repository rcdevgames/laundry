import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/expense_bloc.dart';
import 'package:laundry/models/expenses_model.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/load_animation.dart';
import 'package:laundry/widget/loading.dart';

class ExpensesListPage extends StatefulWidget {
  @override
  _ExpensesListPageState createState() => _ExpensesListPageState();
}

class _ExpensesListPageState extends State<ExpensesListPage> {
  final _key = new GlobalKey<ScaffoldState>();
  final _refreshKey = new GlobalKey<RefreshIndicatorState>();
  final bloc = BlocProvider.getBloc<ExpenseBloc>();

  @override
  void initState() { 
    super.initState();
    bloc.fetchData();
  }

  @override
  void dispose() { 
    super.dispose();
    BlocProvider.disposeBloc<ExpenseBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text("Pengeluaran", style: TextStyle(color: Colors.white)),
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: RefreshIndicator(
            key: _refreshKey,
            onRefresh: bloc.fetchData,
            child: StreamBuilder(
              stream: bloc.getExpenses,
              builder: (context, AsyncSnapshot<Expenses> snapshot) {
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
                            Text("10", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                            Text("Nov 2019", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        title: Text("${snapshot.data.data[i]?.name} (${rupiah(snapshot.data.data[i]?.expenses)})"),
                        subtitle: Text(snapshot.data.data[i].description??""),
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
                        bloc.setExpenses(null);
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
            stream: bloc.getExpenses,
            builder: (context, AsyncSnapshot<Expenses> snapshot) {
              if (snapshot.hasData) {
                return FloatingActionButton(
                  onPressed: () => navService.navigateTo("/form-expense"),
                  child: Icon(Icons.add, color: Colors.white),
                );
              } return SizedBox();
            }
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            height: 35,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 1, color: Colors.lightBlue))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Total Pengeluaran", style: TextStyle(fontWeight: FontWeight.w500)),
                StreamBuilder(
                  initialData: 0,
                  stream: bloc.getTotal,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    return Text(rupiah(snapshot.data), style: TextStyle(fontWeight: FontWeight.w900));
                  }
                ),
              ],
            ),
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