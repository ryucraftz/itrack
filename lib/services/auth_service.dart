import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<User?> createUserWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      // You may want to update user's display name here
      await user?.updateDisplayName(name);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the currently signed-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Listen to the authentication state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Add a class to the database
  Future<void> addClass(String dateForDB, Map<String, dynamic> classData) async {
    try {
      await _database.child('class/timetable/$dateForDB').set(classData);
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add class to the database');
    }
  }
  
}
