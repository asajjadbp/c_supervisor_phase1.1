// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:c_supervisor/Network/download_file.dart';
import 'package:c_supervisor/Screens/widgets/toast_message_show.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:c_supervisor/provider/license_provider.dart';

class KnowledgeCard extends StatefulWidget {
  KnowledgeCard(
      {Key? key,
      required this.onTap,
      required this.imageUrl,
      required this.cardName,
      required this.fileName,
      required this.description})
      : super(key: key);

  final String cardName;
  final String description;
  final String imageUrl;
  final String fileName;
  Function onTap;

  @override
  State<KnowledgeCard> createState() => _KnowledgeCardState();
}

class _KnowledgeCardState extends State<KnowledgeCard> {
  String? _downloadedFilePath;
  double _downloadProgress = 0.0;

  Future<void> _downloadFile() async {
    final response = await http.get(
      Uri.parse(
          "${LicenseProvider.imageBasePath}knowledge_share/${widget.fileName}"),
      // headers: (optional) add headers if needed
    );

    print("${LicenseProvider.imageBasePath}knowledge_share/${widget.fileName}");

    if (response.statusCode == 200) {
      // Get the directory for storing the downloaded file
      final appDocDir = await getApplicationDocumentsDirectory();
      final file = File('${appDocDir.path}/downloaded_file');

      // Write the file
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        _downloadedFilePath = file.path;
      });
      showToastMessage(true, "file downloaded");
      print(_downloadedFilePath);
      print(_downloadProgress);
    } else {
      print("failed to download");
      throw Exception('Failed to download file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shadowColor: Colors.black12,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  // widget.onTap();
                  // await DonwloadFile().getFile(widget.fileName);
                  _downloadFile();
                },
                child: Image.asset(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              // if (_downloadedFilePath != null)
              //   Text('File downloaded to: $_downloadedFilePath'),
              // SizedBox(height: 20),
              if (_downloadProgress > 0)
                Text(
                    'Download progress: ${(_downloadProgress * 100).toStringAsFixed(2)}%'),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(widget.cardName),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32.0),
                                topRight: Radius.circular(32.0))),
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) =>
                                    Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                        ),
                                        height: 200,
                                        margin: const EdgeInsets.only(
                                            top: 15, left: 10),
                                        child: Text(widget.description)),
                          );
                        });
                  },
                  child: const Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
