import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_services/auth_provider.dart';
import 'login_screen.dart';

/// ProfileScreen displays the current user's data and a logout button.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key})

  @override
  Widget build(BuildContext context) {
    print('Profile Build');

    // Use listen: false because the user data is assumed not to change after fetching.
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    // If no user data is found, show an error message.
    if (user == null) {
      return const Center(
        child: Text(
          "No user data found",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
          ),
          const SizedBox(height: 20),

          // User Details: Full Name and Email
          Text(
            user['fullName'] ?? "User Name",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            user['email'] ?? "user@example.com",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Additional Profile Items (e.g., Phone and Email)
          _buildProfileItem(Icons.phone, "Phone", user['phone']),
          _buildProfileItem(Icons.email, "Email", user['email']),
          const SizedBox(height: 30),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () async {
              // Use listen: false to avoid rebuild when calling logout.
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a styled container displaying an icon, a title, and the corresponding value.
  Widget _buildProfileItem(IconData icon, String title, String? value) {
    print('ProfileItems Build');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueAccent),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? "Not Available",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
