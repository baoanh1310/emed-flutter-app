import 'package:firebase_storage/firebase_storage.dart';

extension StringExtension on String {
  Future<String> getStorageDownloadUrl() async {
    return await FirebaseStorage.instance.ref(this).getDownloadURL();
  }
}
