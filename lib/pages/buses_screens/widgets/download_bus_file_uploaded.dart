import 'package:bus_management_system/constants/style.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadBusFilesPage extends StatefulWidget {
  final String busName;
  const DownloadBusFilesPage({Key key, this.busName}) : super(key: key);

  @override
  State<DownloadBusFilesPage> createState() => _DownloadBusFilesPageState();
}

class _DownloadBusFilesPageState extends State<DownloadBusFilesPage> {
  Reference _busFolderRef;
  List<Reference> _files;
  @override
  void initState() {
    super.initState();
    _busFolderRef = FirebaseStorage.instanceFor(
      bucket: 'gs://bus-management-system-17ede.appspot.com',
    ).ref().child(widget.busName);
    _fetchFiles();
    // FlutterDownloader.initialize();
  }

  void _fetchFiles() async {
    ListResult result = await _busFolderRef.listAll();
    setState(() {
      _files = result.items;
    });
  }

  //downloading files functionality

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: iconsColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Bus ${widget.busName} Documents and Media",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _buildFilesList(),
    );
  }

  Widget _buildFilesList() {
    if (_files == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_files.isEmpty) {
      return const Center(
        child: Text('No files found.'),
      );
    } else {
      return ListView.builder(
        itemCount: _files.length,
        itemBuilder: (BuildContext context, int index) {
          Reference file = _files[index];
          return Card(
            elevation: 4,
            child: ListTile(
                title: Text(file.name),
               subtitle: FutureBuilder(
  future: file.getMetadata(),
  builder: (BuildContext context, AsyncSnapshot<FullMetadata> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text('Loading...');
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      String fileSize = _formatFileSize(snapshot.data.size);
      return Text(
        'Type: ${snapshot.data.contentType}, Size: $fileSize',
      );
    }
  },
),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: 'Download',
                      child: IconButton(
                        icon: Icon(
                          Icons.download,
                          color: iconsColor,
                        ),
                        onPressed: () {
                          _downloadFile(index);
                        },
                      ),
                    ),
                    Tooltip(
                      message: 'Delete',
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: iconsColor,
                        ),
                        onPressed: () {
                          // TODO: Implement file delete
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Are you sure you want to delete this file?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        _deleteFile(index);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ],
                )),
          );
        },
      );
    }
  }
 

String _formatFileSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  }
  double kb = bytes / 1024;
  if (kb < 1024) {
    return '${kb.toStringAsFixed(2)} KB';
  }
  double mb = kb / 1024;
  if (mb < 1024) {
    return '${mb.toStringAsFixed(2)} MB';
  }
  double gb = mb / 1024;
  return '${gb.toStringAsFixed(2)} GB';
}


  void _downloadFile(int index) async {
    Reference file = _files[index];
    String downloadUrl = await file.getDownloadURL();
    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }

  // Inside your widget class
void _deleteFile(int index) async {
  Reference file = _files[index];
  try {
    await file.delete();
    setState(() {
      _files.removeAt(index);
    });
  } catch (e) {
    print('Error deleting file: $e');
  }
}

}
