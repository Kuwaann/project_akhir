// lib/models/user.dart

class User {
  final int? idUser;
  final String namaDepan;
  final String namaBelakang;
  final String usernameAkun;
  final String? fotoPathAkun; // Path foto bisa null

  User({
    this.idUser,
    required this.namaDepan,
    required this.namaBelakang,
    required this.usernameAkun,
    this.fotoPathAkun,
  });

  // Konversi objek User menjadi Map (untuk INSERT dan UPDATE ke database)
  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser,
      'namadepan_user': namaDepan,
      'namabelakang_user': namaBelakang,
      'username_akun': usernameAkun,
      'fotopath_akun': fotoPathAkun,
    };
  }

  // Konversi Map (dari database) menjadi objek User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['id_user'] as int?,
      namaDepan: map['namadepan_user'] as String,
      namaBelakang: map['namabelakang_user'] as String,
      usernameAkun: map['username_akun'] as String,
      // Karena fotopath_akun bisa NULL, kita perlu casting yang aman
      fotoPathAkun: map['fotopath_akun'] as String?, 
    );
  }
}