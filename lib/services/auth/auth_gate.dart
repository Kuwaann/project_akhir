import 'package:flutter/material.dart';
import 'package:project_akhir/services/auth/auth_service.dart';
import 'package:project_akhir/views/home_page.dart';
import 'package:project_akhir/views/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // Memantau status autentikasi dari Supabase
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          // Jika ada sesi Supabase (User terautentikasi),
          // jalankan proses sinkronisasi sesi lokal (Hive).
          return FutureBuilder(
            // 🚀 PERBAIKAN: syncLocalSession() dipanggil tanpa argumen email
            future: _authService.syncLocalSession(), 
            builder: (context, syncSnapshot) {
              if (syncSnapshot.connectionState == ConnectionState.waiting) {
                // Tampilkan loading saat Hive sedang disinkronisasi
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              // Setelah sinkronisasi selesai, user bisa masuk ke HomePage
              return const HomePage();
            },
          );
        } else {
          // Jika tidak ada sesi Supabase, arahkan ke WelcomePage untuk Login/Register
          return const WelcomePage();
        }
      },
    );
  }
}
