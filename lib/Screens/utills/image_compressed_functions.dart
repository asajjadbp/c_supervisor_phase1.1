// ignore_for_file: avoid_print

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
      quality: 5);

  final bytes = await file.length();
  final kb = bytes / 1024;

  final bytes1 = await compressedImage!.length();
  final kb1 = bytes1 / 1024;

  print("Files Sizes");
  print("Main File: $kb");
  print("Compressed File: $kb1");

  return compressedImage;
}