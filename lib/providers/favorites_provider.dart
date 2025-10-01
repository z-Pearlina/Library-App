import 'package:flutter/foundation.dart';
import '../models/book.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Book> _favoriteBooks = [];

  List<Book> get favoriteBooks => _favoriteBooks;

  bool isFavorite(Book book) {
    return _favoriteBooks.any((favBook) => favBook.id == book.id);
  }

  void toggleFavorite(Book book) {
    if (isFavorite(book)) {
      _favoriteBooks.removeWhere((favBook) => favBook.id == book.id);
    } else {
      _favoriteBooks.add(book);
    }
    notifyListeners(); // Notify listeners about the change
  }
}

