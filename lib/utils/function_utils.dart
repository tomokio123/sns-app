import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils{
  static Future<String> uplordImage(String uid, File image) async{
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image);
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    print("image_path: $downloadUrl");
    return downloadUrl;
  }

  static Future<dynamic> getImageFromGallery() async{//画像取得メソッド写真フォルダから
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

}