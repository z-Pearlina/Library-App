import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/book.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/rounded_button.dart'; // Reuse button

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart', style: AppStyles.headline2),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        // No back button needed if accessed via bottom nav
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty.',
          style: AppStyles.subtitle1,
          textAlign: TextAlign.center,
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(context, cartItems[index], cartProvider);
              },
            ),
          ),
          _buildTotalPriceSection(context, cartProvider),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Book book, CartProvider cartProvider) {
    // Similar layout to vertical BookCard but with remove button
    return Container(
      height: 120.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 5,
              color: Colors.black.withOpacity(0.05),
            )
          ]
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            // Fixed: Use Image.asset with error handling
            child: Image.asset(
              book.imageUrl,
              fit: BoxFit.cover,
              width: 80,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                print("Error loading image in cart: ${book.imageUrl} - $error");
                // Fallback placeholder if image fails
                return Container(
                  width: 80, height: 100,
                  color: Colors.grey[200],
                  child: Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
                );
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(book.title, style: AppStyles.bodyText1.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4.0),
                Text(book.author, style: AppStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8.0),
                Text('\$${book.price.toStringAsFixed(2)}', style: AppStyles.bodyText1.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          // Remove button
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
            onPressed: () {
              cartProvider.removeFromCart(book);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${book.title} removed from cart'), duration: const Duration(seconds: 1)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPriceSection(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -3),
            blurRadius: 10,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: AppStyles.headline2),
              Text(
                '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                style: AppStyles.headline1.copyWith(color: AppColors.primary, fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          RoundedButton(
            text: 'Checkout',
            press: () {
              // Placeholder checkout action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Checkout process not implemented yet.'), duration: Duration(seconds: 2)),
              );
              // Optionally clear cart after simulated checkout
              // cartProvider.clearCart();
            },
            widthFactor: 1.0, // Full width
          ),
        ],
      ),
    );
  }
}

