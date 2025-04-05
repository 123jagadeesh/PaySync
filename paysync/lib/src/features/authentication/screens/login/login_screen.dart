import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paysync/src/constants/colors.dart';
import 'package:paysync/src/constants/sizes.dart';
import 'package:paysync/src/constants/text_strings.dart';
import 'package:paysync/src/features/authentication/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Remove the duplicate _handleLogin at the bottom of the file and keep this one at the top
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      _authController.loginWithEmail(email, password).then((_) {
        // Navigate to dashboard after successful login
        Get.offAllNamed('/dashboard');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                ),
                
                // Section 1 - Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back,",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "Make it work, make it right, make it fast.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                
                // Section 2 - Form
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: "Email",
                            hintText: "Email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.fingerprint),
                            labelText: "Password",
                            hintText: "Password",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ElevatedButton(
                            onPressed: _authController.isLoading.value ? null : _handleLogin,
                            child: _authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : Text("LOGIN".toUpperCase()),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Section 3 - Footer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("OR"),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.web),
                        onPressed: () {},
                        label: const Text("Sign In with Google"),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () => Get.toNamed('/signup'),
                      child: Text.rich(
                        TextSpan(
                          text: "Don't have an Account? ",
                          children: [
                            TextSpan(
                              text: "Signup",
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}