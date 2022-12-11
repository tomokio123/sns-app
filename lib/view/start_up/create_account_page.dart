import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns_app/model/account.dart';
import 'package:sns_app/utils/authentication.dart';
import 'package:sns_app/utils/firestore/users.dart';
import 'package:sns_app/utils/function_utils.dart';
import 'package:sns_app/utils/widget_utils.dart';
import 'package:sns_app/view/start_up/check_email_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();

  File? image; //dart.ioのFile? について調査せよ

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: WidgetUtils.createAppBar('新規登録'),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    var result = await FunctionUtils.getImageFromGallery();
                    if(result != null){
                      setState(() {
                        image = File(result.path);
                      });
                    }
                  },
                  child: CircleAvatar(
                    foregroundImage: image == null ? null : FileImage(image!),
                    radius: 40,
                    child: const Icon(Icons.add),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: '名前'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  child: TextField(
                    controller: userIdController,
                    decoration: const InputDecoration(hintText: 'ユーザーID'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: selfIntroductionController,
                    decoration: const InputDecoration(hintText: '自己紹介'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'メールアドレス'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Container(
                  width: 300,
                  child: TextField(
                    controller: passController,
                    decoration: const InputDecoration(hintText: 'パスワード'),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () async {
                      if(nameController.text.isNotEmpty
                          && userIdController.text.isNotEmpty
                          && selfIntroductionController.text.isNotEmpty
                          && emailController.text.isNotEmpty
                          && passController.text.isNotEmpty
                          && image != null
                      ){
                        var result = await Authentication.signUp(email: emailController.text, pass: passController.text);
                        if(result is UserCredential) {
                          //　「resultに入ってる値の型がUserCredential型なら」って意味
                          String imagePath = await FunctionUtils.uplordImage(result.user!.uid, image!);//uidに加えてimageもおくる。
                          //!でnull回避 await をつけておく一応
                          Account newAccount = Account(
                              id: result.user!.uid,
                              name: nameController.text,
                              userId: userIdController.text,
                              selfIntroduction: selfIntroductionController.text,
                              imagePath: imagePath
                          );
                          var _result = await UserFireStore.setUser(newAccount);
                          if (_result == true) {
                            result.user!.sendEmailVerification();//Emailアドレスにメールを送る処理
                            // uploadが成功し終わってから元の画面に戻るってしたいので
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => CheckEmailPage(
                                    email: emailController.text, pass: passController.text))
                            );
                          }
                        }
                      }
                    },
                    child: const Text('アカウントを作成'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
