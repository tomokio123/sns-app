import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/model/account.dart';
import 'package:sns_app/model/post.dart';
import 'package:sns_app/view/time_line/post_page.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
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
      appBar: AppBar(
        title: Text('タイムライン',style: TextStyle(color: Colors.black),),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 3,
      ),
      body: ListView.builder(
          itemCount: postList.length,
          itemBuilder: (content, index){
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
                    child: Container(
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
                  ),
                ],
              ),
            );
          }
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
