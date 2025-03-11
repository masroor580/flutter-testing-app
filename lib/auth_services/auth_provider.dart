import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  User? get user => _user;  // ✅ Public getter for _user

  Map<String, dynamic>? _currentUser;
  bool _isLoading = true;

  late Box authBox;

  User? get firebaseUser => _user;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  AuthProvider() {
    _initAuthProvider();
  }

  /// ✅ Initialize AuthProvider
  Future<void> _initAuthProvider() async {
    authBox = await Hive.openBox('authBox');
    await _checkUserLogin(); // Ensure it's awaited properly
  }


  /// ✅ Check if user is logged in at app startup
  Future<void> _checkUserLogin() async {
    try {
      String? uid = authBox.get('userId');
      _user = _firebaseAuth.currentUser;

      debugPrint("ℹ️ Firebase Auth User: $_user");
      debugPrint("ℹ️ Hive stored UID: $uid");

      if (_user != null && uid != null && _user!.uid == uid) {
        _currentUser = authBox.get('userData');

        // Debug: Check Hive storage
        debugPrint("🔍 User data retrieved from Hive: $_currentUser");

        if (_currentUser == null) {
          await _fetchUserData(uid);
        }
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

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }



  /// ✅ Fetch user data from Firestore
  /// ✅ Fetch user data from Firestore
  Future<void> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Debug: Print fetched data
        debugPrint("✅ User data fetched from Firestore: $data");

        // Convert Firestore Timestamp to DateTime
        data.forEach((key, value) {
          if (value is Timestamp) {
            data[key] = value.toDate();
          }
        });

        // ✅ Save data in Hive and update provider
        _currentUser = data;
        authBox.put('userData', _currentUser);
        notifyListeners();
      } else {
        debugPrint("⚠️ No user document found in Firestore for UID: $uid");
      }
    } catch (e) {
      debugPrint("🔥 Error fetching user data: $e");
    }
  }




  /// ✅ Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      setLoading(true);

      await googleSignIn.signOut(); // Force account selection

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setLoading(false);
        return; // User canceled login
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      _user = userCredential.user;
      notifyListeners();

      // ✅ Store user data in Firestore
      await saveUserToFirestore(_user);

      // ✅ Fetch user details from Firestore
      await loadUserFromFirestore(_user!.uid);

      debugPrint("✅ Google Sign-In Success: ${_user?.email}");
    } catch (e) {
      debugPrint("❌ Google Sign-In Error: $e");
    } finally {
      setLoading(false);
    }
  }

  bool _isPasswordObscured = true;

  bool get isPasswordObscured => _isPasswordObscured;

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners(); // 🔥 Only rebuilds `Selector`, not the whole screen
  }

  Future<void> saveUserToFirestore(User? user) async {
    if (user == null) return;

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // ✅ Check if user already exists
    final userSnapshot = await userDoc.get();

    if (!userSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'fullName': user.displayName ?? "No Name",
        'email': user.email,
        'photoUrl': user.photoURL ?? "",
        'phone': user.phoneNumber ?? "",
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("✅ New user added to Firestore: ${user.email}");
    } else {
      debugPrint("ℹ️ User already exists in Firestore");
    }
  }

  Future<void> loadUserFromFirestore(String uid) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    final userSnapshot = await userDoc.get();

    if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      if (userData != null) {
        _user = FirebaseAuth.instance.currentUser; // Update local user
        notifyListeners();
        debugPrint("✅ User data loaded from Firestore");
      }
    } else {
      debugPrint("❌ No user data found in Firestore");
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
    } catch (e) {
      return "Login failed: $e";
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

  Future<String?> _loginWithEmail(String email, String password) async {
    try {
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

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
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
