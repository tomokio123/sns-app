import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/post.dart';

class PostFireStore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference posts = _firestoreInstance.collection('posts');
  //posts = いろんなユーザーのPostが入っているコレクション

  static Future<dynamic> addPost(Post newPost) async{
    try{
      //my_posts = 自分だけのPostが入っているコレクション
      final CollectionReference _userPosts = _firestoreInstance.collection('users').doc(newPost.postAccountId).collection('users')
          .doc(newPost.postAccountId).collection('my_posts');
      var result = await posts.add({//resultにはみんなのPostのドキュメントの情報を格納している。
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
      });
      _userPosts.doc(result.id).set({//resultドキュメントのidを用いて自分のmyPostsにも以下のデータを保存(.set)するようにしている。
        'post_id': result.id,//idが同じPostを保存していく。
        'created_time': Timestamp.now()
      });
      print('投稿完了');
      return true;
    } on FirebaseException catch(e){
      print('投稿エラー： $e');
      return false;
    }
  }

}