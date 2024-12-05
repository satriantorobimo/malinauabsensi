import 'package:flutter/foundation.dart';

class UploadFileIzinRequestModel {
  final Uint8List fileData;
  final String fileName;
  final String fileType;

  UploadFileIzinRequestModel(this.fileData, this.fileName, this.fileType);
}
