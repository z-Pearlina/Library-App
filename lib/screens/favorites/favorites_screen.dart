import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/book_card.dart'; // Reuse BookCard
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the FavoritesProvider
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteBooks = favoritesProvider.favoriteBooks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Favorites', style: AppStyles.headline2),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true, // Center title for this screen
        // No back button needed if accessed via bottom nav
      ),
      body: favoriteBooks.isEmpty
          ? Center(
              child: Text(
                'You haven\'t added any books to your favorites yet.',
                style: AppStyles.subtitle1,
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                // Use the vertical layout BookCard for the list
                return BookCard(book: favoriteBooks[index], isHorizontal: false);
              },
            ),
    );
  }
}

