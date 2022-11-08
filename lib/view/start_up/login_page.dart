import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/utils/authentication.dart';
import 'package:sns_app/view/start_up/create_account_page.dart';

import '../screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text('LoginPage',style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'メールアドレス',
                    ),
                    controller: emailController,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: 'パスワード',
                        helperText: '※パスワードは6文字以上必要です'
                    ),
                    controller: passController,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 10),
                RichText( //テキストの一部だけ色やサイズなどを変えられるWidget
                    text: TextSpan(//キーワードなどをハイライト(強調)表示するWidget
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'アカウント作成していない方は'),
                        TextSpan(text: 'こちら',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
                            }
                        )
                      ]
                    )
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed:() async{
                      var result = await Authentication.emailSignIn(email: emailController.text, password: passController.text);
                      if(result == true){
                        //pushReplacementは「遷移後に前のページに戻れなくなる」ナビゲーション
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Screen())
                        );
                      }
                    },
                    child: const Text('emailでLogin'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
