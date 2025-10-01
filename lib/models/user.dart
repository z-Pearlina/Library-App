class User {
  final String id;
  final String name; // Added name field
  final String email;
  final String password; // In a real app, this should be hashed

  User({
    required this.id,
    required this.name, // Added name
    required this.email,
    required this.password,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as String,
      name: json["name"] as String? ?? "", // Handle potential missing name in older data
      email: json["email"] as String,
      password: json["password"] as String,
    );
  }

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name, // Added name
      "email": email,
      "password": password,
    };
  }
}

