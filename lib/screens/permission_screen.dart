import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  /// Helper method to request a specific permission.
  Future<void> _requestPermission(
      BuildContext context, Permission permission, String permissionName) async {
    final status = await permission.request();
    final message = status.isGranted
        ? "$permissionName permission granted"
        : "$permissionName permission denied";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Builds a card that displays the permission's icon, title, and a "Request" button.
  Widget _buildPermissionCard(
      BuildContext context, IconData icon, String title, Permission permission) {
    print('Building $title permission card');
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () => _requestPermission(context, permission, title),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text("Request"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Permissions Screen Build');
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
            // Existing permissions.
            _buildPermissionCard(context, Icons.camera_alt, "Camera", Permission.camera),
            _buildPermissionCard(context, Icons.storage, "Storage", Permission.storage),
            _buildPermissionCard(context, Icons.location_on, "Location", Permission.locationWhenInUse),
            // Additional permissions.
            _buildPermissionCard(context, Icons.contacts, "Contacts", Permission.contacts),
            _buildPermissionCard(context, Icons.mic, "Microphone", Permission.microphone),
            _buildPermissionCard(context, Icons.phone, "Phone", Permission.phone),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                "More permissions coming soon...",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
