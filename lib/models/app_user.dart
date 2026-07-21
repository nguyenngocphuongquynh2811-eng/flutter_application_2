class AppUser {
  final String name;
  final String email;
  final String password;
  final String role;

  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        role: json['role'] as String? ?? 'user',
      );
}
