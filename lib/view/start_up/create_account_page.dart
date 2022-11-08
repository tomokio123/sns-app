import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_app/utils/authentication.dart';

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
  ImagePicker picker = ImagePicker();

  Future<void> uplordImage(String uid) async{
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image!);
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    print("image_path: $downloadUrl");
  }

  Future<void> getImageFromGallery() async{//画像取得メソッド写真フォルダから
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        image = File(pickedFile.path);
      });
    }else {
      print("pickedFileがnullです");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,//AppBarは元々影ができているのでその影を０にする
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text('新規登録',style: TextStyle(color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: (){
                    getImageFromGallery();
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
                Container(
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
                        if(result is UserCredential){//　「resultに入ってる値の型がUserCredential型なら」って意味
                          Navigator.pop(context);
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
