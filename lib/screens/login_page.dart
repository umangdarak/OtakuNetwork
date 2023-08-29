import 'package:flutter/material.dart';
import 'package:otaku_connect/reponsive/mobile_screen.dart';
import 'package:otaku_connect/resources/firebase_auth.dart';
import 'package:otaku_connect/screens/signup_page.dart';

import '../reponsive/responsive_layout.dart';
import '../reponsive/web_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  bool _isLoading = false;
  void a() {
    setState(() {
      _isLoading = false;
    });
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginuser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'Success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ResponsiveLayout(
                MobileLayout: MobileScreen(),
                WebLayout: WebScreen(),
              ),
            ),
            (route) => false);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text(res)),
            backgroundColor: ThemeData.dark().scaffoldBackgroundColor));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Center(
                    child: Text(
                      'OtakuConnect',
                      style: TextStyle(
                        fontFamily: 'caveat',
                        fontSize: 40,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Enter your Email'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Password'),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      login();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Center(
                              child: Text(
                              'Log In',
                              style: TextStyle(fontSize: 20),
                            )),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      child: const Text("Don't have an account?"),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ), // EdgeInsets.symmetric
                    ), // Container
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()));
                      },
                      child: Container(
                          child: const Text(
                        "Sign up.",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    )
                  ])
                ]),
          )),
        ),
      ),
    );
  }
}
