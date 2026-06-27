import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/failures.dart';
import 'package:dartz/dartz.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Upload a single photo and return its download URL.
  Future<Either<Failure, String>> uploadPhoto({
    required String localPath,
    required String remotePath,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final file = File(localPath);
      final ref = _storage.ref(remotePath);
      final task = ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      task.snapshotEvents.listen((snapshot) {
        final progress =
            snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final snapshot = await task;
      final url = await snapshot.ref.getDownloadURL();
      return Right(url);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Upload failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Upload multiple photos and return list of download URLs.
  Future<Either<Failure, List<String>>> uploadPhotos({
    required List<String> localPaths,
    required String folder,
    void Function(int done, int total)? onProgress,
  }) async {
    final urls = <String>[];
    for (var i = 0; i < localPaths.length; i++) {
      final remotePath =
          '$folder/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final result = await uploadPhoto(localPath: localPaths[i], remotePath: remotePath);
      result.fold(
        (failure) => null,
        (url) => urls.add(url),
      );
      onProgress?.call(i + 1, localPaths.length);
    }
    return Right(urls);
  }

  /// Delete a photo by URL.
  Future<void> deletePhoto(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {}
  }
}

final storageServiceProvider = Provider<StorageService>(
  (_) => StorageService(),
);
