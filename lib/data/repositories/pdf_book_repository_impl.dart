import 'package:pearlibrary/models/pdf_book.dart';
import 'package:pearlibrary/domain/repositories/pdf_book_repository.dart';
import 'package:pearlibrary/services/mock_pdf_books.dart'; // Import the mock data

// Implementation of the PdfBookRepository (Data Layer)
class PdfBookRepositoryImpl implements PdfBookRepository {
  // In a real app, this might take a remote or local data source
  // final PdfBookDataSource dataSource;
  // PdfBookRepositoryImpl(this.dataSource);

  @override
  Future<List<PdfBook>> getFreePdfBooks() async {
    // Simulate fetching data from the mock source
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate delay
    return mockPdfBooks;
    // In a real app: return dataSource.getFreePdfBooks();
  }
}

