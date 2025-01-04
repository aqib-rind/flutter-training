import 'package:profondo/utils/database.dart';
import 'package:profondo/utils/global_state.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaperViewPage extends StatefulWidget {
  const PaperViewPage({super.key});
  @override
  PaperViewPageState createState() => PaperViewPageState();
}

class PaperViewPageState extends State<PaperViewPage> {
  bool isLoading = false;
  String? title = '';
  String? desc = '';
  String? docPath = '';

  Future<void> _launchURL() async {
    if (docPath != null && docPath!.isNotEmpty) {
      final Uri url = Uri.parse(docPath!);
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // This will open in Chrome
      )) {
        throw Exception('Could not launch $url');
      }
    }
  }

  void getPaperInfo() async {
    setState(() {
      isLoading = true;
    });
    final globalState = Provider.of<GlobalState>(context, listen: false);
    String docId = globalState.docId;
    log(docId);

    if (docId.isNotEmpty) {
      final paperDetails = await DatabaseMethods().fetchPaperData(docId);
      if (paperDetails != null) {
        setState(() {
          title = paperDetails['title'];
          desc = paperDetails['description'];
          docPath = paperDetails['pdfPath'];
        });
        // Automatically launch the URL when data is loaded
        _launchURL();
      } else {
        log('Paper details are null or title is missing');
        title = 'Unknown Title';
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPaperInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paper Details"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null && title!.isNotEmpty) Text(title!),
                  if (desc != null && desc!.isNotEmpty) Text(desc!),
                  ElevatedButton(
                    onPressed: _launchURL,
                    child: const Text('Open PDF in Browser'),
                  ),
                ],
              ),
            ),
    );
  }
}
