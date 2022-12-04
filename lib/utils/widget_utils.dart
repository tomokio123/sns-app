import 'package:flutter/material.dart';

class WidgetUtils{
  static AppBar createAppBar(String title){
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,//AppBarは元々影ができているのでその影を０にする
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(title,style: TextStyle(color: Colors.black)),
        centerTitle: true,
      );
  }
}