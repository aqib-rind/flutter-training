// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:profondo/utils/colors.dart'; // Ensure your color utility is included
import 'package:profondo/utils/database.dart';
import 'package:profondo/utils/global_state.dart';
import 'package:profondo/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart'; // For saving the uploaded paper details
import 'package:http/http.dart' as http;

class UploadResearchPaperPage extends StatefulWidget {
  const UploadResearchPaperPage({ super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadResearchPaperPageState createState() =>
      _UploadResearchPaperPageState();
}

class _UploadResearchPaperPageState extends State<UploadResearchPaperPage> {
  File? _selectedPdf;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isUploading = false;

  // Function to pick the thumbnail image using Image Picker

  // Function to pick the PDF file using File Picker
  Future<void> _pickPdf() async {
    try {
      // Use FilePicker to select a PDF
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        // If a file is selected, store the file path
        setState(() {
          _selectedPdf = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
        Fluttertoast.showToast(msg: "No file selected");
      }
    } catch (e) {
      // Handle any errors that might occur
      Fluttertoast.showToast(msg: "Error picking file: $e");
    }
  }

  // Function to validate fields
  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName cannot be empty.";
    }
    return null;
  }

  // Function to upload the paper (this function can be adapted for saving data to a database or Firebase)
  Future<Map<String, String>?> _uploadPdf() async {
    try {
      // Upload URL
      String uploadUrl =
          'https://lightblue-pheasant-606554.hostingersite.com/upload.php';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Attach the image file

      // Attach the PDF file
      if (_selectedPdf != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file', // Matches the PHP $_FILES['file']
          _selectedPdf!.path,
        ));
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        if (jsonResponse['success'] == true) {
          String filePath = jsonResponse['filePath'];
          String fileUrl = jsonResponse['fileUrl'];

          log('fileUrl: $fileUrl');
          log("filePath: $filePath");

          return {
            'filePath': filePath,
            'fileUrl': fileUrl,
          };
        } else {
          log(jsonResponse['message']);
          Fluttertoast.showToast(
            msg: jsonResponse['message'] ?? "Upload failed",
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
      log(e.toString());
      Fluttertoast.showToast(
        msg: "Upload Failed: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Colors.white,
      );
      return null;
    }
  }

  Future<void> _uploadResearchPaper() async {
    final globalState = Provider.of<GlobalState>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      if (_selectedPdf == null) {
        Fluttertoast.showToast(
          msg: "Please select a PDF file.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      try {
        // Upload the image

        // Upload the PDF
        var pdfResult = await _uploadPdf();
        if (pdfResult == null) {
          throw Exception("PDF upload failed.");
        }

        log("PDF uploaded successfully: ${pdfResult['fileUrl']}");

        // ignore: non_constant_identifier_names
        String Id = randomAlphaNumeric(10);
        Map<String, dynamic> researchPaperDataMap = {
          'id': Id,
          "Uid": globalState.userId,
          "title": _titleController.text,
          'description': _descriptionController.text,
          "pdfPath": pdfResult['fileUrl'],
        };

        await DatabaseMethods()
            .uploadResearchPaper(researchPaperDataMap, Id)
            .then((value) {
          // Display a success message and navigate to the home page
          Fluttertoast.showToast(
            msg: "Research paper uploaded successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Colors.white,
          );
        });

        await Navigator.pushReplacementNamed(context, '/home');
        setState(() {
          _isUploading = false;
        });
      } catch (e) {
        log("Error during upload: $e");
        Fluttertoast.showToast(
          msg: "Upload failed: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Research Paper"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail Section

                const Text(
                  "Title",
                  style: TextStyle(color: AppColors.lightPrimaryText),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Enter the title of your research paper",
                  ),
                  validator: (value) => _validateField(value, "Title"),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Description",
                  style: TextStyle(color: AppColors.lightPrimaryText),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText:
                        "Enter a brief description of your research paper",
                  ),
                  validator: (value) => _validateField(value, "Description"),
                ),
                const SizedBox(height: 20),
                // PDF Upload Section
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pickPdf,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16), // Adjust padding for button
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary, // Set the background color
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedPdf != null
                                    ? "PDF: ${_selectedPdf!.path.split('/').last}"
                                    : "No PDF selected",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                // This can remain const since it doesn't depend on context
                                Icons.attach_file,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadResearchPaper,
                    child: _isUploading
                        ? const CircularProgressIndicator() // Show loader when uploading
                        : const Text("Upload"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}
