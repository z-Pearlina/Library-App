import 'package:pearlibrary/models/pdf_book.dart';

// Abstract interface for the PDF book repository (Domain Layer)
abstract class PdfBookRepository {
  Future<List<PdfBook>> getFreePdfBooks();
}

