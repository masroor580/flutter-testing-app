// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'login_screen.dart';
//
//
//
// class AuthProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//    final _firestore = FirebaseFirestore.instance;
//   User? _user;
//   bool _isLoading = true;
//
//   User? get user => _user;
//   bool get isLoading => _isLoading;
//
//   Map<String, dynamic>? _currentUser; // Store logged-in user data
//
//   Map<String, dynamic>? get currentUser => _currentUser; // Getter to access user data
//
//
//   AuthProvider() {
//     _checkUserLogin();
//   }
//
//   Future<void> _checkUserLogin() async {
//     _user = _auth.currentUser;
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   Future<bool> autoLogin() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _user = _auth.currentUser;
//     return _user != null;
//   }
//
//   //Sign Up
//   Future<String?> signUp(String fullName, String email, String phone, String password) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       // Create user with email and password
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       String uid = userCredential.user!.uid; // Get the user ID
//       await _firestore.collection('users').doc(uid).set({
//         'fullName': fullName,
//         'email': email,
//         'phone': phone,
//         'uid': uid, // Store UID for easy reference
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       return null; // Success
//     } catch (e) {
//       return e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//
//
//   // Login
//   Future<String?> login(String emailOrPhone, String password) async {
//     try {
//       var user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailOrPhone);
//       _isLoading = true;
//       notifyListeners();
//
//       String email = emailOrPhone;
//
//       if (!emailOrPhone.contains('@')) {
//         QuerySnapshot querySnapshot = await _firestore
//             .collection('users')
//             .where('phone', isEqualTo: emailOrPhone)
//             .limit(1)
//             .get();
//
//         if (querySnapshot.docs.isEmpty) {
//           return "No user found with this phone number.";
//         }
//
//         email = querySnapshot.docs.first['email'];
//       }
//
//       if (user.isEmpty) {
//         return "user_not_found"; // This triggers the dialog box
//       }
//       else {
//         await _auth.signInWithEmailAndPassword(email: email, password: password);
//       }
//
//       return null;
//     } on FirebaseAuthException catch (e) {
//       return _handleAuthError(e);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   // Future<String?> login(String emailOrPhone, String password) async {
//   //   try {
//   //     _isLoading = true;
//   //     notifyListeners();
//   //
//   //     String email = emailOrPhone;
//   //
//   //     if (!emailOrPhone.contains('@')) {
//   //       // 🔹 Search for user by phone number
//   //       QuerySnapshot querySnapshot = await _firestore
//   //           .collection('users')
//   //           .where('phone', isEqualTo: emailOrPhone)
//   //           .limit(1)
//   //           .get();
//   //
//   //       if (querySnapshot.docs.isEmpty) {
//   //         return "No user found with this phone number.";
//   //       }
//   //
//   //       email = querySnapshot.docs.first['email'];
//   //     }
//   //
//   //     // 🔹 Authenticate user
//   //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //
//   //     // 🔹 Fetch user data from Firestore
//   //     DocumentSnapshot userSnapshot = await _firestore
//   //         .collection('users')
//   //         .doc(userCredential.user!.uid)
//   //         .get();
//   //
//   //     if (userSnapshot.exists) {
//   //       _currentUser = userSnapshot.data() as Map<String, dynamic>; // ✅ Store user data
//   //     }
//   //
//   //     notifyListeners(); // Update UI
//   //     return null; // ✅ Login successful
//   //   } on FirebaseAuthException catch (e) {
//   //     return "Authentication failed. Try again.";
//   //   } finally {
//   //     _isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }
//
//
//
//
//
//
//
//
//
//
//   // Logout
//   Future<void> logout(BuildContext context) async {
//     await _auth.signOut();
//     _user = null;
//     notifyListeners();
//
//     if (context.mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   }
//
//   void printFirebaseUsers() async {
//     try {
//       List<UserInfo> usersList = FirebaseAuth.instance.currentUser?.providerData ?? [];
//
//       if (usersList.isEmpty) {
//         print("❌ No users found in Firebase Authentication.");
//       } else {
//         print("✅ Registered Users in Firebase Authentication:");
//         for (var user in usersList) {
//           print("📧 Email: ${user.email}");
//           print("📞 Phone: ${user.phoneNumber}");
//         }
//       }
//     } catch (e) {
//       print("❌ Error fetching users: $e");
//     }
//   }
//
//
//   String _handleAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return "This email is already registered.";
//       case 'wrong-password':
//         return "Incorrect password.";
//       case 'user-not-found':
//         return "No user found with this email.";
//       case 'invalid-email':
//         return "Invalid email format.";
//       default:
//         return "Authentication error: ${e.message}";
//     }
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'user_model.dart';
// import 'login_screen.dart';
// import 'package:new_app/auth_provider.dart';
//
// class AuthProvider with ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _user;
//   bool _isLoading = false;
//   Map<String, dynamic>? _currentUser; // Store logged-in user data
//
//   User? get user => _user;
//   bool get isLoading => _isLoading;
//   Map<String, dynamic>? get currentUser => _currentUser;
//
//
//   AuthProvider() {
//     _checkUserLogin();
//   }
//
//   /// ✅ Check if user is already logged in
//   // Future<void> _checkUserLogin() async {
//   //   var box = Hive.box('authBox');
//   //   String? uid = box.get('userId');
//   //
//   //   if (uid != null) {
//   //     _user = _auth.currentUser;
//   //     await _fetchUserData(uid);
//   //   }
//   //   notifyListeners();
//   // }
//
//   Future<void> _checkUserLogin() async {
//     try {
//       // Ensure Hive box is open
//       var box = await Hive.openBox('authBox');
//       String? uid = box.get('userId');
//
//       if (uid != null) {
//         // Refresh Firebase authentication user
//         _user = _auth.currentUser ?? await _auth.authStateChanges().first;
//
//         if (_user != null) {
//           await _fetchUserData(uid); // Fetch user data from Firestore
//         }
//       }
//     } catch (e) {
//       print("Error checking user login: $e");
//     } finally {
//       notifyListeners(); // Notify only once at the end
//     }
//   }
//
//
//
//   /// ✅ Automatically logs in the user if session exists
//   Future<bool> autoLogin() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _user = _auth.currentUser;
//     return _user != null;
//   }
//
//
//   /// ✅ Sign Up a new user
//   // Future<String?> signUp(String fullName, String email, String phone, String password) async {
//   //   try {
//   //     _isLoading = true;
//   //     notifyListeners();
//   //
//   //     UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //
//   //     String uid = userCredential.user!.uid;
//   //     await _firestore.collection('users').doc(uid).set({
//   //       'fullName': fullName,
//   //       'email': email,
//   //       'phone': phone,
//   //       'uid': uid,
//   //       'createdAt': FieldValue.serverTimestamp(),
//   //     });
//   //
//   //     _user = userCredential.user;
//   //     _currentUser = {'fullName': fullName, 'email': email, 'phone': phone, 'uid': uid};
//   //     notifyListeners();
//   //     return null;
//   //   } catch (e) {
//   //     return e.toString();
//   //   } finally {
//   //     _isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }
//
//   Future<String?> signUp(String fullName, String email, String phone, String password) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       // Create user with email/password
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       String uid = userCredential.user!.uid;
//
//       // Store user details in Firestore, including phone number
//       await _firestore.collection('users').doc(uid).set({
//         'fullName': fullName,
//         'email': email,
//         'phone': phone, // Store phone number
//         'uid': uid,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       _user = userCredential.user;
//       _currentUser = {'fullName': fullName, 'email': email, 'phone': phone, 'uid': uid};
//
//       notifyListeners();
//       return null;
//     } catch (e) {
//       return e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//   Future<String?> login(String input, String password) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       String email = input;
//
//       // If the input is a phone number, fetch the associated email from Firestore
//       if (!input.contains("@")) {
//         var querySnapshot = await _firestore
//             .collection('users')
//             .where('phone', isEqualTo: input)
//             .limit(1)
//             .get();
//
//         if (querySnapshot.docs.isEmpty) {
//           return "Phone number not found. Please sign up first.";
//         }
//
//         email = querySnapshot.docs.first.get('email');
//       }
//
//       // Login with email
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Fetch user data from Firestore
//       String uid = userCredential.user!.uid;
//       DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
//
//       if (userDoc.exists) {
//         _currentUser = userDoc.data() as Map<String, dynamic>;
//       } else {
//         return "User data not found!";
//       }
//
//       _user = userCredential.user;
//       notifyListeners();
//       return null;
//     } catch (e) {
//       return e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//
//
//
//
//   // ✅ Login with email or phone
//   // Future<String?> login(String emailOrPhone, String password) async {
//   //   try {
//   //     _isLoading = true;
//   //     notifyListeners();
//   //
//   //     String email = emailOrPhone;
//   //
//   //     if (!emailOrPhone.contains('@')) {
//   //       QuerySnapshot querySnapshot = await _firestore
//   //           .collection('users')
//   //           .where('phone', isEqualTo: emailOrPhone)
//   //           .limit(1)
//   //           .get();
//   //
//   //       if (querySnapshot.docs.isEmpty) {
//   //         return "No user found with this phone number.";
//   //       }
//   //
//   //       email = querySnapshot.docs.first['email'];
//   //     }
//   //
//   //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //
//   //     _user = userCredential.user;
//   //     await _fetchUserData(_user!.uid); // Load user data after login
//   //
//   //     notifyListeners();
//   //     return null;
//   //   } catch (e) {
//   //     return "Authentication failed. Try again.";
//   //   } finally {
//   //     _isLoading = false;
//   //     notifyListeners();
//   //   }
//   // }
//
//
//
//   /// ✅ Fetch user data from Firestore
//   Future<void> _fetchUserData(String uid) async {
//     DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
//
//     if (userSnapshot.exists) {
//       _currentUser = userSnapshot.data() as Map<String, dynamic>;
//     } else {
//       _currentUser = null;
//     }
//     notifyListeners();
//   }
//
//   Future<void> logout() async {
//     await _auth.signOut();
//
//     var box = Hive.box('authBox');
//     await box.clear(); // Clear stored user data
//
//     _user = null;
//     _currentUser = null;
//
//     notifyListeners();
//   }
//
//
//
// /// ✅ Logout
//   // Future <void> logout(BuildContext context) async {
//   //   print('Logging out');
//   //   await FirebaseAuth.instance.signOut();  // Logs the user out from Firebase
//   //   print("user Signed out");
//   //   Navigator.pushReplacement(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => LoginScreen()),  // Redirects to login screen
//   //   );
//   // }
// }

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  Map<String, dynamic>? _currentUser;
  bool _isLoading = true;

  User? get firebaseUser => _user;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  User? _googleUser;

  User? get googleUser => _googleUser;

  void updateUser(User? user) {
    _currentUser = user as Map<String, dynamic>?;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // Google sign-in code...
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    updateUser(userCredential.user);
  }


  AuthProvider() {
    _checkUserLogin();
  }

  /// ✅ Check if the user is logged in on app startup
  Future<void> _checkUserLogin() async {
    try {
      var box = await Hive.openBox('authBox');
      String? uid = box.get('userId');
      if (uid != null) {
        _user = _firebaseAuth.currentUser;
        if (_user != null) {
          await _fetchUserData(uid);
        }
      }
    } catch (e) {
      debugPrint("Error checking login status: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Fetch user data from Firestore
  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = doc.data() as Map<String, dynamic>;
        var box = await Hive.openBox('authBox');
        box.put('userData', _currentUser);
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    } finally {
      notifyListeners();
    }
  }

  /// ✅ Signup function (Creates user & saves phone in Firestore)
  Future<String?> signUp(String fullName, String email, String phone, String password) async {
    try {
      // 🔍 Check if email or phone already exists in Firestore
      var existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUser.docs.isNotEmpty) {
        return "This email is already registered. Please log in.";
      }

      var existingPhone = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (existingPhone.docs.isNotEmpty) {
        return "This phone number is already registered. Please log in.";
      }

      // ✅ Create Firebase Auth user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 🔄 Store user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'uid': userCredential.user!.uid,
      });

      return null; // ✅ Success, no error message
    } catch (e) {
      return e.toString(); // Return error message
    }
  }


  /// ✅ Login with Email/Password OR Phone/Password
  Future<String?> login(String identifier, String password) async {
    try {
      if (_isPhoneNumber(identifier)) {
        String? email = await _getEmailFromPhone(identifier);
        if (email == null) return "Phone number not registered.";
        return await _loginWithEmail(email, password);
      } else {
        return await _loginWithEmail(identifier, password);
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  /// ✅ Check if input is a phone number
  bool _isPhoneNumber(String input) {
    final phoneRegex = RegExp(r'^[0-9]{4,11}$');
    return phoneRegex.hasMatch(input);
  }

  /// ✅ Get email from phone number
  Future<String?> _getEmailFromPhone(String phoneNumber) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        return query.docs.first['email'];
      }
    } catch (e) {
      debugPrint("Error getting email from phone: $e");
    }
    return null;
  }

  /// ✅ Login with email and password
  Future<String?> _loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      if (_user != null) {
        String uid = _user!.uid;
        var box = await Hive.openBox('authBox');
        box.put('userId', uid);
        await _fetchUserData(uid);
      }
      return null;
    } catch (e) {
      return "Login failed. Please check your credentials.";
    }
  }

  /// ✅ Logout function
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    _user = null;
    _currentUser = null;
    var box = await Hive.openBox('authBox');
    box.delete('userId');
    box.delete('userData');
    notifyListeners();
  }
}