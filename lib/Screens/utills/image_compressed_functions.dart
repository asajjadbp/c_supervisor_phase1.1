import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<XFile?> compressAndGetFile(XFile file) async {
  final filePath = file.path;

  final dir = await path_provider.getTemporaryDirectory();
  final outPath = "${dir.absolute.path}/temp.jpg";

  XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 1080,
      minHeight: 1080,
      quality: 40);

  print("Files Sizes");
  print(await file.length());
  print(await compressedImage!.length());

  return compressedImage;
}