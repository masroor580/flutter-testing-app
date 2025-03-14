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
    await Hive.openBox('authBox'); // ✅ Open Hive box for user data
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
        home: const NotificationInitializer(child: AuthWrapper()), // ✅ Use AuthWrapper
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
      // ✅ Auto-check login
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
      selector: (_, auth) => auth.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Selector<AuthProvider, bool>(
          selector: (_, auth) => auth.currentUser != null,
          builder: (context, isLoggedIn, child) {
            return isLoggedIn ? const MainHome() : const LoginScreen(); // ✅ Persistent login check
          },
        );
      },
    );
  }
}