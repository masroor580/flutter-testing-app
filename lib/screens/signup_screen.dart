// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../auth_services/auth_provider.dart';
// import 'login_screen.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Text controllers for each field.
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//
//   // For toggling password visibility.
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//
//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Signup Screen build');
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
//                 child: ListView(
//                   shrinkWrap: true,
//                   children: [
//                     const Text(
//                       "Create Account",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Sign up to continue",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildTextField(
//                         "Full Name", _fullNameController, false,
//                         validator: _validateFullName),
//                     const SizedBox(height: 10),
//                     _buildTextField("Email", _emailController, false,
//                         validator: _validateEmail),
//                     const SizedBox(height: 10),
//                     _buildTextField("Phone", _phoneController, false,
//                         validator: _validatePhone),
//                     const SizedBox(height: 10),
//                     _buildTextField(
//                         "Password", _passwordController, true,
//                         isConfirm: false, validator: _validatePassword),
//                     const SizedBox(height: 10),
//                     _buildTextField(
//                         "Confirm Password", _confirmPasswordController, true,
//                         isConfirm: true, validator: _validateConfirmPassword),
//                     const SizedBox(height: 20),
//                     authProvider.isLoading
//                         ? const Center(child: CircularProgressIndicator())
//                         : ElevatedButton(
//                       onPressed: _handleSignUp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 40, vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: const Text(
//                         "Sign Up",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Already have an account?"),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(builder: (context) => const LoginScreen()),
//                             );
//                           },
//                           child: const Text("Login",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold, color: Colors.blue)),
//                         ),
//                       ],
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
//   /// Helper method to create a text field with inline validation.
//   Widget _buildTextField(
//       String label,
//       TextEditingController controller,
//       bool isPassword, {
//         bool isConfirm = false,
//         String? Function(String?)? validator,
//       }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: isPassword
//           ? (isConfirm ? _obscureConfirmPassword : _obscurePassword)
//           : false,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         suffixIcon: isPassword
//             ? IconButton(
//           icon: Icon(
//             isConfirm
//                 ? (_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off)
//                 : (_obscurePassword ? Icons.visibility : Icons.visibility_off),
//           ),
//           onPressed: () {
//             setState(() {
//               if (isConfirm) {
//                 _obscureConfirmPassword = !_obscureConfirmPassword;
//               } else {
//                 _obscurePassword = !_obscurePassword;
//               }
//             });
//           },
//         )
//             : null,
//       ),
//       validator: validator,
//     );
//   }
//
//   /// Full Name Validation
//   String? _validateFullName(String? value) {
//     if (value == null || value.trim().isEmpty) return "Full Name is required";
//     if (!RegExp(r"^[a-zA-Z\s]{2,}$").hasMatch(value)) {
//       return "Only letters allowed, minimum 2 characters";
//     }
//     return null;
//   }
//
//   /// Email Validation
//   String? _validateEmail(String? value) {
//     if (value == null || value.trim().isEmpty) return "Email is required";
//     if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
//       return "Enter a valid email address";
//     }
//     return null;
//   }
//
//   /// Phone Number Validation
//   String? _validatePhone(String? value) {
//     if (value == null || value.trim().isEmpty) return "Phone number is required";
//     if (!RegExp(r'^[0-9]{4,11}$').hasMatch(value)) {
//       return "Phone number must be 4-11 digits";
//     }
//     return null;
//   }
//
//   /// Password Validation
//   String? _validatePassword(String? value) {
//     if (value == null || value.trim().isEmpty) return "Password is required";
//     if (value.length < 6) return "Password must be at least 6 characters long";
//     if (!RegExp(r'^(?=.*[A-Z])(?=.*[@#\$%^&+=!]).{6,}$').hasMatch(value)) {
//       return "Must contain 1 uppercase & 1 special character";
//     }
//     return null;
//   }
//
//   /// Confirm Password Validation
//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.trim().isEmpty) return "Confirm Password is required";
//     if (value != _passwordController.text) {
//       return "Password do not match";
//     }
//     return null;
//   }
//
//   Future<void> _handleSignUp() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//
//     print("🔄 Checking for existing users before signing up...");
//
//     String? result = await authProvider.signUp(
//       _fullNameController.text.trim(),
//       _emailController.text.trim(),
//       _phoneController.text.trim(),
//       _passwordController.text.trim(),
//     );
//
//     if (result == null) {
//       print("✅ Signup successful. Showing alert dialog.");
//       if (context.mounted) {
//         showDialog(
//           context: context,
//           barrierDismissible: false, // Prevent user from closing manually.
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16), // Rounded corners.
//             ),
//             title: Column(
//               children: const [
//                 Icon(Icons.check_circle, size: 60, color: Colors.green),
//                 SizedBox(height: 10),
//                 Text(
//                   "Signup Successful!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min, // Prevent excessive height.
//               children: [
//                 const Text(
//                   "Your account has been created successfully.\nPlease log in to continue.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 16, color: Colors.black87),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close dialog.
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const LoginScreen()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       "Go to Login",
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     } else {
//       print("❌ Signup failed: $result");
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(result),
//             backgroundColor: Colors.redAccent,
//           ),
//         );
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_services/auth_provider.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use late final to ensure controllers are initialized only once.
  late final TextEditingController _fullNameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _confirmPasswordController = TextEditingController();

  // Password visibility states
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Signup Screen build');
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      "Create Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sign up to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField("Full Name", _fullNameController, false,
                        validator: _validateFullName),
                    const SizedBox(height: 10),
                    _buildTextField("Email", _emailController, false,
                        validator: _validateEmail),
                    const SizedBox(height: 10),
                    _buildTextField("Phone", _phoneController, false,
                        validator: _validatePhone),
                    const SizedBox(height: 10),
                    _buildTextField("Password", _passwordController, true,
                        isConfirm: false, validator: _validatePassword),
                    const SizedBox(height: 10),
                    _buildTextField("Confirm Password", _confirmPasswordController, true,
                        isConfirm: true, validator: _validateConfirmPassword),
                    const SizedBox(height: 20),

                    // Use context.watch<AuthProvider>() only inside the button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text("Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.blue)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Optimized password visibility toggle to prevent unnecessary rebuilds.
  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword,
      {bool isConfirm = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword
          ? (isConfirm ? _obscureConfirmPassword : _obscurePassword)
          : false,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isPassword
            ? StatefulBuilder(
          builder: (context, setState) {
            return IconButton(
              icon: Icon(
                isConfirm
                    ? (_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off)
                    : (_obscurePassword ? Icons.visibility : Icons.visibility_off),
              ),
              onPressed: () {
                setState(() {
                  if (isConfirm) {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  } else {
                    _obscurePassword = !_obscurePassword;
                  }
                });
              },
            );
          },
        )
            : null,
      ),
      validator: validator,
    );
  }

    /// Full Name Validation
  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) return "Full Name is required";
    if (!RegExp(r"^[a-zA-Z\s]{2,}$").hasMatch(value)) {
      return "Only letters allowed, minimum 2 characters";
    }
    return null;
  }

  /// Email Validation
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  /// Phone Number Validation
  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return "Phone number is required";
    if (!RegExp(r'^[0-9]{4,11}$').hasMatch(value)) {
      return "Phone number must be 4-11 digits";
    }
    return null;
  }

  /// Password Validation
  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters long";
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[@#\$%^&+=!]).{6,}$').hasMatch(value)) {
      return "Must contain 1 uppercase & 1 special character";
    }
    return null;
  }

  /// Confirm Password Validation
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) return "Confirm Password is required";
    if (value != _passwordController.text) {
      return "Password do not match";
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    print("🔄 Checking for existing users before signing up...");

    String? result = await authProvider.signUp(
      _fullNameController.text.trim(),
      _emailController.text.trim(),
      _phoneController.text.trim(),
      _passwordController.text.trim(),
    );

    if (result == null) {
      print("✅ Signup successful. Showing alert dialog.");
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              children: const [
                Icon(Icons.check_circle, size: 60, color: Colors.green),
                SizedBox(height: 10),
                Text(
                  "Signup Successful!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Your account has been created successfully.\nPlease log in to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text("Go to Login"),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      print("❌ Signup failed: $result");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.redAccent),
      );
    }
  }
}
