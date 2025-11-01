import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:project_akhir/models/user_model.dart';

class AuthService {
  // Pastikan box-box ini sudah dibuka sebelum AuthService diinisialisasi di main()
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
      final String supabaseUid = user.id; // UID Supabase (String)
      
      // Menggunakan Supabase UID sebagai Hive Key untuk mencari data lokal
      final UserModel? userInBox = userBox.get(supabaseUid); 

      if (userInBox != null) {
        // Jika data user lokal ada, simpan Supabase UID sebagai kunci sesi aktif
        await sessionBox.put('currentUserKey', supabaseUid); 
      } else {
        // Jika data lokal tidak ada (meskipun Supabase login berhasil),
        // disarankan untuk fetch data user dari Supabase DB dan menyimpannya di Hive,
        // namun untuk saat ini, kita biarkan session kosong di Hive.
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

  // 🔹 SIMPAN DATA USER LOKAL (Dipanggil setelah SIGN UP berhasil)
  Future<void> saveUserDataLocally({
    required String uid, // Menerima Supabase UID dari response sign up
    required String firstName,
    required String lastName,
    required String username,
    required String email,
  }) async {
    final user = UserModel(
      id: uid, // Simpan UID Supabase di field 'id'
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
    );

    // Gunakan put(key, value) dengan UID (String) sebagai key Hive.
    await userBox.put(uid, user); 

    // Simpan UID (String) dari user yang baru saja dibuat sebagai user aktif
    await sessionBox.put('currentUserKey', uid); 
  }

  // 🔹 SINKRONISASI SESI LOKAL SAAT APP START
  Future<void> syncLocalSession() async {
    // 1. Cek apakah sesi lokal sudah ada
    if (sessionBox.get('currentUserKey') != null) {
      return; // Sudah ada, tidak perlu melakukan apa-apa
    }

    // 2. Cek apakah ada sesi aktif di Supabase (misalnya, setelah restart aplikasi)
    final currentSupabaseUser = _supabase.auth.currentUser;
    if (currentSupabaseUser != null) {
      final String supabaseUid = currentSupabaseUser.id;
      
      // 3. Cek apakah data user ada di Hive menggunakan UID Supabase
      final UserModel? userInBox = userBox.get(supabaseUid);
      
      if (userInBox != null) {
        // Jika ditemukan, simpan kembali UID Supabase sebagai kunci sesi aktif
        await sessionBox.put('currentUserKey', supabaseUid);
      }
    }
  }

  // 🔹 GET USER YANG SEDANG AKTIF
  UserModel? getCurrentUser() {
    // Key yang disimpan adalah String (Supabase UID)
    final String? currentUserKey = sessionBox.get('currentUserKey'); 
    if (currentUserKey == null) return null;
    
    // Mengambil user dari userBox menggunakan String key
    return userBox.get(currentUserKey);
  }

  // 🔹 SIGN OUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    // Hapus kunci sesi lokal saat sign out
    await sessionBox.delete('currentUserKey'); 
  }
}
