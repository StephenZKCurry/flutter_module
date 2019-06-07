import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_flutter/homepage.dart';
import 'dart:convert';

void main() {
  runApp(_widgetForRoute(window.defaultRouteName));
}

Widget _widgetForRoute(String url) {
  String route = _getRouteName(url);
  Map<String, dynamic> params = _getParamsStr(url);
  switch (route) {
    case 'route1':
      return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF008577),
          primaryColorDark: Color(0xFF00574B),
        ),
        home: HomePage(route, params),
      );
    default:
      return MaterialApp(
        home: Center(
          child:
              Text('Unknown route: $route', textDirection: TextDirection.ltr),
        ),
      );
  }
}

// 获取路由名称
String _getRouteName(String s) {
  if (s.indexOf('?') == -1) {
    return s;
  } else {
    return s.substring(0, s.indexOf('?'));
  }
}

// 获取参数
Map<String, dynamic> _getParamsStr(String s) {
  if (s.indexOf('?') == -1) {
    return Map();
  } else {
    return json.decode(s.substring(s.indexOf('?') + 1));
  }
}
