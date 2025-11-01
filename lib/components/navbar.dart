import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(
              color: const Color.fromARGB(255, 238, 238, 238),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            borderRadius: BorderRadius.circular(50)
          ),
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            spacing: 20,
            children: [
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/settings');
                }, 
                icon: Icon(
                  Icons.settings
                  ),
                  color: Colors.black,
              ),
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/home');
                }, 
                icon: Icon(
                  Icons.home
                  ),
                  color: Colors.black,
              ),
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/search');
                }, 
                icon: Icon(
                  Icons.search
                  ),
                  color: Colors.black,
              ),
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/profil');
                }, 
                icon: Icon(
                  Icons.person
                  ),
                  color: Colors.black,
              )
            ],
          ),
        ),
      )
    );
  }
}