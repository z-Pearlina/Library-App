import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../../models/book.dart';
import '../../providers/favorites_provider.dart'; // Import FavoritesProvider
import '../../providers/cart_provider.dart'; // Import CartProvider
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../widgets/rounded_button.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Access providers
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final bool isFavorite = favoritesProvider.isFavorite(book);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, isFavorite, favoritesProvider),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookImageSection(size),
            _buildBookInfoSection(context),
            _buildActionButtons(context, cartProvider),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isFavorite, FavoritesProvider provider) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          // Update icon based on favorite status
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: AppColors.primary,
            size: 28,
          ),
          onPressed: () {
            // Toggle favorite status using the provider
            provider.toggleFavorite(book);
          },
        ),
        const SizedBox(width: 16.0),
      ],
    );
  }

  Widget _buildBookImageSection(Size size) {
    // Same as before
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: size.height * 0.35,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            book.imageUrl,
            fit: BoxFit.cover,
            width: size.width * 0.55,
            errorBuilder: (context, error, stackTrace) {
              print("Error loading image in details: ${book.imageUrl} - $error");
              // Fallback placeholder if image fails
              return Container(
                width: size.width * 0.55,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: size.width * 0.2,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            },
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 20,
                color: Colors.black.withOpacity(0.15),
              )
            ]
        ),
      ),
    );
  }

  Widget _buildBookInfoSection(BuildContext context) {
    // Same as before, but potentially add cart status later if needed
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: AppStyles.headline1.copyWith(fontSize: 24)),
                    const SizedBox(height: 4.0),
                    Text(book.author, style: AppStyles.subtitle1),
                    const SizedBox(height: 8.0),
                    _buildRatingStars(),
                  ],
                ),
              ),
              Text(
                '\$${book.price.toStringAsFixed(2)}',
                style: AppStyles.headline1.copyWith(color: AppColors.primary, fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          _buildTags(),
          const SizedBox(height: 24.0),
          const Text('Book Overview', style: AppStyles.headline2),
          const SizedBox(height: 10.0),
          Text(
            book.overview,
            style: AppStyles.bodyText1.copyWith(height: 1.6, color: AppColors.textSecondary),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () { /* TODO: Show full overview */ },
            child: Text('read more', style: AppStyles.bodyText2.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, alignment: Alignment.centerLeft),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    // Same as before
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.starColor, size: 20.0),
        const SizedBox(width: 4.0),
        Text(
          '${book.rating} / ${book.reviews} reviews',
          style: AppStyles.bodyText2,
        ),
      ],
    );
  }

  Widget _buildTags() {
    // Same as before
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: book.tags.map((tag) => Chip(
        label: Text(tag, style: AppStyles.tag.copyWith(color: AppColors.primary.withOpacity(0.8))),
        backgroundColor: AppColors.primary.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide.none,
        ),
      )).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context, CartProvider cartProvider) {
    // Update cart button action later in Cart feature implementation
    bool alreadyInCart = cartProvider.isInCart(book);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        children: [
          // Cart Button (Update action later)
          InkWell(
            onTap: () {
              if (alreadyInCart) {
                cartProvider.removeFromCart(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${book.title} removed from cart'), duration: const Duration(seconds: 1)),
                );
              } else {
                cartProvider.addToCart(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${book.title} added to cart'), duration: const Duration(seconds: 1)),
                );
              }
            },
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.05),
                    )
                  ]
              ),
              // Change icon based on cart status
              child: Icon(
                  alreadyInCart ? Icons.remove_shopping_cart_outlined : Icons.add_shopping_cart_outlined,
                  color: AppColors.primary,
                  size: 28
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          // Buy Now Button (Placeholder action)
          Expanded(
            child: RoundedButton(
              text: 'Buy Now >',
              press: () { /* TODO: Implement purchase action */ },
              widthFactor: 1.0,
              borderRadius: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

