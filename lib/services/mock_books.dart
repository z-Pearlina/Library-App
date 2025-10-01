import '../models/book.dart';

// Mock data for the bookstore app

final List<Book> mockBooks = [
  Book(
    id: '1',
    title: 'The Alchemist',
    author: 'Paulo Coelho',
    imageUrl: 'assets/images/alchemist.jpg', // Placeholder path, will need actual assets
    rating: 4.9,
    reviews: 1500,
    price: 15.00,
    tags: ['Fiction', 'Adventure', 'Philosophy'],
    overview: 'The Alchemist follows the journey of an Andalusian shepherd boy named Santiago...', // Add more detail
    isRecommended: true,
    isBestSeller: false,
  ),
  Book(
    id: '2',
    title: 'The Hobbit',
    author: 'J.R.R. Tolkien',
    imageUrl: 'assets/images/hobbit.png', // Placeholder path
    rating: 4.7,
    reviews: 2100,
    price: 14.00,
    tags: ['Fantasy', 'Adventure'],
    overview: 'The Hobbit, or There and Back Again, is a children\'s fantasy novel by English author J. R. R. Tolkien...',
    isRecommended: true,
    isBestSeller: false,
  ),
  Book(
    id: '3',
    title: 'Milk and Honey',
    author: 'Rupi Kaur',
    imageUrl: 'assets/images/milk_and_honey.jpeg', // Placeholder path
    rating: 4.8,
    reviews: 708,
    price: 18.00,
    tags: ['Poetry', 'Instapoetry'],
    overview: 'Milk and Honey is a collection of poetry and prose about survival. About the experience of violence, abuse, love, loss, and femininity.',
    isRecommended: false,
    isBestSeller: true,
  ),
  Book(
    id: '4',
    title: 'The 7 Habits of Highly Effective People',
    author: 'Stephen R. Covey',
    imageUrl: 'assets/images/7habits.jpeg', // Update the path accordingly
    rating: 4.8,
    reviews: 2500,
    price: 18.50,
    tags: ['Self-help', 'Productivity', 'Personal Development'],
    overview: 'This classic guide presents a principle-centered approach for solving personal and professional problems, promoting growth, effectiveness, and character development.',
    isRecommended: true,
    isBestSeller: true,
  ),
   Book(
    id: '5',
    title: 'Atomic Habits',
    author: 'James Clear',
    imageUrl: 'assets/images/atomic_habits.jpg', // Placeholder path
    rating: 4.9,
    reviews: 2500,
    price: 19.99,
    tags: ['Self-help', 'Productivity'],
    overview: 'An easy & proven way to build good habits & break bad ones. Tiny changes, remarkable results.',
    isRecommended: true,
    isBestSeller: true,
  ),
];

