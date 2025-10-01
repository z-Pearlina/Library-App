import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart'; // Required to copy asset to temp file
import 'package:pearlibrary/models/pdf_book.dart';
import 'package:pearlibrary/utils/app_colors.dart';
import 'package:pearlibrary/utils/app_styles.dart';

class PdfViewerScreen extends StatefulWidget {
  final PdfBook pdfBook;

  const PdfViewerScreen({Key? key, required this.pdfBook}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    print("PdfViewerScreen initState: Loading PDF for ${widget.pdfBook.title} from asset: ${widget.pdfBook.assetPath}");
    _preparePdf();
  }

  // flutter_pdfview needs a file path, so we copy the asset to a temporary file
  Future<void> _preparePdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      print("Getting application documents directory...");
      final dir = await getApplicationDocumentsDirectory();
      // Use a safe filename based on the asset path
      final fileName = widget.pdfBook.assetPath.split('/').last;
      final file = File("${dir.path}/$fileName");
      print("Target local file path: ${file.path}");

      // Check if file already exists to avoid redundant copying
      if (await file.exists()) {
        print("File already exists locally. Using existing file.");
      } else {
        print("File does not exist locally. Copying from assets...");
        // Ensure asset exists before loading
        try {
          print("Loading asset: ${widget.pdfBook.assetPath}");
          final data = await rootBundle.load(widget.pdfBook.assetPath);
          final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          print("Asset loaded successfully (${bytes.length} bytes). Writing to local file...");
          await file.writeAsBytes(bytes, flush: true);
          print("File written successfully.");
        } on FlutterError catch (e) {
          // Handle asset not found specifically
          print("Asset loading error: $e");
          throw Exception("Asset not found: ${widget.pdfBook.assetPath}. Ensure it's in assets/pdfs/ and declared in pubspec.yaml.");
        }
      }

      if (mounted) {
        setState(() {
          _localPath = file.path;
          _isLoading = false;
          print("PDF prepared successfully. Local path set to: $_localPath");
        });
      }
    } catch (e) {
      print("Error preparing PDF: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Could not load PDF: ${e.toString()}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pdfBook.title, style: AppStyles.headline2.copyWith(fontSize: 18)),
        backgroundColor: AppColors.background,
        elevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      print("PDF Body: Showing loading indicator.");
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_errorMessage != null) {
      print("PDF Body: Showing error message: $_errorMessage");
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            _errorMessage!,
            style: AppStyles.subtitle1.copyWith(color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_localPath != null) {
      print("PDF Body: Rendering PDF from path: $_localPath");
      return PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false, // Allow links within PDF
        onRender: (_pages) {
          print("PDF Rendered: $_pages pages");
        },
        onError: (error) {
          print("PDFView Error: $error");
          if (mounted) {
            setState(() {
              _errorMessage = "Error displaying PDF: $error";
            });
          }
        },
        onPageError: (page, error) {
          print("PDFView Page Error: page: $page, error: $error");
          if (mounted) {
            // Avoid flooding state updates if multiple page errors occur
            if (_errorMessage == null || !_errorMessage!.contains("page $page")) {
              setState(() {
                _errorMessage = "Error displaying page $page: $error";
              });
            }
          }
        },
        onViewCreated: (PDFViewController pdfViewController) {
          print("PDFView created.");
        },
        onPageChanged: (int? page, int? total) {
          print('page change: $page/$total');
        },
      );
    } else {
      print("PDF Body: Showing fallback error message (localPath is null).");
      return const Center(child: Text('Could not load PDF.', style: AppStyles.subtitle1));
    }
  }
}

