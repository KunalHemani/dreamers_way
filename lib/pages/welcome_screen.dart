import 'package:dreamers_way/pages/login.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/t6.jpg"),
            fit: BoxFit.cover,
          )
      ),

      child: Material(
        color: Colors.transparent,
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(80),
              child: Column(
                children: [
                  Text("Welcome to Dreamer's Way",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87
                    ),
                  ),
                  SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Icon(
                        Icons.navigate_next_rounded,
                        size: 65,
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
