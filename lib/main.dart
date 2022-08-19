import 'package:flutter/material.dart';
import 'package:budget_tracker/pages/login.dart';
import 'package:budget_tracker/pages/home.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => Login(),
      '/home': (context) => Home(),
    }
));

