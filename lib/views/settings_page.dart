import 'package:flutter/material.dart';
import 'package:project_akhir/services/auth/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final authService = AuthService();
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),), 
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.black, size: 16),
                    title: Text('Akun', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),), 
                    onTap: (){
                      Navigator.pushNamed(context,'/profil');
                    }
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.message, color: Colors.black, size: 16),
                    title: Text('Saran & Kesan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),), 
                    onTap: (){
                      Navigator.pushNamed(context, '/sarankesan');
                    }
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: const Color.fromARGB(255, 255, 67, 67), size: 16),
                    title: Text('Log Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),), 
                    onTap: (){
                      authService.signOut();
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    }
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}