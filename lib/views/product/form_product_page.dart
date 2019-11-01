import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:laundry/blocs/product_bloc.dart';
import 'package:laundry/models/product_model.dart';
import 'package:laundry/util/validator.dart';
import 'package:laundry/widget/loading.dart';
import 'package:responsive_screen/responsive_screen.dart';

class FormProductPage extends StatefulWidget {
  Product product;
  FormProductPage([this.product]);

  @override
  _FormProductPageState createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> with ValidationMixin {
  final _key = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final bloc = BlocProvider.getBloc<ProductBloc>();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _total_time = TextEditingController();

  @override
  void initState() { 
    super.initState();
    if (widget.product != null) {
      _name.text = widget.product.name;
      _price.text = widget.product.price.toString();
      _total_time.text = widget.product.totalTime.toString();
      bloc.setTime(widget.product.time);
    }
  }

  @override
  void dispose() {
    super.dispose();
    bloc.reset();
    _name.dispose();
    _price.dispose();
    _total_time.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(widget.product != null ? "Ubah Produk" : "Tambah Produk", style: TextStyle(color: Colors.white)),
            brightness: Brightness.dark,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: _name,
                    validator: validateRequired,
                    onSaved: bloc.setName,
                    decoration: InputDecoration(
                      labelText: "Nama Product",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: _price,
                    validator: validateRequiredNumber,
                    onSaved: (i) => bloc.setPrice(int.parse(i)),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Harga",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    initialData: widget.product?.time,
                    stream: bloc.getTime,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return DropdownButtonFormField<String>(
                        validator: validateRequired,
                        value: snapshot.data,
                        onChanged: bloc.setTime,
                        decoration: InputDecoration(
                          labelText: "Satuan Lama Pengerjaan",
                          contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 0, 16.0),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: "jam",
                            child: Text("Jam"),
                          ),
                          DropdownMenuItem(
                            value: "hari",
                            child: Text("Hari"),
                          ),
                        ],
                      );
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: _total_time,
                    validator: validateRequiredNumber,
                    onSaved: (i) => bloc.setTotalTime(int.parse(i)),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Lama Pengerjaan",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => widget.product != null ? bloc.editData(_form, widget.product.id) : bloc.addData(_form),
            child: Icon(Icons.save, color: Colors.white),
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