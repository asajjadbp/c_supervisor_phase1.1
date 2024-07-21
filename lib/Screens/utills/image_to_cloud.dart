import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class ImageToCloud {
  Future<String> uploadImageToCloud(XFile imageXFile, String userId,
      String folderName, String bucketName) async {
    // setState(() {
    //   isLoading = true;
    // });
    File imgFile = File(imageXFile.path);
    try {
      final credentials = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString(
            'assets/google_cloud_creds/appimages-keycstoreapp-7c0f4-a6d4c3e5b590.json'),
      );

      final httpClient = await clientViaServiceAccount(
          credentials, [StorageApi.devstorageReadWriteScope]);

      // Create a Storage client with the credentials
      final storage = StorageApi(httpClient);

      // Generate a unique filename and path
      final filename = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // const bucketName = "cstore-bucket"; // Replace with your bucket name
      final filePath = '$folderName/$filename';

      final fileContent = await imgFile.readAsBytes();
      final bucketObject = Object(name: filePath);

      // Upload the image
      final resp = await storage.objects.insert(
        bucketObject,
        bucketName,
        predefinedAcl: 'publicRead',
        uploadMedia: Media(
          Stream<List<int>>.fromIterable([fileContent]),
          fileContent.length,
        ),
      );

      final downloadUrl =
          'https://storage.googleapis.com/$bucketName/$filePath';
      // print(downloadUrl);
      // print("check four");
      return filename;
    } catch (error) {
      // Handle any errors that occur during the upload
      // print("Upload GCS Error $error");
      return error.toString();
    }
  }
}
