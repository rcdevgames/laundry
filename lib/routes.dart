import 'package:flutter/material.dart';
import 'package:laundry/views/auth/login_page.dart';
import 'package:laundry/views/main/layout_page.dart';
import 'package:laundry/views/product/list_product_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login": return MaterialPageRoute(builder: (_) => LoginPage());
      case "/main": return MaterialPageRoute(builder: (_) => LayoutPage());
      case "/products": return MaterialPageRoute(builder: (_) => ProductListPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
    }
  }
}