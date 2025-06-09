import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text('EMAIL', style: TextStyle(color: Color(0xFF4E342E))),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Color(0xFF4E342E)),
                  decoration: const InputDecoration(
                    hintText: 'name@email.com',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4E342E)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text('PASSWORD', style: TextStyle(color: Color(0xFF4E342E))),
                TextFormField(
                  controller: _passwordController,
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
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF4E342E),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const Text('CONFIRM PASSWORD', style: TextStyle(color: Color(0xFF4E342E))),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: Color(0xFF4E342E)),
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4E342E)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF4E342E),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your password';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registering...')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: const Color(0xFF4E342E),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('REGISTER'),
                  ),
                ),
                const SizedBox(height: 10),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Login',
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
                  SizedBox(height: 20,),
                 TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.g_mobiledata,
                    size: 30, color: Color(0xFF4E342E)),
                label: Text(
                  'Continue with Google',
                  style: TextStyle(color: Color(0xFF4E342E)),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  minimumSize: Size(double.infinity, 0),
                ),
              ),
               TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.email_outlined,
                    size: 20, color: Color(0xFF4E342E)),
                label: Text(
                  'Continue with Email',
                  style: TextStyle(color: Color(0xFF4E342E)),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  minimumSize: Size(double.infinity, 0),
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
