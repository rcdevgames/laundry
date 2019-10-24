import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:laundry/blocs.dart';
import 'package:laundry/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: blocs,
      child: MaterialApp(
        title: 'Loandry',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.lightBlue),
        home: Scaffold(
          appBar: AppBar(),
        ),
        onGenerateRoute: Routes.generateRoute,
        // navigatorKey: ,
      ),
    );
  }
}