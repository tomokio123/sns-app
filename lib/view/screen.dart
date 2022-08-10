import 'package:flutter/material.dart';
import 'package:sns_app/view/time_line/post_page.dart';
import 'package:sns_app/view/time_line/time_line_page.dart';

import 'account/account_page.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int selectedIndex = 0;
  List<Widget> pageList = [TimeLinePage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[selectedIndex],//selectedIndexの番号に準じたPageが表示される
      bottomNavigationBar: BottomNavigationBar(
        items: [//itemsでボトムの選択肢を増やせる
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity_outlined),
              label: ''
          ),
        ],
        currentIndex: selectedIndex,//今有効なIndex(現在のIndexを定義)
        onTap: (index){
          //押されたIdnexの番号が(index)に入って、それをselectedIndexに格納するのがここ
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage()));
        },
        child: Icon(Icons.chat_bubble_outline),
      ),
    );
  }
}
