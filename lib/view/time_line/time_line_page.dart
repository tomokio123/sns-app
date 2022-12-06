import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/model/account.dart';
import 'package:sns_app/model/post.dart';
import 'package:sns_app/utils/firestore/posts.dart';
import 'package:sns_app/utils/firestore/users.dart';
import 'package:sns_app/view/time_line/post_page.dart';

class TimeLinePage extends StatefulWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('タイムライン',style: TextStyle(color: Colors.black),),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 3,
      ),
      body: StreamBuilder<QuerySnapshot>(//QuerySnapshotとは？そもそも
        stream: PostFireStore.posts.orderBy('created_time',descending: true).snapshots(),//postsドキュメントに追加されるたびにbuilderが動く
        builder: (context, postSnapshot) {
          if(postSnapshot.hasData){
            //以下、どのユーザーが投稿しているのかをチェックする必要がある。
            List<String> postAccountIds = [];
            postSnapshot.data!.docs.forEach((doc) {//docsの数だけforEachを回す。
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;//キャストしている
              if(!postAccountIds.contains(data['post_account_id'])){
                //!postAccountIdsに'post_account_id'というデータが含まれていなかった(!)ら、
                postAccountIds.add(data['post_account_id']);
                //postAccountIdsに追加↑(誰が投稿したのか」を追加)
              }
            });
            return FutureBuilder<Map<String, Account>?>(
              future: UserFireStore.getPostUserMap(postAccountIds),//futureやStreamプロパティはbuilderを発火させるための基準みたいなもん
                //ここではUserFireStoreのgetPostUserMap(postAccountIds)メソッドから返ってくる値に変更があったらbuilderが作動する
              builder: (context, userSnapshot) {
                if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                  //snapshot.connectionState(情報の取得状況)　が、ConnectionState.done(完了状態)　であるとき
                  return ListView.builder(
                    //itemの数はpostSnapshotの数が欲しい。(userSnapshotの数ではない）
                      itemCount: postSnapshot.data!.docs.length,//itemの数＝docsの長さ分
                      itemBuilder: (content, index){
                        Map<String, dynamic> data = postSnapshot.data!.docs[index].data() as Map<String ,dynamic>;//表示する内容
                        Post post = Post(
                          id: postSnapshot.data!.docs[index].id,
                          content: data['content'],
                          postAccountId: data['post_account_id'],
                          createdTime: data['created_time'],
                        );
                        Account postAccount = userSnapshot.data![post.postAccountId]!;
                        //ユーザーみなさんのデータを取得し、その中の探したいIDは「postのpostAccountId」である
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
                                        //59行目　Account postAccount = userSnapshot.data![post.postAccountId]!;による
                                        // ↓投稿の主のデータを入れる　「postAccount」のimagePath
                                        image: AssetImage(postAccount.imagePath)
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
                                              Text('${postAccount.name}'),
                                              Text('@${postAccount.userId}'),
                                            ],
                                          ),
                                          Text(DateFormat('M/d/yy').format(post.createdTime!.toDate()))
                                          //DateTime型じゃないとだめ。よってTimestamp型をDateTime型に変換せよ(　.toDate()　の部分)
                                          //対象になっている投稿　＝　５３行」目あたりの　Post post = Post()　の部分なので
                                          //「postAccount」ではなく、「post
                                        ],
                                      ),
                                      Text(post.content)
                                      //対象になっている投稿　＝　５３行」目あたりの　Post post = Post()　の部分なので
                                      //よって「postAccount」ではなく、「post
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  );
                } else {
                  return Container();
                }
              }
            );
          } else {
            return Container();
          }
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
