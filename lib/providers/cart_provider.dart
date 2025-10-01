import 'package:flutter/foundation.dart';
import '../models/book.dart';

class CartProvider with ChangeNotifier {
  final List<Book> _cartItems = [];

  List<Book> get cartItems => _cartItems;

  // Check if a book is already in the cart
  bool isInCart(Book book) {
    return _cartItems.any((item) => item.id == book.id);
  }

  // Add a book to the cart
  void addToCart(Book book) {
    if (!isInCart(book)) {
      _cartItems.add(book);
      notifyListeners();
    }
    // Optionally handle quantity later if needed
  }

  // Remove a book from the cart
  void removeFromCart(Book book) {
    _cartItems.removeWhere((item) => item.id == book.id);
    notifyListeners();
  }

  // Calculate the total price of items in the cart
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  // Clear the cart (e.g., after checkout)
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

