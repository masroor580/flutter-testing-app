import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  /// Helper method to request a specific permission.
  Future<void> _requestPermission(BuildContext context, Permission permission, String permissionName) async {
    final status = await permission.request();
    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$permissionName permission granted")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$permissionName permission denied")),
      );
    }
  }

  /// Builds a card that displays the permission's icon, title, and a "Request" button.
  Widget _buildPermissionCard(BuildContext context, IconData icon, String title, Permission permission) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Permissions"),
        backgroundColor: Colors.blueAccent,
      ),
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
            _buildPermissionCard(context, Icons.camera_alt, "Camera", Permission.camera),
            _buildPermissionCard(context, Icons.storage, "Storage", Permission.storage),
            _buildPermissionCard(context, Icons.location_on, "Location", Permission.locationWhenInUse),
            const SizedBox(height: 24),
            Center(
              child: Text(
                "More permissions coming soon...",
                style: TextStyle(color: Colors.grey[800], fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
