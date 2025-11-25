// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_saver/file_saver.dart';

/// Downloads PDFs and images, saving to Android Downloads folder using FileSaver.
Future<void> downloadFiles(List<String> fileUrls, String baseName) async {
  // 1. Request storage permission (READ/WRITE external storage)
  final status = await Permission.storage.request();
  if (!status.isGranted) {
    throw Exception('Storage permission not granted');
  }

  // 2. Split URLs into PDFs and images based on extension.
  List<String> pdfUrls = [];
  List<String> imageUrls = [];
  for (var url in fileUrls) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    if (path.endsWith('.pdf')) {
      pdfUrls.add(url);
    } else {
      imageUrls.add(url);
    }
  }

  // Helper to save bytes to a file in Downloads (Android)
  Future<void> saveFile(
      String fileName, Uint8List bytes, MimeType mimeType) async {
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      ext: 'pdf',
      mimeType: mimeType,
    );
  }

  int pdfCounter = 1;

  // 3. Handle PDF URLs
  if (pdfUrls.isNotEmpty) {
    if (imageUrls.isEmpty && pdfUrls.length == 1) {
      // Only one PDF, use baseName.pdf
      final pdfUrl = pdfUrls.first;
      final res = await http.get(Uri.parse(pdfUrl));
      if (res.statusCode == 200) {
        await saveFile(
          baseName,
          Uint8List.fromList(res.bodyBytes),
          MimeType.pdf,
        );
      }
    } else {
      // Multiple PDFs (or mixed): save each with an index
      for (var url in pdfUrls) {
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          final name = (pdfUrls.length == 1 && imageUrls.isEmpty)
              ? baseName
              : '${baseName}_$pdfCounter';
          await saveFile(
            name,
            Uint8List.fromList(res.bodyBytes),
            MimeType.pdf,
          );
          pdfCounter++;
        }
      }
    }
  }

  // 4. Handle Image URLs: combine into one PDF if any images exist
  if (imageUrls.isNotEmpty) {
    final imagePdf = pw.Document();
    for (var imgUrl in imageUrls) {
      final res = await http.get(Uri.parse(imgUrl));
      if (res.statusCode == 200) {
        final image = pw.MemoryImage(res.bodyBytes);
        imagePdf.addPage(
          pw.Page(
            build: (context) => pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ),
        );
      }
    }

    final pdfBytes = await imagePdf.save();
    final imagePdfName = pdfUrls.isEmpty ? baseName : '${baseName}_images';

    await saveFile(
      imagePdfName,
      Uint8List.fromList(pdfBytes),
      MimeType.pdf,
    );
  }
}
