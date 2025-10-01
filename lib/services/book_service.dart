import '../models/book.dart';
import 'mock_books.dart'; // Import the mock data

class BookService {
  // Simulate fetching all books
  Future<List<Book>> getAllBooks() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return mockBooks;
  }

  // Simulate fetching recommended books
  Future<List<Book>> getRecommendedBooks() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return mockBooks.where((book) => book.isRecommended).toList();
  }

  // Simulate fetching best seller books
  Future<List<Book>> getBestSellerBooks() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return mockBooks.where((book) => book.isBestSeller).toList();
  }

  // Simulate fetching a single book by ID
  Future<Book?> getBookById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return mockBooks.firstWhere((book) => book.id == id);
    } catch (e) {
      return null; // Return null if book not found
    }
  }
}

