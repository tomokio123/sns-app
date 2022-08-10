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
    imagePath: 'https://www.google.com/imgres?imgurl=https%3A%2F%2Fmasafumi-blog.com%2Fwp-content%2Fuploads%2F2020%2F09%2FFlutter_%25E3%2583%25AD%25E3%2582%25B4.png&imgrefurl=https%3A%2F%2Fmasafumi-blog.com%2Fbuilding-application-dev-env-flutter&tbnid=QGLEy5YWSR1aoM&vet=12ahUKEwiYyJm18Ln5AhXnRvUHHaUeBjoQMygGegUIARDKAQ..i&docid=p8DKYyoU8kK09M&w=2856&h=2193&q=Flutter%20lab&ved=2ahUKEwiYyJm18Ln5AhXnRvUHHaUeBjoQMygGegUIARDKAQ',
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
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(myAccount.imagePath),
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
