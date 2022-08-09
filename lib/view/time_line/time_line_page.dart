import 'package:flutter/material.dart';
import 'package:sns_app/model/account.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  Account myAccount = Account(
    id: '1',
    name: 't.fukuyama',
    selfIntroduction: 'Hello!',
    userId: 't.fukuyama',
    createdTime: DateTime.now(),
    updatedTime: DateTime.now() //Accountのインスタンス作成
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('タイムライン')),
    );
  }
}
