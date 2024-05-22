import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void logIn() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  void signUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Positioned(
            left: 116.50,
            top: 131.37,
            child: Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Positioned(
            left: 0,
            top: 180.25,
            child: SizedBox(
              width: 390,
              height: 26.25,
              child: Text(
                'Log in or create a new account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40), // Provides spacing between the buttons
          Positioned(
            left: 34.68,
            top: 281.22,
            child: Container(
              width: 320.64,
              height: 248.93,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                // Optionally, you can set a border, borderRadius, etc.
              ),
              child: Stack(
                children: [
                  // Image widget goes here
                  Image.asset(
                    'assets/images/welcome.png',
                    fit: BoxFit.cover,
                  ),
                  // You can add more widgets over the image here
                ],
              ),
            ),
          ),
          const SizedBox(height: 40), // Provides spacing between the buttons
          // Sign Up Button
          Container(
            width: double.infinity, // Ensures the Container takes up all horizontal space
            padding: const EdgeInsets.symmetric(horizontal: 36.5),
            child: ElevatedButton(
              onPressed: logIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0CCDAA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Provides spacing between the buttons
          Container(
            width: double.infinity, // Ensures the Container takes up all horizontal space
            padding: const EdgeInsets.symmetric(horizontal: 36.5),
            child: ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(width: 1, color: Color(0xFF7C7C7C)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Color(0xFF0CCDAA),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
