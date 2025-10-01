class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double rating;
  final int reviews;
  final double price;
  final List<String> tags;
  final String overview;
  final bool isRecommended;
  final bool isBestSeller;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.tags,
    required this.overview,
    this.isRecommended = false,
    this.isBestSeller = false,
  });
}

