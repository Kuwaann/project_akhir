// lib/models/user_model.dart

import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0) // Pastikan typeId unik
class UserModel extends HiveObject {
  @HiveField(0)
  // 🚀 PERUBAHAN UTAMA: Ubah int menjadi String untuk menampung Supabase UID
  late String id; 

  @HiveField(1)
  late String firstName;

  @HiveField(2)
  late String lastName;

  @HiveField(3)
  late String username;

  @HiveField(4)
  late String email;

  UserModel({
    // PERUBAHAN DI CONSTRUCTOR
    required this.id, // Sekarang menerima String (Supabase UID)
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
  });
}