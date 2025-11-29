import 'package:flutter/material.dart';

class SaranKesanPage extends StatelessWidget {
  const SaranKesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Saran & Kesan Saya",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Mata kuliah Pemrograman Aplikasi Mobile (PAM) ini adalah mata kuliah yang mengasyikkan dalam praktiknya. Namun, menurut saya untuk pelaksanaan mata kuliah PAM ini sangat terkesan terburu-buru. Kita dituntut untuk mendevelop aplikasi yang fiturnya berbagai macam, yang bahkan kita belum mempelajari. Saran saya adalah pembukaan pengumpulan project akhirnya kalau bisa di jauh-jauh hari",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
