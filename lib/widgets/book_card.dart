import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../screens/details/book_details_screen.dart'; // For navigation

class BookCard extends StatelessWidget {
  final Book book;
  final bool isHorizontal; // To adjust layout for carousel vs list

  const BookCard({Key? key, required this.book, this.isHorizontal = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = isHorizontal ? 150.0 : double.infinity;
    final cardHeight = isHorizontal ? 240.0 : 120.0; // Adjust height for vertical list

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: isHorizontal
            ? const EdgeInsets.only(right: 16.0)
            : const EdgeInsets.only(bottom: 16.0),
        child: isHorizontal ? _buildHorizontalLayout() : _buildVerticalLayout(),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    // Layout for Recommended Carousel
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              color: Colors.grey[200], // Background color if image fails to load
              child: Image.asset(
                book.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: ${book.imageUrl} - $error');
                  return Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400]));
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(book.title, style: AppStyles.bodyText1.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4.0),
        Row(
          children: [
            const Icon(Icons.star, color: AppColors.starColor, size: 16.0),
            const SizedBox(width: 4.0),
            Text(book.rating.toString(), style: AppStyles.bodyText2),
          ],
        ),
        const SizedBox(height: 4.0),
        Text('\$${book.price.toStringAsFixed(2)}', style: AppStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    // Layout for Best Seller List
    return Container(
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
            child: Container(
              width: 80, height: 100,
              color: Colors.grey[200], // Background color if image fails to load
              child: Image.asset(
                book.imageUrl,
                fit: BoxFit.cover,
                width: 80,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: ${book.imageUrl} - $error');
                  return Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400]));
                },
              ),
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
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.starColor, size: 16.0),
                    const SizedBox(width: 4.0),
                    Text('${book.rating} (${book.reviews} reviews)', style: AppStyles.bodyText2),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${book.price.toStringAsFixed(2)}', style: AppStyles.headline2.copyWith(fontSize: 18)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              )
            ],
          )
        ],
      ),
    );
  }
}

