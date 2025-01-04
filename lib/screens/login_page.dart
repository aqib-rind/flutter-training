// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:profondo/utils/auth.dart';
import 'package:profondo/utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  final _auth = AuthService();
  bool _userFound = true;
  String _errorMessage = ""; // Added for showing the error message
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  Future<void> moveToHome(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      final user = await _auth.loginUserWithEmailAndPassword(
        _usernameController.text,
        _passwordController.text,
      );

      if (user != null) {
        // Navigate to the home route if login succeeds
        await Navigator.pushNamed(context, MyRoutes.homeRoute);
        setState(() {
          _userFound = true;
          _errorMessage = ""; // Clear error message
          _isLoading = false;
        });
      } else {
        setState(() {
          _userFound = false;
          _isLoading = false;
          _errorMessage =
              "Invalid email or password. Please try again."; // Set error message
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 70.0,
                    ),
                    SizedBox(
                      height: 300.0,
                      width: 300.0,
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Text(
                      "Welcome to Profondo",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: "Enter Email",
                              labelText: "Email",
                            ),
                            onChanged: (value) {
                              name = value;
                              setState(() {});
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "Email cannot be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password cannot be empty";
                              } else if (value.length < 6) {
                                return "Password length should be at least 6";
                              }
                              return null;
                            },
                          ),
                          if (!_userFound) // Show the error message if login fails
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .error, // Dynamically fetch the error color
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading ? null : () => moveToHome(context),
                              child: _isLoading
                                  ? const CircularProgressIndicator() // Show loader when uploading
                                  : const Text("Login"),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account! "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, MyRoutes.registerRoute);
                                  },
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ])
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
