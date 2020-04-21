import 'package:flutter/material.dart';
import './ui/home.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
 return MaterialApp(
 debugShowCheckedModeBanner: false,
 title: 'Tambahkan Data Pembeli',
 theme: ThemeData(
 primarySwatch: Colors.lightBlue,
 ),
 home: Home(),
 );
 }
}