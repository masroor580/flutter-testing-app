import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../auth_services/auth_provider.dart';
import 'package:new_app/auth_services/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  /// Validates email or phone number input
  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter email or phone number";
    }
    bool isValidEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    bool isValidPhone = RegExp(r'^\d{4,11}$').hasMatch(value);
    if (!isValidEmail && !isValidPhone) {
      return "Enter a valid email or phone number";
    }
    return null;
  }

  /// Validates password input
  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  /// Handles login with email/phone and password
  /// ✅ **Handles manual login**
  Future<void> _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setLoading(true);

    if (!_formKey.currentState!.validate()) {
      authProvider.setLoading(false);
      return;
    }

    String emailOrPhone = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String? result = await authProvider.login(emailOrPhone, password);

    authProvider.setLoading(false);

    if (!mounted) return;

    if (result == null) {
      final box = Hive.box('authBox');
      bool isBiometricEnabled = box.get('biometric_enabled') ?? false;

      if (isBiometricEnabled) { // ✅ Save credentials only if biometrics is enabled
        authProvider.saveCredentials(emailOrPhone, password);
      }

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }


  /// Handles Google sign-in
  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signInWithGoogle();

    if (!mounted) return;

    if (authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Stack(
          children: [
            _buildLoginUI(),
            if (authProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLoginUI() {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              /// Email / Phone Field
              CustomTextField(
                label: "Email / Phone",
                controller: _emailController,
                isPassword: false,
                validator: _validateEmailOrPhone,
              ),
              const SizedBox(height: 10),

              /// Password Field
              _buildPasswordField(),
              const SizedBox(height: 20),

              /// Login Button
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),

              const SizedBox(height: 15),

              /// Biometric Authentication Button
              ElevatedButton.icon(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  await authProvider.loginWithBiometrics(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.fingerprint, color: Colors.white),
                label: const Text("Login with Fingerprint", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),

              const SizedBox(height: 15),

              /// Google Sign-In Button
              ElevatedButton.icon(
                onPressed: _handleGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text("Sign in with Google", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 15),

              /// Sign-Up Navigation
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: const Text("Don't have an account? Sign Up", style: TextStyle(fontSize: 14, color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Selector<AuthProvider, bool>(
      selector: (_, auth) => auth.isPasswordObscured,
      builder: (context, isObscured, child) {
        return CustomTextField(
          label: "Password",
          controller: _passwordController,
          isPassword: true,
          validator: _validatePassword,
          obscureText: isObscured,
          onToggleObscure: () {
            Provider.of<AuthProvider>(context, listen: false).togglePasswordVisibility();
          },
        );
      },
    );
  }
}


  /// ✅ **Reusable Custom TextField**
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final VoidCallback? onToggleObscure;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.isPassword,
    this.validator,
    this.obscureText,
    this.onToggleObscure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? (obscureText ?? true) : false,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(
          isPassword ? Icons.lock : Icons.person, // 🔥 Icon for Password & Email/Phone
          color: Colors.blue,
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            (obscureText ?? true) ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onToggleObscure,
        )
            : null,
      ),
    );
  }
}
