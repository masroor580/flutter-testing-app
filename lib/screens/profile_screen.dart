// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../auth_services/auth_provider.dart';
// import 'login_screen.dart';
//
// /// ProfileScreen displays the current user's data and a logout button.
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint('🔄 ProfileScreen Rebuild');
//
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Consumer<AuthProvider>(
//           builder: (context, authProvider, child) {
//             final user = authProvider.user;
//
//             // ✅ Show loading indicator while fetching data
//             if (authProvider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             // ❌ If no user data is found, show an error message.
//             if (user == null) {
//               return const Center(
//                 child: Text(
//                   "No user data found",
//                   style: TextStyle(fontSize: 18, color: Colors.red),
//                 ),
//               );
//             }
//
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 20),
//
//                   // ✅ Profile Picture (for Google Users)
//                   _buildProfilePicture(user.photoURL),
//
//                   const SizedBox(height: 10),
//
//                   // ✅ Display User Name & Email
//                   Text(
//                     user.displayName ?? "User Name",
//                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     user.email ?? "user@example.com",
//                     style: const TextStyle(fontSize: 16, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // ✅ Display Phone Number
//                   ProfileItem(icon: Icons.phone, title: "Phone", value: user.phoneNumber),
//                   ProfileItem(icon: Icons.email, title: "Email", value: user.email),
//                   const SizedBox(height: 30),
//
//                   // ✅ Logout Button
//                   ElevatedButton.icon(
//                     onPressed: () async {
//                       await context.read<AuthProvider>().logout();
//                       if (context.mounted) {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (context) => const LoginScreen()),
//                               (route) => false,
//                         );
//                       }
//                     },
//                     icon: const Icon(Icons.logout, color: Colors.white),
//                     label: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.redAccent,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       minimumSize: const Size(double.infinity, 50),
//                       elevation: 5,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   /// ✅ Profile Picture Widget
//   Widget _buildProfilePicture(String? photoUrl) {
//     return CircleAvatar(
//       radius: 50,
//       backgroundColor: Colors.grey[300], // Light background for avatar
//       backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
//           ? NetworkImage(photoUrl)
//           : null, // If no image, use an icon instead
//       child: (photoUrl == null || photoUrl.isEmpty)
//           ? const Icon(Icons.account_circle, size: 80, color: Colors.grey)
//           : null, // Show default icon if no image
//     );
//   }
// }
//
// /// ✅ Optimized Profile Item Widget
// class ProfileItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String? value;
//
//   const ProfileItem({
//     Key? key,
//     required this.icon,
//     required this.title,
//     required this.value,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
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
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
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
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.user;
            final currentUser = authProvider.currentUser; // ✅ Fetch stored user data
            final phoneNumber = currentUser?['phone'] ?? "Not Available"; // ✅ Fix phone number issue
            final fullName = currentUser?['fullName'] ?? "No Name Available"; // ✅ Fix full name issue

            final displayedPhone = (phoneNumber == null || phoneNumber.isEmpty)
                ? "Phone number can't be displayed here" // ✅ Show message if phone is missing
                : phoneNumber;

            if (authProvider.isLoading) {
              return _buildShimmerProfile();
            }


            if (user == null) {
              return const Center(
                child: Text("No user data found", style: TextStyle(fontSize: 18, color: Colors.red)),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildProfilePicture(user.photoURL),
                  const SizedBox(height: 10),
                  Text(fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), // ✅ Full Name
                  Text(user.email ?? "user@example.com", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),

                  ProfileItem(icon: Icons.phone, title: "Phone", value: displayedPhone), // ✅ Fix phone number issue
                  ProfileItem(icon: Icons.email, title: "Email", value: user.email),

                  const SizedBox(height: 30),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildProfilePicture(String? photoUrl) {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[300],
      backgroundImage: (photoUrl != null && photoUrl.isNotEmpty) ? NetworkImage(photoUrl) : null,
      child: (photoUrl == null || photoUrl.isEmpty) ? const Icon(Icons.account_circle, size: 80, color: Colors.grey) : null,
    );
  }

  Widget _buildShimmerProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),

        // Profile Picture Placeholder
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
          ),
        ),

        const SizedBox(height: 10),

        // Name Placeholder
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Email Placeholder
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 180,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Phone Placeholder
        _buildShimmerItem(),

        // Email Placeholder
        _buildShimmerItem(),

        const SizedBox(height: 30),

        // Logout Button Placeholder
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

// Helper method to create shimmer items
  Widget _buildShimmerItem() {
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
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Icon(Icons.phone, size: 28, color: Colors.grey),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 100,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 4),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
