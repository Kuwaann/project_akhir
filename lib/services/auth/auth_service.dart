import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_akhir/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final userBox = Hive.box<UserModel>('userBox'); 
  final sessionBox = Hive.box('sessionBox');
  final SupabaseClient _supabase = Supabase.instance.client;

  // SIGN UP
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  }

  // SIMPAN DATA LOKAL
  Future<void> saveUserDataLocally({
    required String uid,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
  }) async {
    final user = UserModel(
      id: uid,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
    );
    await userBox.put(uid, user);
    await sessionBox.put('currentUserKey', uid);
  }

  // SIGN IN
  Future<void> signInWithEmailPassword(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      final uid = user.id;

      // Cek Hive, kalau belum ada simpan manual dari auth
      if (!userBox.containsKey(uid)) {
        await saveUserDataLocally(
          uid: uid,
          firstName: '', 
          lastName: '',
          username: '',
          email: user.email ?? '',
        );
      }
      await sessionBox.put('currentUserKey', uid);
    } else {
      await sessionBox.delete('currentUserKey');
      throw Exception("Login gagal");
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    await sessionBox.delete('currentUserKey');
  }

  // SINKRONISASI SESI LOKAL
  Future<void> syncLocalSession() async {
    final currentSupabaseUser = _supabase.auth.currentUser;
    if (currentSupabaseUser != null) {
      final uid = currentSupabaseUser.id;
      if (!userBox.containsKey(uid)) {
        await saveUserDataLocally(
          uid: uid,
          firstName: '',
          lastName: '',
          username: '',
          email: currentSupabaseUser.email ?? '',
        );
      }
      await sessionBox.put('currentUserKey', uid);
    } else {
      await sessionBox.delete('currentUserKey');
    }
  }

  // GET CURRENT USER
  UserModel? getCurrentUser() {
    final key = sessionBox.get('currentUserKey');
    if (key == null) return null;
    return userBox.get(key);
  }
}
