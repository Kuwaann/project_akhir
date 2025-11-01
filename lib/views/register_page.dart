import 'package:flutter/material.dart';
import 'package:project_akhir/services/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Penting: Import Supabase untuk AuthResponse

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Instance AuthService harus diinisialisasi
  final authService = AuthService(); 
  
  // Controllers
  final _emailController = TextEditingController();
  final _namaDepanController = TextEditingController();
  final _namaBelakangController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // State untuk Loading
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _namaDepanController.dispose();
    _namaBelakangController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void register() async {
    setState(() {
      _isLoading = true;
    });
    
    final email = _emailController.text.trim();
    final namaDepan = _namaDepanController.text.trim();
    final namaBelakang = _namaBelakangController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    // 1. Validasi Input
    if (email.isEmpty || namaDepan.isEmpty || username.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua kolom wajib diisi")),
        );
      }
      setState(() { _isLoading = false; });
      return; 
    }

    // 2. Validasi Konfirmasi Password
    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password dan Konfirmasi Password tidak sesuai")),
        );
      }
      setState(() { _isLoading = false; });
      return; 
    }

    try {
      // 3. SIGN UP KE SUPABASE
      final AuthResponse response = await authService.signUpWithEmailPassword(
        email,
        password,
      );

      // 4. Ambil Supabase UID dari response
      final String? uid = response.user?.id;
      
      if (uid == null) {
        // Handle error jika user ID tidak ditemukan setelah sign up berhasil
        // FIX: AuthResponse tidak memiliki getter 'error'. Langsung lempar AuthException.
        throw const AuthException('Gagal mendapatkan ID pengguna dari Supabase. Coba periksa koneksi atau detail pendaftaran.');
      }
      
      // 5. SIMPAN DATA PENGGUNA DENGAN UID SUPABASE
      await authService.saveUserDataLocally(
        uid: uid, // <-- Meneruskan UID Supabase
        firstName: namaDepan,
        lastName: namaBelakang,
        username: username,
        email: email,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Registrasi berhasil. Silakan masuk.")));
        // Kembali ke halaman login
        Navigator.pop(context); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error Registrasi: ${e.toString()}")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 80, left: 50, right: 50, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Judul dan Subjudul
              const SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "Daftar untuk membuat akun.", 
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              
              // Form Input
              Column(
                children: [
                  // Nama Depan dan Belakang
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _namaDepanController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 252, 252, 252),
                            labelText: "Nama Depan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20), // Spasi antar field
                      Expanded(
                        child: TextFormField(
                          controller: _namaBelakangController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 252, 252, 252),
                            labelText: "Nama Belakang",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 252, 252, 252),
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 252, 252, 252),
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 252, 252, 252),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm Password
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 252, 252, 252),
                      labelText: "Konfirmasi Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Tombol Sign Up
                  SizedBox(
                    width: double.infinity,
                    height: 50, 
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : register, // Disabled saat loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Link ke Halaman Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun?"),
                      GestureDetector(
                        onTap: () {
                          // Gunakan pop untuk kembali ke halaman sebelumnya (Login)
                          Navigator.pop(context); 
                        },
                        child: const Text(
                          " Masuk di sini.",
                          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
