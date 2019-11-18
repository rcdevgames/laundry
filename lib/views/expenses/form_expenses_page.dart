import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:indonesia/indonesia.dart';
import 'package:laundry/blocs/expense_bloc.dart';
import 'package:laundry/models/expenses_model.dart';
import 'package:laundry/util/validator.dart';

class ExpensesFormPage extends StatefulWidget {
  Expense data;
  ExpensesFormPage([this.data]);

  @override
  _ExpensesFormPageState createState() => _ExpensesFormPageState();
}

class _ExpensesFormPageState extends State<ExpensesFormPage> with ValidationMixin {
  final _key = new GlobalKey<ScaffoldState>();
  final _form = new GlobalKey<FormState>();
  final bloc = BlocProvider.getBloc<ExpenseBloc>();
  
  final _nameCtrl = new TextEditingController();
  final _totalCtrl = new TextEditingController();
  final _descCtrl = new TextEditingController();

  @override
  void initState() { 
    super.initState();
    if (widget.data != null) {
      _nameCtrl.text = widget.data.name;
      _totalCtrl.text = widget.data.expenses.toString();
      _descCtrl.text = widget.data.description;
      bloc.setTime(formatDate(widget.data.time, [yyyy,'-',mm,'-',dd]));
      bloc.setDateTime(widget.data.time);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameCtrl.dispose();
    _totalCtrl.dispose();
    _descCtrl.dispose();
    bloc.reset();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.data != null ? "Ubah Data Pengeluaran" : "Tambah Data Pengeluaran", style: TextStyle(color: Colors.white)),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _form,
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              height: 70,
              child: Row(
                children: <Widget>[
                  StreamBuilder(
                    stream: bloc.getDateTime,
                    builder: (context, AsyncSnapshot<DateTime> snapshot) {
                      return Expanded(
                        child: AnimatedCrossFade(
                          crossFadeState: snapshot.hasData ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                          firstChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Tanggal Pengeluaran", style: TextStyle(color: Colors.black45, fontSize: 17)),
                            ],
                          ),
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Tanggal Pengeluaran", style: TextStyle(color: Colors.grey)),
                              Text(tanggal(snapshot.data??DateTime.now()))
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                  IconButton(
                    color: Colors.lightBlue,
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => bloc.setDate(context),
                  )
                ],
              ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Colors.grey))
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _nameCtrl,
                validator: validateRequired,
                onSaved: bloc.setName,
                decoration: InputDecoration(
                  labelText: "Nama Pengeluaran",
                  contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _totalCtrl,
                validator: validateRequiredNumber,
                onSaved: bloc.setExpense,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Total Pengeluaran",
                  contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: _descCtrl,
                validator: validateRequired,
                onSaved: bloc.setDesc,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Keterangan",
                  contentPadding: EdgeInsets.fromLTRB(10.0, 16.0, 20.0, 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.data != null ? bloc.editData(_form, widget.data.id) : bloc.addData(_form),
        child: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}