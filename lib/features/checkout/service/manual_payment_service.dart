// import 'dart:io';
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:http/http.dart' as http;

// class ManualPaymentService {
//   Future<void> uploadPayment({
//     required String orderId,
//     required PlatformFile file,
//   }) async {
//     final token = await getToken();
//     final uri = Uri.parse('${Constants.baseurl}/api/manualpayment/$orderId');

//     final request = http.MultipartRequest('POST', uri);
//     if (token != null) {
//       request.headers['Authorization'] = 'Bearer $token';
//     }

//     final fileBytes = file.bytes ?? await _readFile(file);
//     final multipartFile = http.MultipartFile.fromBytes(
//       'screenshot',
//       fileBytes,
//       filename: file.name,
//     );

//     request.files.add(multipartFile);

//     final response = await request.send();
//     final body = await response.stream.bytesToString();

//     if (response.statusCode != 200 && response.statusCode != 201) {
//       throw Exception('Upload failed: $body');
//     }
//   }

//   Future<Uint8List> _readFile(PlatformFile file) async {
//     if (file.path == null) {
//       throw Exception('No file path found for upload');
//     }
//     final bytes = await File(file.path!).readAsBytes();
//     return bytes;
//   }
// }
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:haqmate/core/constants.dart';
import 'package:http/http.dart' as http;

class ManualPaymentService {
  Future<void> uploadPayment({
    required String orderId,
    required PlatformFile file,
  }) async {
    final token = await getToken();
    final uri = Uri.parse('${Constants.baseurl}/api/manualpayment/$orderId');

    final request = http.MultipartRequest('POST', uri);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    late Uint8List fileBytes;

    if (kIsWeb) {
      // 🌐 WEB → bytes only
      if (file.bytes == null) {
        throw Exception('File bytes are null (web)');
      }
      fileBytes = file.bytes!;
    } else {
      // 📱 MOBILE → read from path
      if (file.path == null) {
        throw Exception('File path is null (mobile)');
      }
      fileBytes = await File(file.path!).readAsBytes();
    }

    final multipartFile = http.MultipartFile.fromBytes(
      'screenshot', // ⚠️ must match backend
      fileBytes,
      filename: file.name,
    );

    request.files.add(multipartFile);

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Upload failed with status ${response.statusCode}: $body');
      throw Exception('Upload failed: $body');
    }
  }
}
