// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class PermissionsScreen extends StatelessWidget {
//   const PermissionsScreen({Key? key}) : super(key: key);
//
//   // Helper method to request a specific permission.
//   Future<void> _requestPermission(BuildContext context, Permission permission, String permissionName) async {
//     final status = await permission.request();
//     if (status.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("$permissionName permission granted")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("$permissionName permission denied")),
//       );
//     }
//   }
//
//
//
//   /// Builds a card that displays the permission's icon, title, and a "Request" button.
//   Widget _buildPermissionCard(BuildContext context, IconData icon, String title, Permission permission) {
//     print('Permission Card Build');
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(icon, size: 40, color: Colors.blueAccent),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () => _requestPermission(context, permission, title),
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 backgroundColor: Colors.blueAccent,
//               ),
//               child: const Text("Request"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Permission Screen Build');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("App Permissions"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Colors.blueAccent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: ListView(
//           padding: const EdgeInsets.symmetric(vertical: 24),
//           children: [
//             _buildPermissionCard(context, Icons.camera_alt, "Camera", Permission.camera),
//             _buildPermissionCard(context, Icons.storage, "Storage", Permission.storage),
//             _buildPermissionCard(context, Icons.location_on, "Location", Permission.locationWhenInUse),
//             const SizedBox(height: 24),
//             Center(
//               child: Text(
//                 "More permissions coming soon...",
//                 style: TextStyle(color: Colors.grey[800], fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Permissions Screen Build');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            PermissionCard(
              icon: Icons.camera_alt,
              title: "Camera",
              permission: Permission.camera,
            ),
            PermissionCard(
              icon: Icons.storage,
              title: "Storage",
              permission: Permission.manageExternalStorage,
            ), // Android 11+
            PermissionCard(
              icon: Icons.location_on,
              title: "Location",
              permission: Permission.locationWhenInUse,
            ),
            PermissionCard(
              icon: Icons.contacts,
              title: "Contacts",
              permission: Permission.contacts,
            ),
            PermissionCard(
              icon: Icons.mic,
              title: "Microphone",
              permission: Permission.microphone,
            ),
            PermissionCard(
              icon: Icons.phone,
              title: "Phone",
              permission: Permission.phone,
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                "More permissions coming soon...",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// **PermissionCard Widget**
class PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Permission permission;

  const PermissionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.permission,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () => _requestPermission(context, permission, title),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text("Request"),
            ),
          ],
        ),
      ),
    );
  }

  /// Request permission method
  Future<void> _requestPermission(BuildContext context, Permission permission,
      String permissionName) async {

    if (permission == Permission.manageExternalStorage) {
      // Handle Storage Permission Separately
      await _requestStoragePermission(context);
      return;
    }

    final status = await permission.request();

    if (status.isGranted) {
      _showSnackBar(context, "$permissionName permission granted", Colors.green);
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(context, permissionName);
    } else {
      _showSnackBar(context, "$permissionName permission denied", Colors.red);
    }
  }

  /// Separate function to handle storage permissions
  Future<void> _requestStoragePermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.status;

    // ✅ Show alert dialog if permission is denied
    if (status.isDenied) {
      bool? userResponse = await _showPermissionRequestDialog(context, "Storage");

      // If user cancels, do not request permission
      if (userResponse == null || !userResponse) return;
    }

    // 🛠 Request storage permission after user agrees
    status = await Permission.storage.request();

    if (status.isGranted) {
      _showSnackBar(context, "Storage permission granted!", Colors.green);
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(context, "Storage");
    } else {
      _showSnackBar(context, "Storage permission denied!", Colors.red);
    }
  }

  /// Show a dialog before requesting permission
  Future<bool?> _showPermissionRequestDialog(BuildContext context, String permissionName) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Allow $permissionName Access?"),
        content: Text("This permission is required for app functionality."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Deny"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }


  /// Show snackbar notification
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show dialog to redirect to app settings if permission is permanently denied
  void _showPermissionDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("$permissionName Permission Denied"),
        content: const Text("Please enable this permission manually in settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await openAppSettings(); // Open app settings
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
