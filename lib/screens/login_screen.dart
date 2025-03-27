import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../auth_services/auth_provider.dart';

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

    /// Handles login process
  Future<void> _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isLoading) return;

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
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackbar(result);
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

  /// Handles Fingerprint Authentication
  Future<void> _handleFingerprintLogin() async {
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to log in',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (isAuthenticated) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // ✅ Replace with real user authentication logic
        String? result = await authProvider.biometricLogin();

        if (!mounted) return;

        if (result == null) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showSnackbar(result);
        }
      }
    } catch (e) {
      _showSnackbar("Fingerprint authentication failed.");
    }
  }

  /// Displays error messages
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Stack(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome Back! 👋",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// Email / Phone Field
                      CustomTextField(
                        label: "Email / Phone",
                        controller: _emailController,
                        isPassword: false,
                        validator: _validateEmailOrPhone,
                      ),
                      const SizedBox(height: 12),

                      /// Password Field
                      _buildPasswordField(),
                      const SizedBox(height: 24),

                      /// Login Button (Remains Visible but Disabled When Loading)

                         _buildButton(
                          onPressed: authProvider.isLoading ? null : _handleLogin,
                          icon: Icons.login,
                          label: "Login",
                        ),
                      const SizedBox(height: 12),

                      /// Fingerprint Login Button
                       _buildButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : _handleFingerprintLogin,
                          icon: Icons.fingerprint,
                          label: "Login with Fingerprint",
                        ),

                      const SizedBox(height: 10),

                      /// Google Sign-In Button
                       _buildButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : _handleGoogleSignIn,
                          icon: Icons.login,
                          label: "Sign in with Google",
                        ),

                      const SizedBox(height: 12),

                      /// Sign-Up Navigation
                      TextButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () {
                          Navigator.pushReplacementNamed(
                              context, '/signup');
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

            /// **Single Loading Overlay (White Background)**
            if (authProvider.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.7), // White transparent overlay
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  ),
                ),
              ),
          ],
        );
      },
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
            Provider.of<AuthProvider>(context, listen: false)
                .togglePasswordVisibility();
          },
        );
      },
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          shadowColor: Colors.blueAccent.withOpacity(0.5),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(label,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

    /// Email or Phone Validation
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

  /// Password Validation
  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
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
    super.key,
    required this.label,
    required this.controller,
    required this.isPassword,
    this.validator,
    this.obscureText,
    this.onToggleObscure,
  });

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
          isPassword ? Icons.lock : Icons.person,
          // 🔥 Icon for Password & Email/Phone
          color: Colors.blue,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (obscureText ?? true)
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: onToggleObscure,
              )
            : null,
      ),
    );
  }
}
