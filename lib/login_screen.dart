// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'auth_provider.dart';
// import 'home_screen.dart';
// import 'signup_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   String? _validateEmailOrPhone(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Email or phone number is required";
//     }
//     bool isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
//     bool isValidPhone = RegExp(r'^[0-9]{4,11}$').hasMatch(value);
//     if (!isValidEmail && !isValidPhone) {
//       return "Enter a valid email or phone number";
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Password is required";
//     }
//     if (value.length < 6) {
//       return "Password must be at least 6 characters";
//     }
//     return null;
//   }
//
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     String emailOrPhone = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     String? result = await authProvider.login(emailOrPhone, password);
//
//     if (result == null) {
//       if (context.mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomeScreen()),
//         );
//       }
//     } else {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result)),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("Login Screen Build");
//     final authProvider = Provider.of<AuthProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Card(
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Welcome Back!",
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     _buildTextField("Email / Phone", _emailController, false, _validateEmailOrPhone),
//                     const SizedBox(height: 10),
//                     _buildTextField("Password", _passwordController, true, _validatePassword),
//                     const SizedBox(height: 20),
//                     authProvider.isLoading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                       onPressed: _handleLogin,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         "Login",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (context) => SignUpScreen()),
//                         );
//                       },
//                       child: const Text(
//                         "Don't have an account? Sign Up",
//                         style: TextStyle(fontSize: 14, color: Colors.blue),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller, bool isPassword, String? Function(String?) validator) {
//     print("BuildTextField Login Build");
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword ? _obscurePassword : false,
//       validator: validator,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         suffixIcon: isPassword
//             ? IconButton(
//           icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//           onPressed: () {
//             setState(() {
//               _obscurePassword = !_obscurePassword;
//             });
//           },
//         )
//             : null,
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'auth_provider.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isNavigating = false; // New flag for showing navigation loading
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   String? _validateEmailOrPhone(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Email or phone number is required";
//     }
//     bool isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
//     bool isValidPhone = RegExp(r'^[0-9]{4,11}$').hasMatch(value);
//     if (!isValidEmail && !isValidPhone) {
//       return "Enter a valid email or phone number";
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Password is required";
//     }
//     if (value.length < 6) {
//       return "Password must be at least 6 characters";
//     }
//     return null;
//   }
//
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     String emailOrPhone = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     String? result = await authProvider.login(emailOrPhone, password);
//
//
//
//     if (result == null) {
//       if (context.mounted) {
//         Navigator.pushReplacementNamed(context, '/home'); // ✅ FIXED: Uses named route
//       }
//     } else {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result)),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("Login Screen Build");
//
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Card(
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Text(
//                       "Welcome Back!",
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     _buildTextField("Email / Phone", _emailController, false, _validateEmailOrPhone),
//                     const SizedBox(height: 10),
//                     _buildTextField("Password", _passwordController, true, _validatePassword),
//                     const SizedBox(height: 20),
//
//                     // ✅ FIXED: Only button rebuilds, not entire screen
//                     Consumer<AuthProvider>(
//                       builder: (context, authProvider, child) {
//                         return authProvider.isLoading
//                             ? const CircularProgressIndicator()
//                             : ElevatedButton(
//                           onPressed: _handleLogin,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             "Login",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         );
//                       },
//                     ),
//
//                     const SizedBox(height: 15),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, '/signup'); // ✅ FIXED: Uses named route
//                       },
//                       child: const Text(
//                         "Don't have an account? Sign Up",
//                         style: TextStyle(fontSize: 14, color: Colors.blue),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       String label,
//       TextEditingController controller,
//       bool isPassword,
//       String? Function(String?) validator,
//       ) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return TextFormField(
//           controller: controller,
//           obscureText: isPassword ? _obscurePassword : false,
//           validator: validator,
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             suffixIcon: isPassword
//                 ? IconButton(
//               icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             )
//                 : null,
//           ),
//         );
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'auth_provider.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isNavigating = false; // Flag for showing loading overlay
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   String? _validateEmailOrPhone(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Email or phone number is required";
//     }
//     bool isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
//     bool isValidPhone = RegExp(r'^[0-9]{4,11}$').hasMatch(value);
//
//     if (!isValidEmail && !isValidPhone) {
//       return "Enter a valid email or phone number";
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Password is required";
//     }
//     if (value.length < 6) {
//       return "Password must be at least 6 characters";
//     }
//     return null;
//   }
//
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     // Immediately show loading overlay.
//     setState(() {
//       _isNavigating = true;
//     });
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     String emailOrPhone = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     String? result = await authProvider.login(emailOrPhone, password);
//
//     if (result == null) {
//       // Wait for 1 second so that the loading overlay is visible.
//       await Future.delayed(const Duration(milliseconds: 500));
//       if (context.mounted) {
//         Navigator.pushReplacementNamed(context, '/home');
//       }
//     } else {
//       // If login fails, hide the overlay and show error.
//       setState(() {
//         _isNavigating = false;
//       });
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result)),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("Login Screen Build");
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           "Welcome Back!",
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10),
//                         _buildTextField("Email / Phone", _emailController, false, _validateEmailOrPhone),
//                         const SizedBox(height: 10),
//                         _buildTextField("Password", _passwordController, true, _validatePassword),
//                         const SizedBox(height: 20),
//                         Consumer<AuthProvider>(
//                           builder: (context, authProvider, child) {
//                             return authProvider.isLoading
//                                 ? const CircularProgressIndicator()
//                                 : ElevatedButton(
//                               onPressed: _handleLogin,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue,
//                                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               child: const Text(
//                                 "Login",
//                                 style: TextStyle(fontSize: 16, color: Colors.white),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushReplacementNamed(context, '/signup');
//                           },
//                           child: const Text(
//                             "Don't have an account? Sign Up",
//                             style: TextStyle(fontSize: 14, color: Colors.blue),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Show loading overlay if _isNavigating is true
//           if (_isNavigating)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       String label,
//       TextEditingController controller,
//       bool isPassword,
//       String? Function(String?) validator,
//       ) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return TextFormField(
//           controller: controller,
//           obscureText: isPassword ? _obscurePassword : false,
//           validator: validator,
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             suffixIcon: isPassword
//                 ? IconButton(
//               icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             )
//                 : null,
//           ),
//         );
//       },
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package
// import 'auth_provider.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isNavigating = false; // Flag for showing loading overlay
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   String? _validateEmailOrPhone(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Email or phone number is required";
//     }
//     bool isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
//     bool isValidPhone = RegExp(r'^[0-9]{4,11}$').hasMatch(value);
//
//     if (!isValidEmail && !isValidPhone) {
//       return "Enter a valid email or phone number";
//     }
//     return null;
//   }
//
//   String? _validatePassword(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return "Password is required";
//     }
//     if (value.length < 6) {
//       return "Password must be at least 6 characters";
//     }
//     return null;
//   }
//
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     // Immediately show loading overlay.
//     setState(() {
//       _isNavigating = true;
//     });
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     String emailOrPhone = _emailController.text.trim();
//     String password = _passwordController.text.trim();
//
//     String? result = await authProvider.login(emailOrPhone, password);
//
//     if (result == null) {
//       // Wait for 500ms so that the loading overlay is visible.
//       await Future.delayed(const Duration(milliseconds: 500));
//       if (context.mounted) {
//         Navigator.pushReplacementNamed(context, '/home');
//       }
//     } else {
//       // If login fails, hide the overlay and show error.
//       setState(() {
//         _isNavigating = false;
//       });
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result)),
//         );
//       }
//     }
//   }
//
//   Future<void> _handleGoogleSignIn() async {
//     setState(() {
//       _isNavigating = true;
//     });
//
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//
//       if (googleUser == null) {
//         // User cancelled the sign in
//         setState(() {
//           _isNavigating = false;
//         });
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//
//       // Create a new credential for Firebase
//       final firebaseAuth.AuthCredential credential = firebaseAuth.GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         accessToken: googleAuth.accessToken,
//       );
//
//       // Sign in to Firebase with the Google credentials
//       final firebaseAuth.UserCredential userCredential =
//       await firebaseAuth.FirebaseAuth.instance.signInWithCredential(credential);
//
//       if (userCredential.user != null) {
//         // Successful sign in. Firebase now has the user data.
//         if (context.mounted) {
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       }
//     } catch (error) {
//       setState(() {
//         _isNavigating = false;
//       });
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Google Sign-In failed: $error")),
//         );
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     print("Login Screen Build");
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           "Welcome Back!",
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10),
//                         _buildTextField("Email / Phone", _emailController, false, _validateEmailOrPhone),
//                         const SizedBox(height: 10),
//                         _buildTextField("Password", _passwordController, true, _validatePassword),
//                         const SizedBox(height: 20),
//                         // Normal Login Button
//                         ElevatedButton(
//                           onPressed: _handleLogin,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             "Login",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         // Google Sign-In Button
//                         ElevatedButton.icon(
//                           onPressed: _handleGoogleSignIn,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.redAccent,
//                             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           icon: const Icon(Icons.g_mobiledata, color: Colors.white),
//                           label: const Text(
//                             "Sign in with Google",
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushReplacementNamed(context, '/signup');
//                           },
//                           child: const Text(
//                             "Don't have an account? Sign Up",
//                             style: TextStyle(fontSize: 14, color: Colors.blue),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Show loading overlay if _isNavigating is true
//           if (_isNavigating)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       String label,
//       TextEditingController controller,
//       bool isPassword,
//       String? Function(String?) validator,
//       ) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return TextFormField(
//           controller: controller,
//           obscureText: isPassword ? _obscurePassword : false,
//           validator: validator,
//           decoration: InputDecoration(
//             labelText: label,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//             suffixIcon: isPassword
//                 ? IconButton(
//               icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
//               onPressed: () {
//                 setState(() {
//                   _obscurePassword = !_obscurePassword;
//                 });
//               },
//             )
//                 : null,
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package
import 'auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isNavigating = false; // Flag for showing loading overlay

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email or phone number is required";
    }
    bool isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    bool isValidPhone = RegExp(r'^[0-9]{4,11}$').hasMatch(value);

    if (!isValidEmail && !isValidPhone) {
      return "Enter a valid email or phone number";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // Immediately show loading overlay.
    setState(() {
      _isNavigating = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String emailOrPhone = _emailController.text.trim();
    String password = _passwordController.text.trim();

    String? result = await authProvider.login(emailOrPhone, password);

    if (result == null) {
      // Wait for 500ms so that the loading overlay is visible.
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // If login fails, hide the overlay and show error.
      setState(() {
        _isNavigating = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isNavigating = true;
    });

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign in
        setState(() {
          _isNavigating = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential for Firebase
      final firebaseAuth.AuthCredential credential =
      firebaseAuth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the Google credentials
      final firebaseAuth.UserCredential userCredential =
      await firebaseAuth.FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Successful sign in. Firebase now has the user data.
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (error) {
      setState(() {
        _isNavigating = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In failed: $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Login Screen Build");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // Using mainAxisSize.min to fit the content.
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Welcome Back!",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          _buildTextField("Email / Phone", _emailController, false, _validateEmailOrPhone),
                          const SizedBox(height: 10),
                          _buildTextField("Password", _passwordController, true, _validatePassword),
                          const SizedBox(height: 20),
                          // Normal Login Button
                          ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Google Sign-In Button
                          ElevatedButton.icon(
                            onPressed: _handleGoogleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.g_mobiledata, color: Colors.white),
                            label: const Text(
                              "Sign in with Google",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/signup');
                            },
                            child: const Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Show loading overlay if _isNavigating is true.
          if (_isNavigating)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      bool isPassword,
      String? Function(String?) validator,
      ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
                : null,
          ),
        );
      },
    );
  }
}

//login completed