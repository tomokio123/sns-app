import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/utils/authentication.dart';
import 'package:sns_app/utils/firestore/users.dart';
import 'package:sns_app/utils/widget_utils.dart';
import 'package:sns_app/view/screen.dart';

class CheckEmailPage extends StatefulWidget {//StatefulWidget = 元となるクラスとStateのクラスの二つからなるWidget
  //State　のクラスでフィールド変数(email, pass)を使おうとすると「widget.」を最初につけないとけない。
  //(元となるクラスで暗黙にフィールド変数を「widget」というオブジェクトに格納している)
  final String email;
  final String pass;
  CheckEmailPage({required this.email, required this.pass});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレスを確認'),
      body: Column(
        children: [
          Text('登録メール宛に確認メールを送信しました。確認お願いいたします'),
          ElevatedButton(
              onPressed: () async{
                var result = await Authentication.emailSignIn(email: widget.email, password: widget.pass);
                if(result is UserCredential){//「UserCredential型なら」
                  if(result.user!.emailVerified == true){//email認証が終わってtrueが返ってきたら
                    while(Navigator.canPop(context)){//popできるまで回して遷移
                      Navigator.pop(context);
                    }
                    await UserFireStore.getUser(result.user!.uid);//ユーザ取得ができたら
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                    //ホームへ戻る
                  } else {//email認証が終わらず完了しなかったら
                    print('メール認証未完了');
                  }
                }
              },
              child: Text('認証完了')
          )
        ],
      ),
    );
  }
}
