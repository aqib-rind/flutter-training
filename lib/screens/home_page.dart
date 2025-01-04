import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:profondo/utils/database.dart';
import 'package:profondo/utils/global_state.dart';
import 'package:profondo/utils/routes.dart';
import 'package:profondo/widgets/book_card.dart';
import 'package:profondo/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? _paperStream;
  bool _isLoading = true; // Loader state

  void getUserInfo(BuildContext context, String uid) async {
    // ignore: no_leading_underscores_for_local_identifiers
    String _uid = uid; // Replace with actual user UID
    final userData = await DatabaseMethods().fetchUserData(uid);
    if (userData != null) {
      // Update GlobalState with fetched user details
      // ignore: use_build_context_synchronously
      final globalState = Provider.of<GlobalState>(context, listen: false);
      globalState.userId = _uid;
      globalState.firstName =
          userData['FirstName'] ?? ''; // Default value if null
      globalState.lastName =
          userData['LastName'] ?? ''; // Default value if null
      globalState.email = userData['Email'] ?? ''; // Default value if null
      globalState.dept = userData['Department'] ?? ''; // Default value if null
      globalState.imagePath =
          userData['imagePath'] ?? ''; // Default value if null
    }
  }

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
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        getUserInfo(context, user.uid);
      }
    } catch (e) {
      log('Error fetching user: $e');
    }
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
            return GestureDetector(
                onTap: () async {
                  final globalState =
                      Provider.of<GlobalState>(context, listen: false);
                  globalState.docId = ds['id'] ?? '';
                  await Navigator.pushNamed(context, MyRoutes.paperViewRoute);
                },
                child: BookCard(bookName: ds['title']));
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
          title: const Text('Profondo Library'),
        ),
        body: allPapersDetails(),
        drawer: const MyDrawer(),
      ),
    );
  }
}
