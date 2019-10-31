import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry/blocs.dart';
import 'package:laundry/routes.dart';
import 'package:laundry/util/nav_service.dart';
import 'package:laundry/util/session.dart';
import 'package:laundry/views/auth/login_page.dart';
import 'package:laundry/views/main/layout_page.dart';

void main() async {
  //Status Bar Color
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.lightBlueAccent,
  ));
  final auth = await sessions.checkAuth();
  return runApp(MyApp(auth));
}

class MyApp extends StatelessWidget {
  bool auth;
  MyApp([this.auth]);
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: blocs,
      child: MaterialApp(
        title: 'Loandry',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.lightBlue),
        navigatorKey: navService.navigatorKey,
        onGenerateRoute: Routes.generateRoute,
        home: auth ? new LayoutPage() : new LoginPage()
      ),
    );
  }
}