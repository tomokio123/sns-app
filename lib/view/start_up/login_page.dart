import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
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
                    hintText: 'メールアドレス'
                  ),
                  controller: emailController,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                      hintText: 'パスワード'
                  ),
                  controller: passController,
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
                            print('アカウント作成');
                          }
                      )
                    ]
                  )
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed:(){
                    //pushReplacementは「遷移後に前のページに戻れなくなる」ナビゲーション
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Screen())
                    );
                  },
                  child: const Text('emailでLogin'))
            ],
          ),
        ),
      ),
    );
  }
}
