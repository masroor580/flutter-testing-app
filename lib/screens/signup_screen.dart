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

  late final TextEditingController _fullNameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _confirmPasswordController = TextEditingController();

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
    final authProvider = context.watch<AuthProvider>(); // Access provider

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
                      "Create an Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Sign up to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField("Full Name", _fullNameController, Icons.person, false, validator: _validateFullName),
                    const SizedBox(height: 10),
                    _buildTextField("Email", _emailController, Icons.email, false, validator: _validateEmail),
                    const SizedBox(height: 10),
                    _buildTextField("Phone", _phoneController, Icons.phone, false, validator: _validatePhone),
                    const SizedBox(height: 10),
                    _buildPasswordField("Password", _passwordController, Icons.lock, isConfirm: false),
                    const SizedBox(height: 10),
                    _buildPasswordField("Confirm Password", _confirmPasswordController, Icons.lock_outline, isConfirm: true),

                    const SizedBox(height: 20),

                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          onPressed: _handleSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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
                          child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isPassword, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, IconData icon, {required bool isConfirm}) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        bool isObscured = isConfirm ? authProvider.isConfirmPasswordObscured : authProvider.isPasswordObscured;

        return TextFormField(
          controller: controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                if (isConfirm) {
                  authProvider.toggleConfirmPasswordVisibility();
                } else {
                  authProvider.togglePasswordVisibility();
                }
              },
            ),
          ),
          validator: isConfirm ? _validateConfirmPassword : _validatePassword,
        );
      },
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
      return "Passwords do not match";
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    String? result = await authProvider.signUp(
      _fullNameController.text.trim(),
      _emailController.text.trim(),
      _phoneController.text.trim(),
      _passwordController.text.trim(),
    );

    if (result == null) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result), backgroundColor: Colors.redAccent),
      );
    }
  }
}
