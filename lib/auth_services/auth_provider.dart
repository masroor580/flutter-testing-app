import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? _user;
  Map<String, dynamic>? _currentUser;
  bool _isLoading = true;
  late Box authBox;

  User? get user => _user;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _initAuthProvider();
  }

  Future<void> _initAuthProvider() async {
    authBox = await Hive.openBox('authBox'); // Open Hive box first
    await _checkUserLogin();
  }

  Future<void> _checkUserLogin() async {
    try {
      _isLoading = true;
      notifyListeners();

      String? uid = authBox.get('userId');
      _user = _firebaseAuth.currentUser; // Get Firebase user

      if (_user == null && uid != null) {
        await _fetchUserData(uid);
        _user = FirebaseAuth.instance.currentUser;
      }

      if (_user != null) {
        await _fetchUserData(_user!.uid);
      } else {
        await _clearUserData();
      }
    } catch (e) {
      debugPrint("🔥 Error checking login status: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        data.forEach((key, value) {
          if (value is Timestamp) {
            data[key] = value.toDate();
          }
        });

        _currentUser = data;
        authBox.put('userData', _currentUser);
        authBox.put('userId', uid);
        notifyListeners();

        debugPrint("✅ User data loaded: $_currentUser");
      } else {
        debugPrint("⚠️ No user found in Firestore for UID: $uid");
      }
    } catch (e) {
      debugPrint("🔥 Error fetching user data: $e");
    }
  }

    /// ✅ Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      setLoading(true);

      await googleSignIn.signOut(); // Ensure fresh login
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setLoading(false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      _user = userCredential.user;

      // ✅ Store user data
      await saveUserToFirestore(_user);
      await _fetchUserData(_user!.uid);
    } catch (e) {
      debugPrint("❌ Google Sign-In Error: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> saveUserToFirestore(User? user, {String? fullName}) async {
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'fullName': fullName ?? user.displayName ?? "No Name", // ✅ Ensures full name is stored
        'email': user.email,
        'phone': user.phoneNumber ?? "",
        'photoUrl': user.photoURL ?? "",
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint("✅ New user added to Firestore: ${user.email}");
    }
  }

      Future<String?> signUp(String fullName, String email, String phone, String password) async {
    try {
      var existingUser = await _firestore.collection('users').where('email', isEqualTo: email).get();
      if (existingUser.docs.isNotEmpty) return "This email is already registered.";

      var existingPhone = await _firestore.collection('users').where('phone', isEqualTo: phone).get();
      if (existingPhone.docs.isNotEmpty) return "This phone number is already registered.";

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'uid': userCredential.user!.uid,
      });

      return null;
    } catch (e) {
      return "Signup error: $e";
    }
  }

  Future<String?> login(String identifier, String password) async {
    try {
      String? email = _isPhoneNumber(identifier) ? await _getEmailFromPhone(identifier) : identifier;
      if (email == null) return "Phone number not registered.";

      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user;
      if (_user != null) {
        authBox.put('userId', _user!.uid);
        await _fetchUserData(_user!.uid);
      }
      return null;
    } catch (e) {
      return "Invalid credentials";
    }
  }

  bool _isPhoneNumber(String input) {
    return RegExp(r'^[0-9]{4,11}$').hasMatch(input);
  }

  Future<String?> _getEmailFromPhone(String phoneNumber) async {
    try {
      QuerySnapshot query = await _firestore.collection('users')
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

    bool _isPasswordObscured = true; // Default state is obscured

  bool get isPasswordObscured => _isPasswordObscured;

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners(); // 🔥 Notify UI to rebuild
  }

    void setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners(); // 🔥 Ensure UI updates
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await googleSignIn.signOut();
    await _clearUserData();
    notifyListeners();
  }

  Future<void> _clearUserData() async {
    _user = null;
    _currentUser = null;
    await authBox.delete('userId');
    await authBox.delete('userData');
    notifyListeners();
  }

  @override
  void dispose() {
    authBox.close();
    super.dispose();
  }
}
