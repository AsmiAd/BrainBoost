import 'package:brain_boost/screens/auth/forgot_password_screen.dart';
import 'package:brain_boost/screens/auth/register_screen.dart';
import 'package:brain_boost/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 30),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            Center(
              child: Container(
                width:300,
                height: 300,
                
                child: Image.asset("images/kinmel.png",
                ),
              ),
            ),

           

              const Text('EMAIL', style: TextStyle(color: Color(0xFF4E342E))),
              const TextField(
                style: TextStyle(color: Color(0xFF4E342E)),
                decoration: InputDecoration(
                  hintText: 'name@email.com',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4E342E)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

      const Text('PASSWORD', style: TextStyle(color: Color(0xFF4E342E))),
      TextField(
        obscureText: _obscurePassword,
        style: const TextStyle(color: Color(0xFF4E342E)),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4E342E)),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              size: 20,
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF4E342E),
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF4E342E),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                   Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      
                  },
                  child: const Text('LOGIN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: const Color(0xFF4E342E),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                            color: Color(0xFF4E342E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      "images/gg.jpg", 
                      width: 24, 
                      height: 24, 
                    ),
                    label: const Center(
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(color: Color(0xFF4E342E)),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      minimumSize: const Size(double.infinity, 0),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 8),
              
                  TextButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      "images/el.png", 
                      width: 24,
                      height: 24,
                    ),
                    label: const Text(
                      'Continue with Email',
                      style: TextStyle(color: Color(0xFF4E342E)),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      minimumSize: const Size(double.infinity, 0),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 8),
              
                 
                ],
              )
             
            ]
          ),
        )
      ));
        
    
    
  }
}
