// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:project_akhir/models/booking_model.dart';
import 'package:project_akhir/services/auth/auth_gate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_akhir/models/user_model.dart';
import 'package:project_akhir/services/auth/auth_service.dart';
import 'package:project_akhir/views/akun_page.dart';
import 'package:project_akhir/views/book_detail.dart';
import 'package:project_akhir/views/booking_page.dart';
import 'package:project_akhir/views/home_page.dart';
import 'package:project_akhir/views/jadwal_saya.dart';
import 'package:project_akhir/views/konversi_zonawaktu_page.dart';
import 'package:project_akhir/views/lapangan_detail.dart';
import 'package:project_akhir/views/login_page.dart';
import 'package:project_akhir/views/register_page.dart';
import 'package:project_akhir/views/sarankesan_page.dart';
import 'package:project_akhir/views/search_page.dart';
import 'package:project_akhir/views/settings_page.dart';
import 'package:project_akhir/views/welcome_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/lapangan_model.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Hive
  await Hive.initFlutter();

  // 2. Registrasi adapter
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TempatOlahragaAdapter());
  Hive.registerAdapter(BookingModelAdapter());

  // 3. Buka semua box yang akan digunakan
  await Hive.openBox<UserModel>('userBox');
  await Hive.openBox<TempatOlahraga>('lapanganBox');
  await Hive.openBox<BookingModel>('bookingBox');
  await Hive.openBox('sessionBox');

  await Supabase.initialize(
    url: 'https://kngykzktxhftfxeqtebm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtuZ3lremt0eGhmdGZ4ZXF0ZWJtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NzgwNDgsImV4cCI6MjA3NzQ1NDA0OH0.EnxDg5Y6Se9Wy49Yamsu7j5pBCHJspXSU9MMWSp_j4o',
  );

  await NotificationService().initialize();
  
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
        '/detail_lapangan': (context) {
          // Ketika rute '/detail' dipanggil, kita berharap ada argumen
          // yang dilewatkan, yaitu objek TempatOlahraga.
            final settings = ModalRoute.of(context)?.settings;
            final tempat = settings?.arguments as TempatOlahraga?;

            // Pastikan data tidak null sebelum membangun widget
            if (tempat == null) {
              // Handle error atau kembali ke halaman sebelumnya
              return const Scaffold(body: Center(child: Text('Error: Data Lapangan tidak ditemukan.')));
            }
            
            return LapanganDetail(tempat: tempat);
        },
        '/booking_saya': (context) {
          final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? 'guest_user_id';

          return BookingSayaPage(userId: currentUserId);
        },
        '/detail_book': (context) {
          final settings = ModalRoute.of(context)?.settings;
          final booking = settings?.arguments as BookingModel?;

          if (booking == null) {
            return const Scaffold(
              body: Center(child: Text('Error: Data booking tidak ditemukan.')),
            );
          }

          return BookDetail(booking: booking);
        },
        '/booking': (context) {
          // Ambil argumen data lapangan
            final settings = ModalRoute.of(context)?.settings;
            final tempat = settings?.arguments as TempatOlahraga?;
            
            // 1. Ambil Supabase User ID
            final currentUserId = Supabase.instance.client.auth.currentUser?.id;

            // Pastikan data lapangan tidak null sebelum membangun widget
            if (tempat == null) {
              return const Scaffold(body: Center(child: Text('Error: Data Lapangan tidak ditemukan.')));
            }
            
            // 2. Pastikan user ID tidak null
            if (currentUserId == null) {
              // Jika user ID tidak ada, arahkan kembali ke login atau tampilkan pesan error
              return const Scaffold(body: Center(child: Text('Error: Pengguna belum login. Silakan coba login ulang.')));
            }
            
            // FIX: Panggil BookingPage dengan userId yang sudah diambil
            return BookingPage(tempat: tempat, userId: currentUserId); 
        },
        '/sarankesan' : (context) => SaranKesanPage(),
        '/zonawaktu' : (context) => KonversiZonaWaktuPage(),
        '/profil' : (context) => ProfilePage(),
      },
      initialRoute: '/',
    );
  }
}
