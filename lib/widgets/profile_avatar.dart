import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final avatarBase64 = context.watch<AuthProvider>().currentUser?.avatarBase64;

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: avatarBase64 != null
              ? MemoryImage(base64Decode(avatarBase64))
              : const AssetImage('assets/images/avatar.jpg') as ImageProvider,
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
    );
  }
}
