import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_app/model/account.dart';
import 'package:sns_app/utils/authentication.dart';
import 'package:sns_app/utils/firestore/users.dart';
import 'package:sns_app/utils/function_utils.dart';
import 'package:sns_app/utils/widget_utils.dart';
import 'package:sns_app/view/start_up/login_page.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authentication.myAccount!;//初期段階で登録されている状態にしておく
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image; //dart.ioのFile? について調査せよ
  //dart.ioかdart.htmlかでエラーの出方が違うので注意。

  ImageProvider getImage(){
    if(image == null){
      return NetworkImage(myAccount.imagePath);
    } else {
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController = TextEditingController(text: myAccount.selfIntroduction);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集'),
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
                  foregroundImage: getImage(),
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
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    if(nameController.text.isNotEmpty
                        && userIdController.text.isNotEmpty
                        && selfIntroductionController.text.isNotEmpty
                        /*&& image != null*/
                    //imageがnullでも更新できてもいい(前の画像のままでもいい)のでこの分岐はいったんなし
                    ){
                      String imagePath ='';
                      if(image == null){
                        imagePath = myAccount.imagePath;
                      } else {
                        var result = await FunctionUtils.uplordImage(myAccount.id, image!);
                        imagePath = result;
                      }
                      Account updateAccount = Account(
                        id: myAccount.id,
                        name: myAccount.name,
                        userId: myAccount.userId,
                        selfIntroduction: myAccount.selfIntroduction,
                        imagePath: imagePath
                      );
                      Authentication.myAccount = updateAccount;
                      var result = await UserFireStore.updateUser(updateAccount);
                      if(result == true){//resultの内容がtrueだったら遷移。
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('更新')),
              ElevatedButton(
                  onPressed: (){
                    Authentication.signOut();
                    while(Navigator.canPop(context)){//Navigator.canPop(context)＝「popできる状態だったら」
                      Navigator.pop(context);
                    }
                    //popできないような状態になったらpushreplacement　＝　その画面を破棄して新しいルートに遷移する
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ));
                  },
                  child: const Text('ログアウト')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: (){
                    UserFireStore.deleteUser(myAccount.id);
                    Authentication.deleteAuth();
                    Authentication.signOut();
                    while(Navigator.canPop(context)){//Navigator.canPop(context)＝「popできる状態だったら」
                      Navigator.pop(context);
                    }
                    //popできないような状態になったらpushreplacement　＝　その画面を破棄して新しいルートに遷移する
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginPage()
                    ));
                  },
                  child: const Text('アカウント削除'))
            ],
          ),
        ),
      ),
    );
  }
}
