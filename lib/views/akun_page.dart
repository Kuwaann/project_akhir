import 'package:flutter/material.dart';
import 'package:project_akhir/models/user_model.dart';
import 'package:project_akhir/services/auth/auth_service.dart'; // pastikan path sesuai

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final UserModel? user = _authService.getCurrentUser();

    // URL foto profil statis
    const profileImageUrl =
        'https://images.unsplash.com/photo-1502685104226-ee32379fefbe';

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
        body: const Center(child: Text('Data pengguna tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
              ),
              const SizedBox(height: 20),

              // Nama Lengkap
              Text(
                "${user.firstName} ${user.lastName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),

              // Username
              Text(
                "@${user.username}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // Informasi Detail
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow("Email", user.email),
                    _buildInfoRow("Username", "@${user.username}"),
                    _buildInfoRow("Nama Lengkap", "${user.firstName} ${user.lastName}"),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
