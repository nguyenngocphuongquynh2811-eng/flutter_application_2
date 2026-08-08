class AppUser {
  final String name;
  final String email;
  final String role;
  final String? avatarBase64;

  const AppUser({
    required this.name,
    required this.email,
    this.role = 'user',
    this.avatarBase64,
  });

  bool get isAdmin => role == 'admin';
}
