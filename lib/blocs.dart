import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:laundry/blocs/customer_bloc.dart';
import 'package:laundry/blocs/expense_bloc.dart';
import 'package:laundry/blocs/login_bloc.dart';
import 'package:laundry/blocs/print_bloc.dart';
import 'package:laundry/blocs/product_bloc.dart';
import 'package:laundry/blocs/report_bloc.dart';
import 'package:laundry/blocs/return_bloc.dart';
import 'package:laundry/blocs/transaction_bloc.dart';
import 'package:laundry/blocs/user_bloc.dart';

final List<Bloc<BlocBase>> blocs = [
  Bloc((i) => new LoginBloc()),
  Bloc((i) => new ProductBloc()),
  Bloc((i) => new CustomerBloc()),
  Bloc((i) => new ExpenseBloc()),
  Bloc((i) => new TransactionBloc()),
  Bloc((i) => new ReportBloc()),
  Bloc((i) => new ReturnBloc()),
  Bloc((i) => new UserBloc()),
  Bloc((i) => new PrintBloc()),
];