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

  bool _isLoggingOut = false;
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  User? get user => _user;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggingOut => _isLoggingOut;
  bool get isPasswordObscured => _isPasswordObscured;
  bool get isConfirmPasswordObscured => _isConfirmPasswordObscured;

  AuthProvider() {
    _initAuthProvider();
  }

  Future<void> _initAuthProvider() async {
    authBox = await Hive.openBox('authBox');
    await _checkUserLogin();
  }

  Future<void> _checkUserLogin() async {
    setLoading(true);
    try {
      String? uid = authBox.get('userId');
      _user = _firebaseAuth.currentUser;

      if (_user == null && uid != null) {
        await _fetchUserData(uid);
      } else if (_user != null) {
        await _fetchUserData(_user!.uid);
      } else {
        await _clearUserData();
      }
    } catch (e) {
      debugPrint("🔥 Error checking login status: $e");
    }
    setLoading(false);
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // ✅ Prevent redundant UI rebuilds
        if (_currentUser == null || _currentUser != data) {
          _currentUser = data;
          authBox.put('userData', _currentUser);
          authBox.put('userId', uid);
          notifyListeners();
        }
      } else {
        debugPrint("⚠️ No user found in Firestore for UID: $uid");
      }
    } catch (e) {
      debugPrint("🔥 Error fetching user data: $e");
    }
  }

  Future<String?> biometricLogin() async {
    try {
      // 🔥 Fetch the last logged-in user (you might need to store this in Hive or SharedPreferences)
      String? savedEmail = await getSavedUserEmail(); // Implement this function
      String? savedPassword = await getSavedUserPassword(); // Implement this function

      if (savedEmail == null || savedPassword == null) {
        return "No saved login credentials found.";
      }

      // 🔥 Attempt to log in using stored credentials
      return await login(savedEmail, savedPassword);
    } catch (e) {
      return "Biometric login failed.";
    }
  }

  Future<void> signInWithGoogle() async {
    setLoading(true);
    try {
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

      await saveUserToFirestore(_user);
      await _fetchUserData(_user!.uid);
    } catch (e) {
      debugPrint("❌ Google Sign-In Error: $e");
    }
    setLoading(false);
  }

    Future<void> saveUserToFirestore(User? user, {String? fullName}) async {
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'fullName': fullName ?? user.displayName ?? "No Name",
        'email': user.email,
        'phone': user.phoneNumber ?? "",
        'photoUrl': user.photoURL ?? "",
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint("✅ New user added to Firestore: ${user.email}");
    }
  }

  Future<String?> signUp(String fullName, String email, String phone, String password) async {
    try {
      var existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('phone', isEqualTo: phone)
          .get();

      if (existingUser.docs.isNotEmpty) return "Email or phone already registered.";

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

  Future<void> saveUserCredentials(String email, String password) async {
    final box = await Hive.openBox('authBox');
    await box.put('savedEmail', email);
    await box.put('savedPassword', password);
  }

  Future<String?> getSavedUserEmail() async {
    final box = await Hive.openBox('authBox');
    return box.get('savedEmail');
  }

  Future<String?> getSavedUserPassword() async {
    final box = await Hive.openBox('authBox');
    return box.get('savedPassword');
  }


  Future<String?> login(String identifier, String password) async {
    setLoading(true);
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

      await saveUserCredentials(email, password);
      return null;
    } catch (e) {
      return "Invalid credentials";
    } finally {
      setLoading(false);
    }
  }


  bool _isPhoneNumber(String input) {
    return RegExp(r'^[0-9]{4,11}$').hasMatch(input);
  }

  Future<String?> _getEmailFromPhone(String phoneNumber) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();
      return query.docs.isNotEmpty ? query.docs.first['email'] : null;
    } catch (e) {
      debugPrint("Error getting email from phone: $e");
      return null;
    }
  }

  void saveCredentials(String email, String password)
    {
    final box = Hive.box('authBox');
    box.put('email', email);
    box.put('password', password);
  }

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    notifyListeners();
  }

  void setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  Future<void> _clearUserData() async {
    _user = null;
    _currentUser = null;
    await authBox.delete('userId');
    await authBox.delete('userData');
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    await _firebaseAuth.signOut();
    await googleSignIn.signOut();
    await _clearUserData();

    _isLoggingOut = false;
    notifyListeners();
  }

  @override
  void dispose() {
    authBox.close();
    super.dispose();
  }
}
