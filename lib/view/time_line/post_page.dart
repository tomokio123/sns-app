import 'package:flutter/material.dart';
import 'package:sns_app/model/post.dart';
import 'package:sns_app/utils/authentication.dart';
import 'package:sns_app/utils/firestore/posts.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規投稿',style: TextStyle(color: Colors.black),),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 3,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              // controllerプロパティによって入力値を管理したり、制限したりできる
              controller: contentController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                if(contentController .text.isNotEmpty){
                  Post newPost = Post(
                    content: contentController.text,
                    postAccountId: Authentication.myAccount!.id,
                  );
                  var result = await PostFireStore.addPost(newPost);//newPostをaddPostを呼び出すことで送ってあげる
                  if(result == true){//resultに返ってきた値がtrueなら遷移する。
                    Navigator.pop(context);
                  }
                }
              },
              child: Text('投稿'),
            )
          ],
        ),
      ),
    );
  }
}
