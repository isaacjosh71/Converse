import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({super.key, required this.file});
  final File file;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(title: Text(name),),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }
}
