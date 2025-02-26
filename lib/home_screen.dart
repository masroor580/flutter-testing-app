// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'auth_provider.dart';
// import 'user_provider.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Profile",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: userProvider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//         onRefresh: () async {
//           await userProvider.fetchUserData();
//         },
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Profile Picture
//                 Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [Colors.blueAccent, Colors.lightBlueAccent],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blueAccent.withOpacity(0.4),
//                         blurRadius: 15,
//                         spreadRadius: 3,
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(4),
//                   child: const CircleAvatar(
//                     radius: 55,
//                     backgroundColor: Colors.white,
//                     child: Icon(Icons.person, size: 60, color: Colors.blueAccent),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                   userProvider.userData?['fullName'] ?? "User Name",
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   userProvider.userData?['email'] ?? "user@example.com",
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 25),
//
//                 // Profile Details
//                 _buildProfileItem(Icons.phone, "Phone", userProvider.userData?['phone'] ?? "Not Available"),
//                 _buildProfileItem(Icons.email, "Email", userProvider.userData?['email'] ?? "user@example.com"),
//
//                 const SizedBox(height: 40),
//
//                 // Logout Button
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     authProvider.logout(context);
//                   },
//                   icon: const Icon(Icons.logout, color: Colors.white),
//                   label: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     minimumSize: const Size(double.infinity, 50),
//                     elevation: 5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Improved Profile Item UI
//   Widget _buildProfileItem(IconData icon, String title, String value) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey,
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
//                   value,
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'auth_provider.dart';
// import 'login_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print("Home Screen Build");
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.currentUser;
//
//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         title: const Text(
//           "Profile",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: user == null
//           ? const Center(child: Text("No user data found"))
//           : Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Profile Picture
//             Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: const LinearGradient(
//                   colors: [Colors.blueAccent, Colors.lightBlueAccent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blueAccent.withOpacity(0.4),
//                     blurRadius: 10,
//                     spreadRadius: 3,
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(4),
//               child: const CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               user['fullName'] ?? "User Name",
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               user['email'] ?? "user@example.com",
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 20),
//
//             // Profile Details Card
//             _buildProfileItem(Icons.phone, "Phone", user['phone'] ?? "Not Available"),
//             _buildProfileItem(Icons.email, "Email", user['email'] ?? "user@example.com"),
//             const SizedBox(height: 40),
//
//             // Logout Button
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final authProvider = Provider.of<AuthProvider>(context, listen: false);
//                 await authProvider.logout(); // No context needed
//
//                 if (context.mounted) {
//                   Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to LoginScreen
//                         (route) => false, // Remove all previous routes
//                   );
//                 }
//               },
//               icon: const Icon(Icons.logout, color: Colors.white),
//               label: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//                 elevation: 5,
//               ),
//             ),
//           ],
//         ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileItem(IconData icon, String title, String value) {
//     print("BuildProfileItem Home Build");
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
//                   value,
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
//


import 'package:flutter/material.dart';
import 'package:new_app/orders_page.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'login_screen.dart';
import 'payment.dart'; //

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏠 HomeScreen build');
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: user == null
          ? const Center(
        child: Text(
          "No user data found",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🟢 Profile Image
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),

              // 🟢 User Details
              Text(
                user['fullName'] ?? "User Name",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user['email'] ?? "user@example.com",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // 🟢 Profile Details (Phone & Email)
              _buildProfileItem(Icons.phone, "Phone", user['phone']),
              _buildProfileItem(Icons.email, "Email", user['email']),

              const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const OrdersPage()),
                );
              },
              icon: const Icon(Icons.fastfood, color: Colors.white), // Icon for food orders.
              label: const Text(
                "Food Orders",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 50),
                elevation: 5,
              ),
            ),


            const SizedBox(height: 20),

              // 🟢 Go to Payment Button (NEW)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                },
                icon: const Icon(Icons.payment, color: Colors.white),
                label: const Text("Go to Payment", style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // ✅ Green color for payment
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 5,
                ),
              ),

              const SizedBox(height: 20),

              // 🔴 Logout Button
              ElevatedButton.icon(
                onPressed: () async {
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
        ),
      ),
    );
  }

  /// 🟢 Profile Information Card
  Widget _buildProfileItem(IconData icon, String title, String? value) {
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
                Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
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


