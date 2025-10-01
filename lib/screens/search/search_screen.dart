import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../services/mock_books.dart'; // Access mock data directly for simplicity
import '../../widgets/book_card.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _hasSearched = false; // To show initial message or results

  @override
  void initState() {
    super.initState();
    // Add listener to controller to update search results dynamically
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _hasSearched = true; // Mark that a search has been attempted
      if (query.isEmpty) {
        _searchResults = []; // Clear results if query is empty
      } else {
        _searchResults = mockBooks
            .where((book) => book.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildSearchBar(),
        titleSpacing: 0, // Remove default spacing for custom search bar
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0), // Adjust margin
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true, // Automatically focus the search bar
        decoration: InputDecoration(
          hintText: 'Search books by title...',
          hintStyle: AppStyles.bodyText2,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10.0), // Adjust padding
          // Add clear button if needed
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    // _performSearch(); // Listener will handle this
                  },
                )
              : null,
        ),
        style: AppStyles.bodyText1,
        onSubmitted: (_) => _performSearch(), // Allow searching via keyboard action
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!_hasSearched || _searchController.text.trim().isEmpty) {
      return const Center(
        child: Text(
          'Start typing to search for books.',
          style: AppStyles.subtitle1,
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          'No books found matching "${_searchController.text}".',
          style: AppStyles.subtitle1,
          textAlign: TextAlign.center,
        ),
      );
    }

    // Display results using BookCard (vertical layout)
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return BookCard(book: _searchResults[index], isHorizontal: false);
      },
    );
  }
}

