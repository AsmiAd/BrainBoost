import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color(0xFFFFF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 20),
                
               
                
                Text(
                  
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 28,
                    color:  Color(0xFF4E342E),
                  ),
                ),
                SizedBox(height: 16),
                
                Text(
                  'Enter your email address to receive a password reset link',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 40),
                
               
               Align(
                alignment: Alignment.centerLeft,
                child: Text('EMAIL', style: TextStyle(color: Color(0xFF4E342E))),
              ),
              TextField(
                style: TextStyle(color: Color(0xFF4E342E)),
                decoration: InputDecoration(
                  hintText: 'name@email.com',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),

                
                SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.grey, // Purple accent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Send Reset Link',
                      style: TextStyle(
                        fontSize: 16,
                        color:  Color(0xFF4E342E),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    'Need help? Contact Support',
                    style: TextStyle(
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}