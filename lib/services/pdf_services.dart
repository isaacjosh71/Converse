import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/pdfview.dart';

class PdfServices{

  static Future<void> storeFile(var url, Uint8List bytes) async{
    String uri = url.toString();
   final fileName = basename(uri);
   final dir = await getApplicationDocumentsDirectory();

   final file = File('${dir.path}/$fileName');
   await file.writeAsBytes(bytes, flush: true);

   Get.to(()=> PdfViewPage(file: file));
  }
}