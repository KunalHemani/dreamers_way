import 'package:dreamers_way/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Demo',
          style: TextStyle(
              fontSize: 22
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          // padding: const EdgeInsets.all(25.0),
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
          child: Center(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text('Login Here',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600
                    ),
                  ),

                  SizedBox(height: 70),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                  ),

                  SizedBox(height: 25),

                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.password_rounded),
                    ),
                  ),

                  SizedBox(height: 50),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => HomePage()));
                    },
                    child: Text('Login',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // SizedBox(height: 8),
                  // Container(
                  //   child: Text("Don't have an account? Register here",
                  //     style: TextStyle(
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w400
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
