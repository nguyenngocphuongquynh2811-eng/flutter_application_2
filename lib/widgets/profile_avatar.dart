import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: const DecorationImage(
          image: AssetImage('assets/images/avatar.jpg'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
    );
  }
}