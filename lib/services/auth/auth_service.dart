import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_akhir/models/user_model.dart';

class AuthService {
  final userBox = Hive.box<UserModel>('userBox');
  final sessionBox = Hive.box('sessionBox');
  final SupabaseClient _supabase = Supabase.instance.client;

  // 🔹 SIGN IN
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      // Setelah login, cari user di Hive berdasarkan email
      final userInBox = userBox.values.firstWhere(
        (userModel) => userModel.email == email,
        orElse: () => UserModel(
          id: -1,
          firstName: '',
          lastName: '',
          username: '',
          email: '',
        ), // return dummy if not found
      );

      // Jika user ditemukan di Hive, simpan Hive key-nya ke session
      if (userInBox.id != -1) {
        await sessionBox.put('currentUserKey', userInBox.key);
      } else {
        // Kasus jarang terjadi: user ada di Supabase tapi tidak di Hive.
        // Anda bisa menambahkan logic untuk mengambil data dari server jika perlu,
        // atau membiarkannya karena data akan dibuat saat registrasi.
        // Untuk saat ini, kita pastikan session kosong jika data lokal tidak ada.
        await sessionBox.delete('currentUserKey');
      }
    }

    return response;
  }

  // 🔹 SIGN UP
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  // 🔹 SIMPAN DATA USER LOKAL
  Future<void> saveUserDataLocally({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
  }) async {
    final user = UserModel(
      id: 0, // ID awal, akan diabaikan oleh Hive saat menggunakan add()
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
    );

    // `add` akan menyimpan objek dan memberikan auto-incrementing key (integer)
    final int userKey = await userBox.add(user);

    // Simpan key dari user yang baru saja dibuat sebagai user aktif
    await sessionBox.put('currentUserKey', userKey);
  }

  // 🔹 SINKRONISASI SESI LOKAL SAAT APP START
  Future<void> syncLocalSession(String email) async {
    // Cek apakah sesi lokal sudah ada
    if (sessionBox.get('currentUserKey') != null) {
      return; // Jika sudah ada, tidak perlu melakukan apa-apa
    }

    // Jika sesi lokal belum ada, cari user di Hive berdasarkan email
    final userInBox = userBox.values.firstWhere(
      (userModel) => userModel.email == email,
      orElse: () => UserModel(
        id: -1,
        firstName: '',
        lastName: '',
        username: '',
        email: '',
      ),
    );

    // Jika user ditemukan di Hive, simpan Hive key-nya ke session
    if (userInBox.id != -1) {
      await sessionBox.put('currentUserKey', userInBox.key);
    }
  }

  // 🔹 GET USER YANG SEDANG AKTIF
  UserModel? getCurrentUser() {
    final currentUserKey = sessionBox.get('currentUserKey');
    if (currentUserKey == null) return null;
    return userBox.get(currentUserKey);
  }

  // 🔹 SIGN OUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await sessionBox.delete('currentUserKey');
  }
}
