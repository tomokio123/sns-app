import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';
import '../../model/post.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  Account myAccount = Account(
      id: '1',
      name: '福山',
      selfIntroduction: 'Hello!',
      imagePath: '/Users/fukuyamatomoki/StudioProjects/sns_app/lib/assets/IMG_3621.jpg',
      userId: 't.fukuyama',
      createdTime: DateTime.now(),
      updatedTime: DateTime.now() //Accountのインスタンス作成
  );

  List<Post> postList = [
    Post(
        id: '1',
        content: 'Hello World1!',
        postAccountId: '1',
        createdTime: DateTime.now() //Postのインスタンスを作成
    ),

    Post(
        id: '2',
        content: 'Hello World2!',
        postAccountId: '1',
        createdTime: DateTime.now() //Postのインスタンスを作成
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              height: 200,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(myAccount.imagePath)
                            ),
                          color: Colors.white
                        ),
                          width: 110.0,
                          height: 110.0,
                      ),
                      Column(
                        children: [
                          Text(myAccount.name),
                          Text(myAccount.userId)
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
