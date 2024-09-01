import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService{



  Future<File> compressFile(File file) async{
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
      quality: 5,);
    return compressedFile;
  }
  Future<void> testPathProvider() async {
    try {
      final dir = await getTemporaryDirectory();
      print('Temporary Directory: ${dir.path}');
    } catch (e) {
      print('Error: $e');
    }
  }
}