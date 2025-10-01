import 'package:pearlibrary/models/user.dart';

// Abstract interface for the User repository (Domain Layer)
abstract class UserRepository {
  Future<User?> getUserByEmail(String email);
  Future<User?> loginUser(String email, String password);
  // Updated registerUser signature to include name
  Future<User?> registerUser(String name, String email, String password);
  Future<List<User>> getAllUsers(); // Helper for managing JSON
}

