import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_akhir/models/user_model.dart';
import 'package:project_akhir/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _namaDepanController = TextEditingController();
  final _namaBelakangController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void register() async {
    final email = _emailController.text;
    final namaDepan = _namaDepanController.text;
    final namaBelakang = _namaBelakangController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Password tidak sesuai")));
    }

    try {
      final response = await authService.signUpWithEmailPassword(
        email,
        password,
      );

      await authService.saveUserDataLocally(
        firstName: namaDepan,
        lastName: namaBelakang,
        username: username,
        email: email,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Registrasi berhasil")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign Up",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "Masuk untuk melanjutkan.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Container(
                child: Column(
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _namaDepanController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 252, 252, 252),
                              labelText: "Nama Depan",
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _namaBelakangController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 252, 252, 252),
                              labelText: "Nama Belakang",
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 252, 252, 252),
                        labelText: "Username",
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 252, 252, 252),
                        labelText: "Email",
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 252, 252, 252),
                          labelText: "Password",
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 252, 252, 252),
                          labelText: "Confirm Password",
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("Sudah punya akun?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            " Masuk di sini.",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
