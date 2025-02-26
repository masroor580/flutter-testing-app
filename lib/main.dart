// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth_provider.dart';
// import 'user_provider.dart';
// import 'firebase_options.dart';
// import 'signup_screen.dart';
// import 'home_screen.dart';
//
// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await Hive.initFlutter();
//   await Hive.openBox('userBox'); // Ensure the box is opened before use
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print("Main Build");
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AuthWrapper(),
//     );
//   }
// }
//
//
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print("Auth Wrapper build");
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         if (authProvider.isLoading) {
//           return const Scaffold(body: Center(child: CircularProgressIndicator()));
//         } else if (authProvider.user != null) {
//           return HomeScreen();
//         } else {
//           return SignUpScreen();
//         }
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth_provider.dart';
// import 'user_provider.dart';
// import 'firebase_options.dart';
// import 'signup_screen.dart';
// import 'home_screen.dart';
// import 'login_screen.dart'; // Add login screen import
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await _initializeHive();
//   final authProvider = AuthProvider();
//   await authProvider._checkUserLogin(); // Check user login status on startup
//
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(), lazy: false),
//         ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider(), lazy: false),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// Future<void> _initializeHive() async {
//   await Hive.initFlutter();
//   try {
//     await Hive.openBox('userBox');
//   } catch (e) {
//     debugPrint("Hive initialization error: $e");
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/', // Set initial route
//       routes: {
//         '/': (context) => const AuthWrapper(),
//         '/signup': (context) => const SignUpScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/home': (context) => const HomeScreen(),
//       },
//     );
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();
//
//     if (authProvider.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     } else if (authProvider.user != null) {
//       return const HomeScreen();
//     } else {
//       return const SignUpScreen();
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth_provider.dart';
// import 'firebase_options.dart';
// import 'signup_screen.dart';
// import 'home_screen.dart';
// import 'login_screen.dart';
// import 'controller/categories_controller.dart';
// import 'models/food_api_categories_data_model.dart';
// import 'repository/category_repository.dart';
// import 'orders_page.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await _initializeHive(); // ✅ Initialize Hive
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider(),
//         ), // ✅ Removed UserProvider
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// /// ✅ Initialize Hive & ensure the authBox is ready
// Future<void> _initializeHive() async {
//   await Hive.initFlutter();
//   try {
//     await Hive.openBox('authBox'); // ✅ Ensure the box is open
//   } catch (e) {
//     debugPrint("Hive initialization error: $e");
//   }
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     print('Myapp build');
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const AuthWrapper(), // ✅ Decides which screen to load
//       routes: {
//         '/signup': (context) => const SignUpScreen(),
//         '/login': (context) => const LoginScreen(),
//         '/home': (context) => const HomeScreen(),
//       },
//     );
//   }
// }
//
// /// ✅ Ensures a seamless experience on app startup
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = context.watch<AuthProvider>();
//
//     if (authProvider.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//
//     // ✅ If user is logged in but Firestore data is still loading, show home with cached data
//     if (authProvider.firebaseUser != null && authProvider.currentUser == null) {
//       return const HomeScreen(); // Show HomeScreen while fetching data
//     }
//
//     return authProvider.currentUser != null ? const HomeScreen() : const SignUpScreen();
//   }
// }



import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'firebase_options.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'controller/categories_controller.dart';
import 'orders_page.dart';
import 'services/notification_service.dart';

/// Top-level background message handler.
/// Must be a top-level function.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

/// Initializes Hive and opens necessary boxes.
Future<void> _initializeHive() async {
  await Hive.initFlutter();
  try {
    await Hive.openBox('authBox');
  } catch (e) {
    debugPrint("Hive initialization error: $e");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _initializeHive();

  // Register the background message handler.
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<CategoryController>(
          create: (_) => CategoryController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('MyApp build');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Wrap the initial screen with NotificationInitializer so that notifications are set up.
      home: const NotificationInitializer(child: AuthWrapper()),
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/orders': (context) => const OrdersPage(),
      },
    );
  }
}

/// NotificationInitializer initializes the notification service (which retrieves and prints the FCM token)
/// and then displays its child.
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
    // Initialize the notification service.
    _notificationService.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// AuthWrapper checks the authentication state (using your AuthProvider)
/// and shows the HomeScreen if a user is logged in, or the LoginScreen otherwise.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return authProvider.currentUser != null ? const HomeScreen() : const LoginScreen();
  }
}
