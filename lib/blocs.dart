import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:laundry/blocs/login_bloc.dart';
import 'package:laundry/blocs/product_bloc.dart';

final List<Bloc<BlocBase>> blocs = [
  Bloc((i) => new LoginBloc()),
  Bloc((i) => new ProductBloc()),
];