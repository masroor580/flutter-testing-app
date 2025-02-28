// import 'package:flutter/material.dart';
// import 'package:new_app/orders_screen.dart';
// import 'package:provider/provider.dart';
// import 'auth_provider.dart';
// import 'login_screen.dart';
// import 'payment_screen.dart'; //
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print('🏠 HomeScreen build');
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
//           ? const Center(
//         child: Text(
//           "No user data found",
//           style: TextStyle(fontSize: 18, color: Colors.red),
//         ),
//       )
//           : Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // 🟢 Profile Image
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
//               ),
//               const SizedBox(height: 20),
//
//               // 🟢 User Details
//               Text(
//                 user['fullName'] ?? "User Name",
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 user['email'] ?? "user@example.com",
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 20),
//
//               // 🟢 Profile Details (Phone & Email)
//               _buildProfileItem(Icons.phone, "Phone", user['phone']),
//               _buildProfileItem(Icons.email, "Email", user['email']),
//
//               const SizedBox(height: 30),
//
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => const OrdersPage()),
//                 );
//               },
//               icon: const Icon(Icons.fastfood, color: Colors.white), // Icon for food orders.
//               label: const Text(
//                 "Food Orders",
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blueAccent,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//                 elevation: 5,
//               ),
//             ),
//
//
//             const SizedBox(height: 20),
//
//               // 🟢 Go to Payment Button (NEW)
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => PaymentScreen()),
//                   );
//                 },
//                 icon: const Icon(Icons.payment, color: Colors.white),
//                 label: const Text("Go to Payment", style: TextStyle(fontSize: 18, color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green, // ✅ Green color for payment
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   minimumSize: const Size(double.infinity, 50),
//                   elevation: 5,
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // 🔴 Logout Button
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final authProvider = Provider.of<AuthProvider>(context, listen: false);
//                   await authProvider.logout();
//                   if (context.mounted) {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(builder: (context) => const LoginScreen()),
//                           (route) => false,
//                     );
//                   }
//                 },
//                 icon: const Icon(Icons.logout, color: Colors.white),
//                 label: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.redAccent,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   minimumSize: const Size(double.infinity, 50),
//                   elevation: 5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// 🟢 Profile Information Card
//   Widget _buildProfileItem(IconData icon, String title, String? value) {
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
//
//

import 'package:flutter/material.dart';
import 'package:new_app/screens/orders_screen.dart';
import 'package:new_app/screens/permission_screen.dart';
import 'package:new_app/screens/profile_screen.dart';
import 'payment_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Create each page only once.
    _pages = const [
      ProfileScreen(),     // Profile tab.
      OrdersPage(),        // Orders tab.
      PaymentScreen(),     // Payment tab.
      PermissionsScreen(), // Permissions tab.
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    // List of titles for the app bar.
    final titles = ["Profile", "Food Orders", "Payment", "Permissions"];
    return AppBar(
      title: Text(titles[_currentIndex]),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Home Screen Build');
    return Scaffold(
      appBar: _buildAppBar(),
      // Using IndexedStack to preserve state of each page.
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

/// A custom bottom navigation bar that makes only the icon and label clickable.
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build a row with 4 items; spacing between items is provided by MainAxisAlignment.spaceAround.
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          // Define icon and label for each tab.
          IconData icon;
          String label;
          switch (index) {
            case 0:
              icon = Icons.home;
              label = "Profile";
              break;
            case 1:
              icon = Icons.fastfood;
              label = "Orders";
              break;
            case 2:
              icon = Icons.payment;
              label = "Payment";
              break;
            case 3:
              icon = Icons.security;
              label = "Permissions";
              break;
            default:
              icon = Icons.help;
              label = "Unknown";
          }
          bool selected = index == currentIndex;
          // Wrap only the icon and label in an InkWell.
          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: selected ? Colors.blueAccent : Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.blueAccent : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
