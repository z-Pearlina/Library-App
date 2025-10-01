import 'package:flutter/material.dart';
import 'package:pearlibrary/models/pdf_book.dart';
import 'package:pearlibrary/domain/usecases/get_free_pdf_books_usecase.dart';
import 'package:pearlibrary/data/repositories/pdf_book_repository_impl.dart'; // Direct import for simplicity
import 'package:pearlibrary/utils/app_colors.dart';
import 'package:pearlibrary/utils/app_styles.dart';
import 'package:pearlibrary/screens/pdf_viewer/pdf_viewer_screen.dart'; // Import viewer screen

class FreeBooksScreen extends StatefulWidget {
  const FreeBooksScreen({Key? key}) : super(key: key);

  @override
  _FreeBooksScreenState createState() => _FreeBooksScreenState();
}

class _FreeBooksScreenState extends State<FreeBooksScreen> {
  // Instantiate use case directly (in real Clean Arch, use dependency injection)
  final GetFreePdfBooksUseCase _getFreePdfBooksUseCase = GetFreePdfBooksUseCase(PdfBookRepositoryImpl());
  late Future<List<PdfBook>> _pdfBooksFuture;

  @override
  void initState() {
    super.initState();
    _pdfBooksFuture = _getFreePdfBooksUseCase.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Free books', style: AppStyles.headline2),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<PdfBook>>(
        future: _pdfBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading books: ${snapshot.error}', style: AppStyles.subtitle1));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No free books available.', style: AppStyles.subtitle1));
          }

          final pdfBooks = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            itemCount: pdfBooks.length,
            itemBuilder: (context, index) {
              return _buildPdfBookListItem(context, pdfBooks[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildPdfBookListItem(BuildContext context, PdfBook pdfBook) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: AppColors.cardBackground,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: 50,
            height: 70,
            color: Colors.grey[200], // Background color for the image area
            child: pdfBook.coverImageUrl != null
                ? Image.asset(
              pdfBook.coverImageUrl!,
              fit: BoxFit.cover,
              // Add errorBuilder to handle cases where the image fails to load
              errorBuilder: (context, error, stackTrace) {
                // Log the error for debugging
                print('Error loading image ${pdfBook.coverImageUrl}: $error');
                // Show a placeholder icon if the image fails
                return Center(child: Icon(Icons.broken_image, color: Colors.grey[400]));
              },
            )
                : Center(child: Icon(Icons.picture_as_pdf, color: Colors.red[300])), // Icon for PDFs without covers
          ),
        ),
        title: Text(pdfBook.title, style: AppStyles.bodyText1.copyWith(fontWeight: FontWeight.w600)),
        subtitle: pdfBook.author != null ? Text(pdfBook.author!, style: AppStyles.caption) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
        onTap: () {
          // Navigate to the PDF Viewer Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(pdfBook: pdfBook),
            ),
          );
        },
      ),
    );
  }
}

