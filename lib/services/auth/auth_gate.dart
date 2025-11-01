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
          // Jika ada sesi Supabase, kita perlu memastikan sesi lokal (Hive) juga di-set.
          // Kita gunakan FutureBuilder untuk menjalankan proses ini.
          return FutureBuilder(
            future: _authService.syncLocalSession(session.user.email!),
            builder: (context, syncSnapshot) {
              if (syncSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              // Setelah sesi lokal sinkron, baru tampilkan HomePage
              return const HomePage();
            },
          );
        } else {
          // Jika tidak ada sesi sama sekali, tampilkan WelcomePage
          return const WelcomePage();
        }
      },
    );
  }
}
