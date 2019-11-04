import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:laundry/blocs/customer_bloc.dart';
import 'package:laundry/models/customer_model.dart';
import 'package:laundry/util/validator.dart';
import 'package:laundry/widget/loading.dart';
import 'package:responsive_screen/responsive_screen.dart';

class CustomerFormPage extends StatefulWidget {
  Customer data;
  CustomerFormPage([this.data]);

  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> with ValidationMixin {
  final _key = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final bloc = BlocProvider.getBloc<CustomerBloc>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  @override
  void initState() { 
    super.initState();
    if (widget.data != null) {
      _name.text = widget.data.name;
      _email.text = widget.data.email;
      _phone.text = widget.data.phoneNumber.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    bloc.reset();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(widget.data != null ? "Ubah Data Customer" : "Tambah Data Customer", style: TextStyle(color: Colors.white)),
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
                      labelText: "Nama Customer",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: _email,
                    validator: validateEmail,
                    onSaved: bloc.setEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: _phone,
                    validator: validateRequiredNumber,
                    onSaved: bloc.setPhone,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Nomor HP",
                      contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => widget.data != null ? bloc.editCustomer(_form, widget.data.id) : bloc.addCustomer(_form),
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