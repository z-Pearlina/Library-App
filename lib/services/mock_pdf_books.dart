import 'package:pearlibrary/models/pdf_book.dart';

// Mock data for PDF books
// Ensure assetPath points to actual PDFs in assets/pdfs/
// Ensure coverImageUrl points to actual images in assets/images/
final List<PdfBook> mockPdfBooks = [
  PdfBook(
    id: 'pdf1',
    title: 'Linux Notes for Professionals',
    author: 'GoalKicker.com',
    assetPath: 'assets/pdfs/linux_notes.pdf', // Placeholder PDF path - USER MUST REPLACE
    coverImageUrl: 'assets/images/linux.png', // Corrected path
  ),
  PdfBook(
    id: 'pdf2',
    title: 'Kotlin Notes for Professionals',
    author: 'GoalKicker.com',
    assetPath: 'assets/pdfs/kotlin_notes.pdf', // Placeholder PDF path - USER MUST REPLACE
    coverImageUrl: 'assets/images/kotlin.png', // Corrected path
  ),
  PdfBook(
    id: 'pdf3',
    title: 'Git Notes for Professionals',
    author: 'GoalKicker.com',
    assetPath: 'assets/pdfs/git_notes.pdf', // Placeholder PDF path - USER MUST REPLACE
    coverImageUrl: 'assets/images/git.png', // Corrected path
  ),
  // Add more mock PDF books if needed
];

