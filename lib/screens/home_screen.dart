// import 'package:flutter/material.dart';
// import 'package:new_app/screens/orders_screen.dart';
// import 'package:new_app/screens/permission_screen.dart';
// import 'package:new_app/screens/profile_screen.dart';
// import 'payment_screen.dart';
//
// class MainHome extends StatefulWidget {
//   const MainHome({super.key});
//
//   @override
//   _MainHomeState createState() => _MainHomeState();
// }
//
// class _MainHomeState extends State<MainHome> {
//   int _currentIndex = 0;
//   late final List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     // Create each page only once.
//     _pages = const [
//       ProfileScreen(),     // Profile tab.
//       OrdersPage(),        // Orders tab.
//       PaymentScreen(),     // Payment tab.
//       PermissionsScreen(), // Permissions tab.
//     ];
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     // List of titles for the app bar.
//     final titles = ["Profile", "Food Orders", "Payment", "Permissions"];
//     return AppBar(
//       title: Text(titles[_currentIndex]),
//       centerTitle: true,
//       backgroundColor: Colors.blueAccent,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Home Screen Build');
//     return Scaffold(
//       appBar: _buildAppBar(),
//       // Using IndexedStack to preserve state of each page.
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
//   }
// }
//
// /// A custom bottom navigation bar that makes only the icon and label clickable.
// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//
//   const CustomBottomNavigationBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Build a row with 4 items; spacing between items is provided by MainAxisAlignment.spaceAround.
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: List.generate(4, (index) {
//           // Define icon and label for each tab.
//           IconData icon;
//           String label;
//           switch (index) {
//             case 0:
//               icon = Icons.home;
//               label = "Profile";
//               break;
//             case 1:
//               icon = Icons.fastfood;
//               label = "Orders";
//               break;
//             case 2:
//               icon = Icons.payment;
//               label = "Payment";
//               break;
//             case 3:
//               icon = Icons.security;
//               label = "Permissions";
//               break;
//             default:
//               icon = Icons.help;
//               label = "Unknown";
//           }
//           bool selected = index == currentIndex;
//           // Wrap only the icon and label in an InkWell.
//           return InkWell(
//             onTap: () => onTap(index),
//             borderRadius: BorderRadius.circular(16),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(icon, color: selected ? Colors.blueAccent : Colors.grey),
//                   const SizedBox(height: 4),
//                   Text(
//                     label,
//                     style: TextStyle(
//                       color: selected ? Colors.blueAccent : Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

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

  /// ✅ Lazily load pages only when needed using `PageController`
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  /// ✅ Ensure resources are cleaned up when widget is removed
  @override
  void dispose() {
    _pageController.dispose(); // Prevent memory leaks
    super.dispose();
  }

  /// ✅ App Bar with dynamic title
  PreferredSizeWidget _buildAppBar() {
    const titles = ["Profile", "Food Orders", "Payment", "Permissions"];
    return AppBar(
      title: Text(titles[_currentIndex]),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),

      /// ✅ Use `PageView` instead of `IndexedStack` to avoid keeping all screens in memory
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          ProfileScreen(),
          OrdersPage(),
          PaymentScreen(),
          PermissionsScreen(),
        ],
      ),

      /// ✅ Bottom Navigation Bar (Optimized)
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

/// ✅ Optimized Bottom Navigation Bar (Minimizes Rebuilds)
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
    const icons = [
      Icons.home,
      Icons.fastfood,
      Icons.payment,
      Icons.security,
    ];
    const labels = ["Profile", "Orders", "Payment", "Permissions"];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
          final isSelected = index == currentIndex;
          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icons[index], color: isSelected ? Colors.blueAccent : Colors.grey),
                  const SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.blueAccent : Colors.grey,
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
