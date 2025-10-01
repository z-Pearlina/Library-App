import 'package:shared_preferences/shared_preferences.dart';

// Service class to manage user session using SharedPreferences
class SharedPrefsService {
  static const String _userIdKey = 'logged_in_user_id';
  static const String _userNameKey = 'logged_in_user_name'; // Key for user name

  // Save the user ID and name to indicate a logged-in session
  Future<void> saveUserSession({required String userId, required String userName}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, userName); // Save user name
    print("User session saved: ID=$userId, Name=$userName");
  }

  // Check if a user session exists
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    print("Checking login status: userId = $userId");
    return userId != null && userId.isNotEmpty;
  }

  // Get the logged-in user's ID (if any)
  Future<String?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Get the logged-in user's name (if any)
  Future<String?> getLoggedInUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_userNameKey);
    print("Retrieved user name from prefs: $name");
    return name;
  }

  // Clear the user session (logout)
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey); // Remove user name on logout
    print("User session cleared");
  }
}

