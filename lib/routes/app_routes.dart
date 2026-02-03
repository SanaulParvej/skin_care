import 'package:flutter/material.dart';
import '../features/auth/views/forgot_password_screen.dart';
import '../features/auth/views/sign_in_screen.dart';
import '../features/auth/views/sign_up_screen.dart';
import '../features/home/views/main_bottom_nav.dart';
import '../features/notification/view/notification_screen.dart';
import '../features/onboarding/views/splash_screen.dart';
import '../features/onboarding/views/welcome_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const welcome = '/welcome';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const mainNav = '/main';
  static const notifications = '/notifications';

  static final routes = <String, WidgetBuilder>{
    splash: (_) => const SplashScreen(),
    welcome: (_) => const WelcomeScreen(),
    signIn: (_) => const SignInScreen(),
    signUp: (_) => const SignUpScreen(),
    forgotPassword: (_) => const ForgotPasswordScreen(),
    mainNav: (_) => const MainBottomNav(),
    notifications: (_) => const NotificationScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return null;
  }
}
