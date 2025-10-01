import 'package:pearlibrary/models/pdf_book.dart';
import 'package:pearlibrary/domain/repositories/pdf_book_repository.dart';

// Use case for getting the list of free PDF books (Domain Layer)
class GetFreePdfBooksUseCase {
  final PdfBookRepository repository;

  GetFreePdfBooksUseCase(this.repository);

  Future<List<PdfBook>> execute() {
    return repository.getFreePdfBooks();
  }
}

// You could add other use cases here if needed, e.g.,
// class OpenPdfBookUseCase { ... }

