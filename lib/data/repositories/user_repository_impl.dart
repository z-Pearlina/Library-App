import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pearlibrary/models/user.dart';
import 'package:uuid/uuid.dart';
import 'package:pearlibrary/domain/repositories/user_repository.dart';

// Implementation of the UserRepository using local JSON file (Data Layer)
class UserRepositoryImpl implements UserRepository {
  static const String _fileName = 'users.json';
  final Uuid _uuid = const Uuid();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<List<User>> _readUsers() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        await file.create(recursive: true);
        await file.writeAsString('[]'); // Create empty JSON array if file doesn't exist
        return []; // Return empty list
      }
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = json.decode(contents) as List<dynamic>;
      return jsonList.map((jsonItem) => User.fromJson(jsonItem as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error reading users file: $e");
      // Consider returning empty list or throwing a specific exception
      return [];
    }
  }

  Future<void> _writeUsers(List<User> users) async {
    try {
      final file = await _localFile;
      final jsonList = users.map((user) => user.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print("Error writing users file: $e");
      // Handle error appropriately
    }
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final users = await _readUsers();
    try {
      return users.firstWhere((user) => user.email.toLowerCase() == email.toLowerCase());
    } catch (e) {
      return null; // User not found
    }
  }

  @override
  Future<User?> loginUser(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null && user.password == password) {
      // In a real app, compare hashed passwords
      return user; // Return the full user object including name
    }
    return null; // Invalid credentials
  }

  // Updated registerUser to accept name
  @override
  Future<User?> registerUser(String name, String email, String password) async {
    final existingUser = await getUserByEmail(email);
    if (existingUser != null) {
      // User already exists
      return null;
    }

    // Create new user with name
    final newUser = User(
      id: _uuid.v4(), // Generate unique ID
      name: name, // Save the name
      email: email,
      password: password, // Store plain text for mock, hash in real app
    );

    final users = await _readUsers();
    users.add(newUser);
    await _writeUsers(users);
    return newUser;
  }

  @override
  Future<List<User>> getAllUsers() async {
    return await _readUsers();
  }
}

