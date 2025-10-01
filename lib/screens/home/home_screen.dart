import 'package:flutter/material.dart';
import 'package:pearlibrary/models/book.dart';
import 'package:pearlibrary/services/book_service.dart';
import 'package:pearlibrary/widgets/book_card.dart';
import 'package:pearlibrary/utils/app_colors.dart';
import 'package:pearlibrary/utils/app_styles.dart';
import 'package:pearlibrary/screens/favorites/favorites_screen.dart';
import 'package:pearlibrary/screens/cart/cart_screen.dart';
import 'package:pearlibrary/screens/search/search_screen.dart';
import 'package:pearlibrary/screens/free_books/free_books_screen.dart'; // Import FreeBooksScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index for bottom navigation

  // List of Widgets to display based on bottom nav selection
  // Replace placeholder with actual FreeBooksScreen
  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    FavoritesScreen(),
    CartScreen(),
    FreeBooksScreen(), // Use the actual Free Books Screen (index 3)
    Center(child: Text('Profile Page', style: AppStyles.headline2)), // Placeholder (index 4)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBarForIndex(_selectedIndex, context),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar? _buildAppBarForIndex(int index, BuildContext context) {
    switch (index) {
      case 0: // Home
        return _buildHomeAppBar(context);
      case 1: // Favorites
      case 2: // Cart
      case 3: // Free Books
      // Screens at index 1, 2, and 3 have their own AppBars or handle it internally
        return null;
      case 4: // Profile (Placeholder)
        return AppBar(
          title: const Text('Profile', style: AppStyles.headline2),
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
        );
      default:
        return null;
    }
  }

  AppBar _buildHomeAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
        onPressed: () { /* TODO: Implement drawer */ },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 8.0),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 20, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(Icons.home_outlined, 0), // Home
          _buildBottomNavItem(Icons.favorite_border_outlined, 1), // Favorites
          _buildBottomNavItem(Icons.shopping_bag_outlined, 2), // Cart
          _buildBottomNavItem(Icons.book_outlined, 3), // Free Books
          _buildBottomNavItem(Icons.person_outline, 4), // Profile
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        isSelected ? _getFilledIcon(icon) : icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        size: 28,
      ),
      onPressed: () => _onItemTapped(index),
    );
  }

  IconData _getFilledIcon(IconData outlinedIcon) {
    if (outlinedIcon == Icons.home_outlined) return Icons.home_filled;
    if (outlinedIcon == Icons.favorite_border_outlined) return Icons.favorite;
    if (outlinedIcon == Icons.shopping_bag_outlined) return Icons.shopping_bag;
    if (outlinedIcon == Icons.book_outlined) return Icons.book;
    if (outlinedIcon == Icons.person_outline) return Icons.person;
    return outlinedIcon;
  }
}

// HomeContent remains the same
class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final BookService _bookService = BookService();
  late Future<List<Book>> _recommendedBooksFuture;
  late Future<List<Book>> _bestSellerBooksFuture;

  @override
  void initState() {
    super.initState();
    _recommendedBooksFuture = _bookService.getRecommendedBooks();
    _bestSellerBooksFuture = _bookService.getBestSellerBooks();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Recommended', () { /* TODO: See All Action */ }),
            _buildRecommendedCarousel(),
            const SizedBox(height: 24.0),
            _buildSectionHeader('Best Seller', () { /* TODO: See All Action */ }),
            _buildBestSellerList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAllPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyles.headline2),
          TextButton(
            onPressed: onSeeAllPressed,
            child: Text('See all', style: AppStyles.bodyText2.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCarousel() {
    return FutureBuilder<List<Book>>(
      future: _recommendedBooksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 260, child: Center(child: CircularProgressIndicator(color: AppColors.primary)));
        }
        if (snapshot.hasError) {
          return SizedBox(height: 260, child: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(height: 260, child: Center(child: Text('No recommended books.')));
        }
        final books = snapshot.data!;
        return SizedBox(
          height: 260,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(book: books[index], isHorizontal: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildBestSellerList() {
    return FutureBuilder<List<Book>>(
      future: _bestSellerBooksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: List.generate(3, (index) => _buildLoadingBookCardVertical())),
          );
        }
        if (snapshot.hasError) {
          return Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Center(child: Text('Error: ${snapshot.error}')));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Center(child: Text('No best sellers.')));
        }
        final books = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(book: books[index], isHorizontal: false);
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingBookCardVertical() {
    return Container(
      height: 120.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [ BoxShadow( offset: const Offset(0, 2), blurRadius: 5, color: Colors.black.withOpacity(0.05)) ]
      ),
      child: Row(
        children: [
          Container(width: 80, height: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: Colors.grey[200])), // Image placeholder
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 16, width: double.infinity, color: Colors.grey[200], margin: const EdgeInsets.only(bottom: 8.0)), // Title placeholder
                Container(height: 12, width: 100, color: Colors.grey[200], margin: const EdgeInsets.only(bottom: 12.0)), // Author placeholder
                Container(height: 14, width: 150, color: Colors.grey[200]), // Rating placeholder
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(height: 18, width: 50, color: Colors.grey[200]), // Price placeholder
              Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200])), // Add button placeholder
            ],
          )
        ],
      ),
    );
  }
}

