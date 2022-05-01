import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folder/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InnerFolder extends StatefulWidget {
  InnerFolder({this.filesPath});

  final String filesPath;

  @override
  State<StatefulWidget> createState() {
    return InnerFolderState();
  }
}

class InnerFolderState extends State<InnerFolder> {
  String get fileStr => widget.filesPath;
  bool permissionGranted = false;

  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  callFolderCreationMethod(String folderInAppDocDir) async {
    // ignore: unused_local_variable
    String actualFileName = await createFolderInAppDocDir(folderInAppDocDir);
    print("actualFileName");
    print(actualFileName);
    setState(() {});
  }

  final folderController = TextEditingController();
  String nameOfFolder;



  List<FileSystemEntity> _folders;

  Future<void> getDir() async {
    String pdfDirectory = '${widget.filesPath}';
    final myDir = new Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    print(_folders);
  }

  Future<void> _showDeleteDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you sure to delete this?',
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () async {
                await _folders[index].delete();
                getDir();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style:ElevatedButton.styleFrom(
                primary: Colors.redAccent, // background
                onPrimary: Colors.redAccent, // foreground
              ),
              child: Text('No',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _folders = [];
    getDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent.shade700,
        onPressed: () {
          setState(() {
            picFileFromStorage();
          });
        },
      ),
      appBar: AppBar(
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.add),
          //     onPressed: () {
          //       _showMyDialog();
          //     },
          //   ),
          // ],
          ),
      body:
      _folders.length!=0 ?
      GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Material(
            elevation: 6.0,
            child: Stack(
              children: [

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: getFileType(_folders[index]),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              FileStat f = snapshot.data;
                              if (f.type.toString().contains("file")) {
                                return Icon(
                                  Icons.file_copy_outlined,
                                  size: 60,
                                  color: Colors.orange,
                                );
                              } else {
                                return InkWell(
                                  onTap: () {
                                    final myDir =
                                        new Directory(_folders[index].path);

                                    var _foldersList = myDir.listSync(
                                        recursive: true, followLinks: false);

                                    for (int k = 0;
                                        k < _foldersList.length;
                                        k++) {
                                      var config = File(_foldersList[k].path);
                                      print("IsFile ${config is File}");
                                    }
                                    print(_foldersList);
                                  },
                                  child: Icon(
                                    Icons.folder,
                                    size: 100,
                                    color: Colors.orange,
                                  ),
                                );
                              }
                            }
                            return Icon(
                              Icons.file_copy_outlined,
                              size: 100,
                              color: Colors.orange,
                            );
                          }),

                      Text(
                        '${_folders[index].path.split('/').last}',
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _showDeleteDialog(index);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _scaleDialog(_folders[index].path);
                      // _downloadfile(_folders[index].path);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.download,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: _folders.length,
      )
      :Center(
        child: Text(
          'Nothing Added Yet', style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _dialog(BuildContext context, String path) {
    TextEditingController _textNameFieldController = TextEditingController();
    TextEditingController _textPassFieldController = TextEditingController();
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      title: const Text("Verify, its You"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: _textNameFieldController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              obscureText: true,
              controller: _textPassFieldController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              verifySharedPref(_textNameFieldController.text,
                      _textPassFieldController.text)
                  .then((value) => {
                        if (value)
                          {
                            _downloadFile(path),
                            Navigator.of(context).pop(),
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Please provide correct credentials..'),
                            )),
                          }
                      });
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialog(String path) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx, path),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  //Logics

  Future getFileType(file) {
    return file.stat();
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> picFileFromStorage() async {
    _getStoragePermission();
    if (permissionGranted) {
      FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        final File fileForFirebase = File(file.path);
        moveFile(fileForFirebase, widget.filesPath + "/${file.name}").then(
          (value) => getDir(),
        );
      } else {
        // User canceled the picker
      }
    }
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster

      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      print(e);
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      getDir();
      setState(() {});
      await sourceFile.delete();

      return newFile;
    }
  }

  Future<void> _downloadFile(String path) async {
    String internalPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    final File fileForFirebase = File(path);
    extractToDownload(
            fileForFirebase, internalPath + "/${path.split('/').last}")
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('File Downloaded.. $internalPath'),
              ))
            });
  }

  Future<File> extractToDownload(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      print(e);
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  Future<bool> verifySharedPref(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (username == preferences.getString(Global.NAME) &&
        password == preferences.getString(Global.PASS)) {
      return true;
    }
    return false;
  }
}
