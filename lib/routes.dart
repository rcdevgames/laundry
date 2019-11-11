import 'package:flutter/material.dart';
import 'package:laundry/views/auth/login_page.dart';
import 'package:laundry/views/customer/form_customer_page.dart';
import 'package:laundry/views/customer/list_customer_page.dart';
import 'package:laundry/views/expenses/form_expenses_page.dart';
import 'package:laundry/views/expenses/list_expenses_page.dart';
import 'package:laundry/views/main/layout_page.dart';
import 'package:laundry/views/product/form_product_page.dart';
import 'package:laundry/views/product/list_product_page.dart';
import 'package:laundry/views/report/report_page.dart';
import 'package:laundry/views/transaction/product_list_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login": return MaterialPageRoute(builder: (_) => LoginPage());
      case "/main": return MaterialPageRoute(builder: (_) => LayoutPage());
      case "/products": return MaterialPageRoute(builder: (_) => ProductListPage());
      case "/form-product": 
        var args = settings.arguments;
        return MaterialPageRoute(builder: (_) => FormProductPage(args));
      case "/customers": return MaterialPageRoute(builder: (_) => CustomerListPage());
      case "/form-customer": 
        var args = settings.arguments;
        return MaterialPageRoute(builder: (_) => CustomerFormPage(args));
      case "/expenses": return MaterialPageRoute(builder: (_) => ExpensesListPage());
      case "/form-expense": 
        var args = settings.arguments;
        return MaterialPageRoute(builder: (_) => ExpensesFormPage(args));
      case "/list-product": return MaterialPageRoute(builder: (_) => ProductList());
      case "/report": return MaterialPageRoute(builder: (_) => ReportPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
    }
  }
}