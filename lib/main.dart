// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'auth_services/auth_provider.dart';
// import 'auth_services/firebase_options.dart';
// import 'screens/signup_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/login_screen.dart';
// import 'controller/categories_controller.dart';
// import 'screens/orders_screen.dart';
// import 'services/notification_service.dart';
//
// /// Top-level background message handler.
// /// Must be a top-level function.
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('Handling a background message: ${message.messageId}');
// }
//
// /// Initializes Hive and opens necessary boxes.
// Future<void> _initializeHive() async {
//   await Hive.initFlutter();
//   try {
//     await Hive.openBox('authBox');
//   } catch (e) {
//     debugPrint("Hive initialization error: $e");
//   }
// }
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await _initializeHive();
//
//   // Register the background message handler.
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<AuthProvider>(
//           create: (_) => AuthProvider(),
//         ),
//         ChangeNotifierProvider<CategoryController>(
//           create: (_) => CategoryController(),
//         ),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print('MyApp build');
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // Wrap the initial screen with NotificationInitializer so that notifications are set up.
//       home: const NotificationInitializer(child: AuthWrapper()),
//       routes: {
//         '/signup': (context) => const SignUpScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/home': (context) => const MainHome(),
//         '/orders': (context) => const OrdersPage(),
//       },
//     );
//   }
// }
//
// /// NotificationInitializer initializes the notification service (which retrieves and prints the FCM token)
// /// and then displays its child.
// class NotificationInitializer extends StatefulWidget {
//   final Widget child;
//   const NotificationInitializer({Key? key, required this.child}) : super(key: key);
//
//   @override
//   State<NotificationInitializer> createState() => _NotificationInitializerState();
// }
//
// class _NotificationInitializerState extends State<NotificationInitializer> {
//   final NotificationService _notificationService = NotificationService();
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the notification service.
//     _notificationService.init(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print('AuthWrapper Build');
//
//     // Optimized listening to only specific values
//     final isLoading = context.select<AuthProvider, bool>((auth) => auth.isLoading);
//     final currentUser = context.select<AuthProvider, dynamic>((auth) => auth.currentUser);
//
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return currentUser != null ? const MainHome() : const LoginScreen();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'auth_services/auth_provider.dart';
import 'auth_services/firebase_options.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'controller/categories_controller.dart';
import 'screens/orders_screen.dart';
import 'services/notification_service.dart';

/// Background FCM handler (must be top-level)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('📩 Background message: ${message.messageId}');
}

/// Initializes Firebase & Hive before app launch
Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  try {
    await Hive.openBox('authBox');
  } catch (e) {
    debugPrint("❌ Hive initialization error: $e");
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

void main() async {
  await _initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('⚡ MyApp build');

    return MultiProvider(
      providers: _buildProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const NotificationInitializer(child: AuthWrapper()),
        routes: {
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainHome(),
          '/orders': (context) => const OrdersPage(),
        },
      ),
    );
  }

  /// Registers all providers
  List<ChangeNotifierProvider> _buildProviders() {
    return [
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<CategoryController>(create: (_) => CategoryController()),
    ];
  }
}

/// Handles Firebase notifications and FCM token retrieval
class NotificationInitializer extends StatefulWidget {
  final Widget child;
  const NotificationInitializer({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificationInitializer> createState() => _NotificationInitializerState();
}

class _NotificationInitializerState extends State<NotificationInitializer> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child; // No debugPrint here to avoid excessive logs
  }
}

/// Manages authentication state & navigation
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 AuthWrapper Build');

    return Selector<AuthProvider, bool>(
      selector: (_, auth) => auth.isLoading, // Only listens to `isLoading`
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Selector<AuthProvider, bool>(
          selector: (_, auth) => auth.currentUser != null, // Only listens to `currentUser`
          builder: (context, isLoggedIn, child) {
            return isLoggedIn ? const MainHome() : const LoginScreen();
          },
        );
      },
    );
  }
}
