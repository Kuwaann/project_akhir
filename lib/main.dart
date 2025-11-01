// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:project_akhir/services/auth/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_akhir/models/user_model.dart';
import 'package:project_akhir/views/book_detail.dart';
import 'package:project_akhir/views/booking_page.dart';
import 'package:project_akhir/views/home_page.dart';
import 'package:project_akhir/views/jadwal_saya.dart';
import 'package:project_akhir/views/lapangan_detail.dart';
import 'package:project_akhir/views/login_page.dart';
import 'package:project_akhir/views/register_page.dart';
import 'package:project_akhir/views/search_page.dart';
import 'package:project_akhir/views/settings_page.dart';
import 'package:project_akhir/views/welcome_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Hive
  await Hive.initFlutter();

  // 2. Registrasi adapter
  Hive.registerAdapter(UserModelAdapter());

  // 3. Buka semua box yang akan digunakan
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox('sessionBox');

  await Supabase.initialize(
    url: 'https://kngykzktxhftfxeqtebm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtuZ3lremt0eGhmdGZ4ZXF0ZWJtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NzgwNDgsImV4cCI6MjA3NzQ1NDA0OH0.EnxDg5Y6Se9Wy49Yamsu7j5pBCHJspXSU9MMWSp_j4o',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      routes: {
        '/': (context) => AuthGate(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/search': (context) => SearchPage(),
        '/settings': (context) => SettingsPage(),
        '/detail_lapangan': (context) => LapanganDetail(),
        '/booking_saya': (context) => BookingSayaPage(),
        '/detail_book': (context) => BookDetail(),
        '/booking': (context) => BookingPage(),
      },
      initialRoute: '/',
    );
  }
}
