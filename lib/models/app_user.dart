class AppUser {
  final String name;
  final String email;
  final String role;

  const AppUser({
    required this.name,
    required this.email,
    this.role = 'user',
  });

  bool get isAdmin => role == 'admin';
}
