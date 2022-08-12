import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              CircleAvatar(
                radius: 40,
                child: Icon(Icons.add),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: '名前'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: 300,
                child: TextField(
                  controller: userIdController,
                  decoration: const InputDecoration(hintText: 'ユーザーID'),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: const InputDecoration(hintText: '自己紹介'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'メールアドレス'),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: const InputDecoration(hintText: 'パスワード'),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: (){
                    if(nameController.text.isNotEmpty
                        && userIdController.text.isNotEmpty
                        && selfIntroductionController.text.isNotEmpty
                        && emailController.text.isNotEmpty
                        && passController.text.isNotEmpty
                    ){
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('アカウントを作成'))
            ],
          ),
        ),
      ),
    );
  }
}
