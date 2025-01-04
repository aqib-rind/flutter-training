import 'package:flutter/material.dart';

class GlobalState with ChangeNotifier {
  // Properties to manage globally
  String _userId = '';
  String _firstName = '';
  String _lastName = '';
  String _dept = '';
  String _email = '';
  String _imagePath = '';
  String _docId = '';

  // Getter for userId
  String get userId => _userId;

  // Setter for userId
  set userId(String id) {
    _userId = id;
    notifyListeners(); // Notify listeners when state changes
  }

  String get docId => _docId;

  // Setter for docId
  set docId(String id) {
    _docId = id;
    notifyListeners(); // Notify listeners when state changes
  }

  // Getter for firstName
  String get firstName => _firstName;

  // Setter for firstName
  set firstName(String name) {
    _firstName = name;
    notifyListeners(); // Notify listeners when state changes
  }

  String get lastName => _lastName;

  // Setter for lastName
  set lastName(String name) {
    _lastName = name;
    notifyListeners(); // Notify listeners when state changes
  }

  // Getter for dept
  String get dept => _dept;

  // Setter for dept
  set dept(String department) {
    _dept = department;
    notifyListeners(); // Notify listeners when state changes
  }

  // Getter for email
  String get email => _email;

  // Setter for email
  set email(String emailAddress) {
    _email = emailAddress;
    notifyListeners(); // Notify listeners when state changes
  }

  // Getter for imagePath
  String get imagePath => _imagePath;

  // Setter for imagePath
  set imagePath(String path) {
    _imagePath = path;
    notifyListeners(); // Notify listeners when state changes
  }

  // Method to clear all user data
  void clearUserData() {
    _userId = '';
    _firstName = '';
    _dept = '';
    _email = '';
    _imagePath = '';
    notifyListeners();
  }
}
