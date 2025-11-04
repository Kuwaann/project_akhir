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
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.data?.session;
        if (session != null) {
          // Sinkronisasi data lokal sebelum HomePage
          return FutureBuilder(
            future: authService.syncLocalSession(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
              return const HomePage();
            },
          );
        } else {
          return const WelcomePage();
        }
      },
    );
  }
}
