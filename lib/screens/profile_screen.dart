// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../auth_services/auth_provider.dart';
// import 'login_screen.dart';
//
// /// ProfileScreen displays the current user's data and a logout button.
// /// This is used as the default (home) tab.
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print('Profile Build');
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.currentUser;
//
//     return user == null
//         ? const Center(
//       child: Text(
//         "No user data found",
//         style: TextStyle(fontSize: 18, color: Colors.red),
//       ),
//     )
//         : SingleChildScrollView(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Profile Image
//           const CircleAvatar(
//             radius: 50,
//             backgroundColor: Colors.white,
//             child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
//           ),
//           const SizedBox(height: 20),
//           // User Details
//           Text(
//             user['fullName'] ?? "User Name",
//             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             user['email'] ?? "user@example.com",
//             style: const TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           const SizedBox(height: 20),
//           _buildProfileItem(Icons.phone, "Phone", user['phone']),
//           _buildProfileItem(Icons.email, "Email", user['email']),
//           const SizedBox(height: 30),
//           // Logout Button
//           ElevatedButton.icon(
//             onPressed: () async {
//               final authProvider = Provider.of<AuthProvider>(context, listen: false);
//               await authProvider.logout();
//               if (context.mounted) {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                       (route) => false,
//                 );
//               }
//             },
//             icon: const Icon(Icons.logout, color: Colors.white),
//             label: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               padding: const EdgeInsets.symmetric(vertical: 14),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               minimumSize: const Size(double.infinity, 50),
//               elevation: 5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildProfileItem(IconData icon, String title, String? value) {
//     print('ProfileItems Build');
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 8,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 28, color: Colors.blueAccent),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
//                 const SizedBox(height: 4),
//                 Text(
//                   value ?? "Not Available",
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_services/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';  // Import for navigation

/// ProfileScreen displays the current user's data and a logout button.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('ProfileScreen Build');

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.currentUser;

            // ✅ Show loading indicator while fetching data
            if (authProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ❌ If no user data is found, show an error message.
            if (user == null) {
              return const Center(
                child: Text(
                  "No user data found",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // ✅ Profile Picture (for Google Users)
                  _buildProfilePicture(user['photoUrl']),

                  const SizedBox(height: 10),

                  // ✅ Display User Name & Email
                  Text(
                    user['fullName'] ?? "User Name",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user['email'] ?? "user@example.com",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Display Phone Number
                  ProfileItem(icon: Icons.phone, title: "Phone", value: user['phone']),
                  ProfileItem(icon: Icons.email, title: "Email", value: user['email']),
                  const SizedBox(height: 30),

                  // ✅ Logout Button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
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
          },
        ),
      ),
    );
  }

  /// ✅ Profile Picture Widget
  Widget _buildProfilePicture(String? photoUrl) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: photoUrl != null && photoUrl.isNotEmpty
          ? NetworkImage(photoUrl)
          : const AssetImage('assets/default_avatar.png') as ImageProvider, // Default avatar
    );
  }

  /// ✅ Bottom Navigation Bar
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      currentIndex: 1, // Set Profile as active tab
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainHome()),
          );
        }
      },
    );
  }
}

/// ✅ Optimized Profile Item Widget
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;

  const ProfileItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
