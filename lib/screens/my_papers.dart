import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profondo/utils/database.dart';
import 'package:profondo/widgets/book_card.dart';
import 'package:profondo/widgets/my_drawer.dart';

class MyPapersPage extends StatefulWidget {
  const MyPapersPage({super.key});

  @override
  State<MyPapersPage> createState() => _MyPapersPageState();
}

class _MyPapersPageState extends State<MyPapersPage> {
  Stream? _paperStream;
  bool _isLoading = true; // Loader state

  getdataLoaded() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _paperStream = await DatabaseMethods().getResearchPapersDetails();
    } catch (e) {
      log("Error loading papers: $e");
    } finally {
      setState(() {
        _isLoading = false; // Stop loading once the stream is initialized
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdataLoaded();
  }

  Widget allPapersDetails() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return StreamBuilder(
      stream: _paperStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading state
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text('No Papers Available'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7,
          ),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            // log(ds.data().toString()); // Debugging
            return BookCard(bookName: ds['title']);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
        ),
        body: allPapersDetails(),
        drawer: const MyDrawer(),
      ),
    );
  }
}
