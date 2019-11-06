import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  
  Future<dynamic> navigateTo(String routeName, [Object arguments]) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }
  Future<dynamic> navigateReplaceTo(String routeName, [Object arguments]) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false, arguments: arguments);
  }
  navigatePop([bool toRoot = false]) {
    if (toRoot) {
      navigatorKey.currentState.popUntil((r) => r.isFirst);
    }else{
      navigatorKey.currentState.pop();
    }
  }
}
final navService = new NavigationService();