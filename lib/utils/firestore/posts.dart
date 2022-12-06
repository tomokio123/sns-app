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

  static Future<List<Post>?> getPostsFromIds(List<String> ids) async{//id = (全ての投稿が格納される)から自分の投稿を取得するメソッド
    //null を返す可能性があるのでnull許容型のList<Post?>としておく。
    //returnでのpostListは返ってくるまで型が決まらないと考えて、<dynamic型>にしておく
    List<Post> postList = [];
    try {
      await Future.forEach(ids, (String id) async{//送られてきたidsの数だけ処理を行う
        var doc =  await posts.doc(id).get();//「doc」にpostsオブジェクトに格納されているid一致するものを取得して格納
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        //doc(Object型)のdataをMap型に変換する
        Post post = Post(//postオブジェクトにdocの情報を各々格納する
          //元々用意されていたid:,content　などのプロパティ(輪郭)にdoc.〇〇として具体的なデータを埋めていってる感じ(色塗っている)
          id: doc.id,
          content: data['content'],
          postAccountId: data['post_account_id'],
          createdTime: data['created_time']
        );
        //自分の投稿をpostオブジェクトに格納できたのでその自分の投稿たちをpostListに加え、整える。
        postList.add(post);
      });
      print('自分の投稿を取得完了');
      return postList;// 取得したpostListを返す
    } on FirebaseException catch(e){
      print('自分の投稿取得エラー $e');
      return null;
    }
  }

}