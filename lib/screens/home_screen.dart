import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:new_app/screens/orders_screen.dart';
import 'package:new_app/screens/profile_screen.dart';
import 'package:new_app/screens/setting_screen.dart';
import 'payment_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _checkAndRequestPermissions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkAndRequestPermissions() async {
    var box = await Hive.openBox('permissions');

    List<Permission> permissions = [
      Permission.camera,
      Permission.storage,
      Permission.locationWhenInUse,
      Permission.contacts,
      Permission.microphone,
      Permission.phone,
    ];

    List<Permission> toRequest = [];
    List<Permission> permanentlyDenied = [];

    for (Permission permission in permissions) {
      PermissionStatus status = await permission.status;
      bool isGranted = box.get(permission.toString(), defaultValue: false);

      if (status.isGranted) {
        await box.put(permission.toString(), true);
      } else if (status.isPermanentlyDenied) {
        permanentlyDenied.add(permission);
      } else {
        toRequest.add(permission);
      }
    }

    if (toRequest.isNotEmpty) {
      Map<Permission, PermissionStatus> statuses = await toRequest.request();

      for (var entry in statuses.entries) {
        if (entry.value.isGranted) {
          await box.put(entry.key.toString(), true);
        } else if (entry.value.isPermanentlyDenied) {
          permanentlyDenied.add(entry.key);
        }
      }
    }

    if (permanentlyDenied.isNotEmpty) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "Some permissions were permanently denied. Please enable them in settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  /// **Handles smooth transitions between pages**
  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300), // Smooth transition
      curve: Curves.easeInOut, // Animation effect
    );

    setState(() {
      _currentIndex = index;
    });
  }

  PreferredSizeWidget _buildAppBar() {
    const titles = ["Profile", "Food Orders", "Payment", "Settings"];
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
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(), // ✅ Smooth sliding effect
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          ProfileScreen(),
          OrdersPage(),
          PaymentScreen(),
          settingScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // ✅ Calls animateToPage
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.person,
      Icons.fastfood,
      Icons.payment,
      Icons.settings,
    ];
    const labels = ["Profile", "Orders", "Payment", "Settings"];

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: onTap, // ✅ Calls _onTabTapped for smooth animation
      items: List.generate(4, (index) {
        return BottomNavigationBarItem(
          icon: Icon(icons[index]),
          label: labels[index],
        );
      }),
    );
  }
}
