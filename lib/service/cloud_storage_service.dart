import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

CloudStorageService get cloudStorageService =>
    GetIt.instance<CloudStorageService>();

class CloudStorageService {
  final storage = FirebaseStorage.instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String destinationPath) async {
    File file = File(filePath);
    try {
      await _storage.ref(destinationPath).putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadString(String data, String destinationPath) async {
    try {
      await _storage
          .ref(destinationPath)
          .putString(data, format: PutStringFormat.raw);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadData(Uint8List data, String destinationPath) async {
    try {
      await _storage.ref(destinationPath).putData(data);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String?> getDownloadURL(String filePath) async {
    try {
      return await _storage.ref(filePath).getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> manageUploads(File file, String destinationPath) async {
    final task = _storage.ref(destinationPath).putFile(file);

    bool paused = await task.pause();
    print('paused, $paused');

    bool resumed = await task.resume();
    print('resumed, $resumed');

    bool canceled = await task.cancel();
    print('canceled, $canceled');
  }

  void monitorUploadProgress(File file, String destinationPath) {
    final task = _storage.ref(destinationPath).putFile(file);

    task.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          print("An error occurred while uploading");
          break;
        case TaskState.success:
          print("Upload was successful");
          break;
      }
    });
  }

  Reference createReferenceFromPath(String path) {
    return _storage.ref().child(path);
  }

  Reference createReferenceFromURL(String url) {
    return _storage.refFromURL(url);
  }

  // Download in memory
  Future<String?> downloadInMemory(String path, int? maxSizeInBytes) async {
    try {
      final ref = createReferenceFromPath(path);

      final data = await ref.getData(maxSizeInBytes ?? 10485760);
      if (data != null) {
        String content = utf8.decode(data);
        return content;
      }
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
    return null;
  }

  Future<void> deleteFile(String path) async {
    try {
      // Create a reference to the file to delete
      final ref = createReferenceFromPath(path);

      // Delete the file
      await ref.delete();
      print('File deleted successfully');
    } on FirebaseException catch (e) {
      print(e.message); // You can handle the error as required
    }
  }

// Download to a local file
// Future<File?> downloadToLocalFile(String path) async {
//   try {
//     final ref = createReferenceFromPath(path);
//
//     final appDocDir = await storage.getApplicationDocumentsDirectory();
//     final filePath = "${appDocDir.absolute}/$path";
//     final file = File(filePath);
//
//     final downloadTask = ref.writeToFile(file);
//     downloadTask.snapshotEvents.listen((taskSnapshot) {
//       switch (taskSnapshot.state) {
//         case TaskState.running:
//           break;
//         case TaskState.paused:
//           break;
//         case TaskState.success:
//           break;
//         case TaskState.canceled:
//           break;
//         case TaskState.error:
//           break;
//       }
//     });
//
//     await downloadTask.whenComplete(() => {});
//     return file;
//   } on FirebaseException catch (e) {
//     print(e.message); // You can handle the error as required
//     return null;
//   }
// }
}
