import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/utils/authentication.dart';
import 'package:sns_app/view/account/edit_account_page.dart';
import '../../model/account.dart';
import '../../model/post.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  Account myAccount = Authentication.myAccount!;

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
        child: SingleChildScrollView(
          //SingleChildScrollViewで囲ったところはスクロールできるよって意味。(ただし高さを指定しないと例外となる)
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            //containerの高さは「画面の高さ」に等しいですよって意味。
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 15,left: 15,top: 20),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  width: 64.0,
                                  height: 64.0,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(myAccount.name),
                                  Text('@${myAccount.userId}')
                                ],
                              )
                            ],
                          ),
                          OutlinedButton(
                              onPressed: () async{
                                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccountPage()));
                                if(result == true){
                                  setState(() {
                                    myAccount = Authentication.myAccount!;
                                  });
                                }
                              },
                              child: const Text('編集')
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(myAccount.selfIntroduction)
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(
                      color: Colors.blue, width: 3
                    ))
                  ),
                  child: const Text('投稿'),
                ),
                Expanded(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      //physics: NeverScrollableScrollPhysics() = 「このWidgetで囲む所はスクロールされない」
                      itemCount: postList.length,
                        itemBuilder: (context, index){
                          return Container(
                            decoration: BoxDecoration(
                                border: index == 0 ? Border(
                                  top: BorderSide(color: Colors.grey,width: 0),
                                  bottom: BorderSide(color: Colors.grey, width: 0),
                                ): Border(bottom: BorderSide(color: Colors.grey, width: 0))
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Row(
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
                                  width: 44.0,
                                  height: 44.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text('${myAccount.name}'),
                                              Text('@${myAccount.userId}'),
                                            ],
                                          ),
                                          Text(DateFormat('M/d/yy').format(postList[index].createdTime!))
                                        ],
                                      ),
                                      Text(postList[index].content)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
