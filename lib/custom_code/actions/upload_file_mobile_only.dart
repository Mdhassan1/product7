// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

const String supabaseBaseUrl =
    "https://yifwqsbdmkljzglsyynq.supabase.co/storage/v1/object/public/";

Future<String?> uploadFileMobileOnly(
  BuildContext context,
  String bucket,
  String folderPath,
) async {
  try {
    final source = await showFileSourceDialog(context);
    if (source == null) return null;

    Uint8List? fileBytes;
    String? fileName;

    if (source == 'camera') {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage == null) return null;
      fileBytes = await pickedImage.readAsBytes();
      fileName = pickedImage.name;
    } else if (source == 'gallery') {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return null;
      final file = result.files.first;
      fileBytes = file.bytes;
      fileName = file.name;
    }

    if (fileBytes == null || fileName == null) return null;

    final fullPath =
        '$folderPath/${DateTime.now().millisecondsSinceEpoch}_$fileName';

    final uploadResponse = await Supabase.instance.client.storage
        .from(bucket)
        .uploadBinary(fullPath, fileBytes,
            fileOptions: const FileOptions(upsert: true));

    if (uploadResponse.isEmpty) {
      showErrorDialog(context, "Upload failed. Try again.");
      return null;
    }

    return "$supabaseBaseUrl$bucket/$fullPath";
  } catch (e) {
    showErrorDialog(context, "Mobile Upload error: $e");
    return null;
  }
}

Future<String?> showFileSourceDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choose File Source",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, 'camera'),
              icon: const Icon(Icons.camera_alt, color: Colors.black),
              label:
                  const Text("Camera", style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, 'gallery'),
              icon: const Icon(Icons.folder, color: Colors.black),
              label: const Text("Gallery/File",
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
            ),
          ],
        ),
      ),
    ),
  );
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Upload Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
