import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart'; // otomatis dihasilkan nanti

@HiveType(typeId: 0) // Pastikan typeId unik
class UserModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String username;

  @HiveField(4)
  String email;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
  });
}
