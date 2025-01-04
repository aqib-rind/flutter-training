import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .set(userInfoMap);
  }

  Future uploadResearchPaper(
      Map<String, dynamic> researchPaperDataMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("ResearchPapers")
        .doc(id)
        .set(researchPaperDataMap);
  }

  Future<Stream<QuerySnapshot>> getUserDetails(String uid) async {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getPaperDetails(String id) async {
    return FirebaseFirestore.instance
        .collection('ResearchPapers')
        .where('id', isEqualTo: id)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllPapers() async {
    return FirebaseFirestore.instance.collection('ResearchPapers').snapshots();
  }

  Future<Stream<QuerySnapshot>> getResearchPapersDetails() async {
    return FirebaseFirestore.instance.collection('ResearchPapers').snapshots();
  }

// If you want to stream the user data (real-time updates)
  Future<Map<String, dynamic>?> fetchPaperData(String uid) async {
    try {
      // Get reference to Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get document reference for specific research paper
      DocumentSnapshot paperDoc =
          await firestore.collection('ResearchPapers').doc(uid).get();

      if (paperDoc.exists) {
        return paperDoc.data() as Map<String, dynamic>;
      } else {
        log('No research paper found with this ID');
        return null;
      }
    } catch (e) {
      log('Error fetching research paper data: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      // Get reference to Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get document reference for specific user
      DocumentSnapshot userDoc =
          await firestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        log('No user found with this UID');
        return null;
      }
    } catch (e) {
      log('Error fetching user data: $e');
      return null;
    }
  }

// If you want to stream the user data (real-time updates)
  Stream<DocumentSnapshot> streamUserData(String uid) {
    return FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
  }
}
