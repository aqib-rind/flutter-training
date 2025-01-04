// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profondo/utils/database.dart';
import 'package:profondo/utils/routes.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String dropDownValue = "Select Dept.";
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 600,
        imageQuality: 85,
      );
      setState(() {
        _selectedImage = pickedFile;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a photo"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty.";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty.";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters.";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return "Passwords do not match.";
    }
    return null;
  }

  Future<Map<String, String>?> _uploadImage() async {
    try {
      // Upload URL
      String uploadUrl =
          'https://lightblue-pheasant-606554.hostingersite.com/upload.php';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath(
        'file', // Matches the PHP $_FILES['file']
        _selectedImage!.path,
      ));

      // Add additional fields if necessary      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        if (jsonResponse['success'] == true) {
          if (jsonResponse.containsKey('filePath') &&
              jsonResponse.containsKey('fileUrl')) {
            String filePath = jsonResponse['filePath'];
            String fileUrl = jsonResponse['fileUrl'];

            return {
              'filePath': filePath,
              'fileUrl': fileUrl,
            };
          } else {
            throw Exception("Server response is missing filePath or fileUrl.");
          }
        } else {
          String errorMessage =
              jsonResponse['message'] ?? "Unknown error during upload.";
          Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.error,
            textColor: Colors.white,
          );
          return null;
        }
      } else {
        log('Server error: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'Server error: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      log("Exception during image upload: $e");
      Fluttertoast.showToast(
        msg: "Image upload failed: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Colors.white,
      );
      return null;
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Ensure that an image is selected
      if (_selectedImage == null) {
        Fluttertoast.showToast(
          msg: "Please select an image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
        );
        return;
      }

      // Convert image to base64 (if an image is selected)
      var result = await _uploadImage();

      // Create user with email and password (Firebase Authentication)
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _confirmPasswordController.text);

        // Retrieve the UID of the created user
        String uid = userCredential.user!.uid;

        // Now, store additional user data in Firestore
        Map<String, dynamic> userInfoMap = {
          "Uid": uid,
          "FirstName": _firstNameController.text,
          "LastName": _lastNameController.text,
          "Email": _emailController.text,
          "Department": dropDownValue,
          'imagePath': result?['fileUrl'],
        };

        // Add user data to Firestore with UID as the document ID
        await DatabaseMethods().addUserDetails(userInfoMap, uid).then((value) {
          Fluttertoast.showToast(
            msg: "User Registered Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            textColor: Theme.of(context).colorScheme.onSecondary,
            fontSize: 16.0,
          );
        });

        // Navigate to Home screen and remove Register screen from the stack
        Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
        setState(() {
          _isLoading = false;
        });
        // Log registration data for debugging
      } catch (e) {
        // Handle registration errors (e.g. user already exists, weak password)
        Fluttertoast.showToast(
          msg: "Registration Failed: ${e.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        debugPrint("Error during registration: $e");
        _isLoading = false;
      }
    }
  }

  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _deptController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _showImageSourceDialog,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: _selectedImage != null
                                ? FileImage(File(_selectedImage!.path))
                                : null,
                            child: _selectedImage == null
                                ? const Icon(Icons.add_a_photo, size: 40)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text("First Name"),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          hintText: "Enter your first name",
                        ),
                        validator: (value) =>
                            _validateField(value, "First Name"),
                      ),
                      const SizedBox(height: 10),
                      const Text("Last Name"),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          hintText: "Enter your last name",
                        ),
                        validator: (value) =>
                            _validateField(value, "Last Name"),
                      ),
                      const SizedBox(height: 10),
                      const Text("Email"),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: "Enter Email",
                          labelText: "Email",
                        ),
                        validator: (value) => _validateField(value, "Email"),
                      ),
                      const SizedBox(height: 10),
                      const Text("Department"),
                      DropdownButtonFormField<String>(
                        value: dropDownValue,
                        onChanged: (String? value) {
                          setState(() {
                            dropDownValue = value!;
                          });
                        },
                        decoration: const InputDecoration(),
                        items: <String>["Select Dept.", "SE", "CS", "AI"]
                            .map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: 10),
                      const Text("Password"),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          border: const OutlineInputBorder(),
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
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 10),
                      const Text("Confirm Password"),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_confirmPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Confirm your password",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _register,
                          child: const Text("Register"),
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
