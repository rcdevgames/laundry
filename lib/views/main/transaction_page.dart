import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/transaction_bloc.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/models/transaction_model.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/util/validator.dart';
import 'package:laundry/widget/error_page.dart';
import 'package:laundry/widget/load_animation.dart';
import 'package:laundry/widget/loading.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:responsive_screen/responsive_screen.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> with SingleTickerProviderStateMixin, ValidationMixin {
  final _key = new GlobalKey<ScaffoldState>();
  final _form = new GlobalKey<FormState>();
  final _refreshKey = new GlobalKey<RefreshIndicatorState>();
  final _refreshKey1 = new GlobalKey<RefreshIndicatorState>();
  final bloc = BlocProvider.getBloc<TransactionBloc>();
  final _product = new TextEditingController();
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
    _tabController.addListener(() => print(_tabController.index));
  }

  @override
  void dispose() { 
    super.dispose();
    _tabController.dispose();
    BlocProvider.disposeBloc<TransactionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Trasanction", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight - 15),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Transaksi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Status", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Riwayat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              )
            ],
          )
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                        child: Stack(
                          children: <Widget>[
                            TextFormField(
                              controller: _product,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: "Nama Produk",
                                contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.search, color: Colors.grey),
                                onPressed: () async {
                                  Product data = await navService.navigateTo("/list-product");
                                  if (data != null) {
                                    _product.text = data.name;
                                    bloc.setProductID(data.id);
                                  }
                                }
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                        child: TextFormField(
                          validator: validateRequiredNumber,
                          onSaved: bloc.setName,
                          decoration: InputDecoration(
                            labelText: "Jumlah (Kg)",
                            contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 26, 6),
                        child: StreamBuilder(
                          stream: bloc.getPage,
                          builder: (context, AsyncSnapshot<int> snapshot) {
                            return Row(
                              children: <Widget>[
                                Radio(
                                  value: 0,
                                  groupValue: snapshot.data,
                                  onChanged: bloc.setPage,
                                ),
                                Text(
                                  'Customer Baru',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                Expanded(child: SizedBox()),
                                Radio(
                                  value: 1,
                                  groupValue: snapshot.data,
                                  onChanged: bloc.setPage,
                                ),
                                Text(
                                  'Customer Lama',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                )
                              ],
                            );
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                        child: StreamBuilder(
                          stream: bloc.getPage,
                          builder: (context, AsyncSnapshot<int> snapshot) {
                            if (snapshot.data == 0) {
                              return Column(
                                children: <Widget>[
                                  TextFormField(
                                    validator: validateRequired,
                                    onSaved: bloc.setName,
                                    decoration: InputDecoration(
                                      labelText: "Name",
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: validateRequired,
                                    onSaved: bloc.setEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: validateRequired,
                                    onSaved: bloc.setPhone,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: "Nomor HP",
                                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                                    ),
                                  )
                                ],
                              );
                            } else if (snapshot.data == 1) {
                              return StreamBuilder(
                                stream: bloc.getCustomer,
                                builder: (context, AsyncSnapshot<List<Customer>> snapshot) {
                                  return StreamBuilder(
                                    stream: bloc.getCustomerID,
                                    builder: (context, AsyncSnapshot<String> data) {
                                      return DropdownButtonFormField<String>(
                                        validator: validateRequired,
                                        onChanged: bloc.setCustomer,
                                        value: data.data,
                                        items: snapshot.hasData ? snapshot.data.map((i) => DropdownMenuItem(
                                          value: i.id,
                                          child: Text(i.name),
                                        )).toList():[],
                                        decoration: InputDecoration(
                                          labelText: "Pilih Customer"
                                        ),
                                      );
                                    }
                                  );
                                }
                              );
                            } return SizedBox();
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                        child: RaisedButton(
                          color: Colors.lightBlue,
                          colorBrightness: Brightness.dark,
                          onPressed: () => bloc.doTransaction(_form),
                          child: SizedBox(
                            width: wp(100),
                            height: 40,
                            child: Center(child: Text("Simpan", style: TextStyle(fontSize: 16)))
                          ),
                        ),
                      )
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
          ),
          StreamBuilder(
            stream: bloc.getProcessTRX,
            builder: (context, AsyncSnapshot<Transactions> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: bloc.fetchProcessTrasaction,
                  child: LazyLoadScrollView(
                    onEndOfPage: () => (snapshot.hasData && snapshot.data.nextPageUrl != null) ? bloc.fetchProcessTrasaction(snapshot.data.nextPageUrl) : null,
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
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Status", style: TextStyle(fontSize: 10)),
                              Icon(Icons.timelapse),
                              Text("On Process", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800))
                            ],
                          ),
                          onTap: () => null,
                        ),
                      ),
                    ),
                  ),
                );
              } if (snapshot.hasError) {
                return ErrorPage(
                  onPressed: () => null,
                  buttonText: "Ulangi",
                  message: snapshot.error,
                );
              } return ListView.builder(
                itemCount: 3,
                // separatorBuilder: (ctx, i) => Divider(),
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    title: Skeleton(height: 10, width: 120),
                    subtitle: Skeleton(height: 10, width: 200),
                  ),
                ),
              );
            }
          ),
          StreamBuilder(
            stream: bloc.getCompleteTRX,
            builder: (context, AsyncSnapshot<Transactions> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  key: _refreshKey1,
                  onRefresh: bloc.fetchCompleteTransaction,
                  child: LazyLoadScrollView(
                    onEndOfPage: () => (snapshot.hasData && snapshot.data.nextPageUrl != null) ? bloc.fetchProcessTrasaction(snapshot.data.nextPageUrl) : null,
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
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Status", style: TextStyle(fontSize: 10)),
                              Icon(Icons.check),
                              Text("Complete", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800))
                            ],
                          ),
                          onTap: () => null,
                        ),
                      ),
                    ),
                  ),
                );
              } if (snapshot.hasError) {
                return ErrorPage(
                  onPressed: () => null,
                  buttonText: "Ulangi",
                  message: snapshot.error,
                );
              } return ListView.builder(
                itemCount: 3,
                // separatorBuilder: (ctx, i) => Divider(),
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    title: Skeleton(height: 10, width: 120),
                    subtitle: Skeleton(height: 10, width: 200),
                  ),
                ),
              );
            }
          )
        ],
      ),
    );
  }
}