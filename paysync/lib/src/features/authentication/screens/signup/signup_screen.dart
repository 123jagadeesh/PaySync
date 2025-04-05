import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:paysync/src/constants/colors.dart';
import 'package:paysync/src/constants/sizes.dart';
// import 'package:paysync/src/constants/text_strings.dart';
import 'package:paysync/src/features/authentication/controllers/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.put(AuthController());
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
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
                      "Get On Board!",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "Create your profile to start your Journey.",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),

                // Section 2 - Form
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  // Update the Form widget
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                          decoration: const InputDecoration(
                            label: Text("Full Name"),
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Fix the form fields
                        TextFormField(
                          controller: _emailController,
                          validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                          decoration: const InputDecoration(
                            label: Text("Email"),
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneController,
                          validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                          decoration: const InputDecoration(
                            label: Text("Phone No"),
                            prefixIcon: Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Update the password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your password';
                            if (value.length < 6) return 'Password must be at least 6 characters';
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            prefixIcon: const Icon(Icons.fingerprint),
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
                        
                        const SizedBox(height: 20),
                        
                        // Update signup button and footer section
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: Obx(() => ElevatedButton(
                            onPressed: _authController.isLoading.value
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _authController.signUpWithEmail(
                                        _emailController.text.trim(),
                                        _passwordController.text,
                                        _nameController.text.trim(),
                                      );
                                    }
                                  },
                            child: _authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : Text("SIGNUP".toUpperCase()),
                          )),
                        ),
                        
                        const SizedBox(height: 20),
                        const Text("OR"),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.web),
                            onPressed: () {
                              Get.snackbar(
                                'Coming Soon', 
                                'Google Sign-in will be available soon!',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            label: const Text("Sign Up with Google"),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => Get.toNamed('/login'),
                          child: Text.rich(
                            TextSpan(
                              text: "Already have an Account? ",
                              children: const [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Remove the entire Section 3 - Footer
              ],
            ),
          ),
        ),
      ),
    );
  }
}