import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'providers/providers.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/main/main_screen.dart';
import 'screens/home/search_screen.dart';
import 'screens/home/categories_screen.dart';
import 'screens/restaurant/restaurant_details_screen.dart';
import 'screens/restaurant/food_details_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/checkout/order_success_screen.dart';
import 'screens/checkout/tracking_screen.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const FoodlyApp(),
    ),
  );
}

class FoodlyApp extends StatelessWidget {
  const FoodlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Page<dynamic> _buildPageWithAnimation(Widget child, GoRouterState state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      );
    }

    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildPageWithAnimation(const SplashScreen(), state),
        ),
        GoRoute(
          path: '/onboarding',
          pageBuilder: (context, state) => _buildPageWithAnimation(const OnboardingScreen(), state),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => _buildPageWithAnimation(const LoginScreen(), state),
        ),
        GoRoute(
          path: '/signup',
          pageBuilder: (context, state) => _buildPageWithAnimation(const SignUpScreen(), state),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => _buildPageWithAnimation(const SearchScreen(), state),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (context, state) => _buildPageWithAnimation(const CategoriesScreen(), state),
        ),
        GoRoute(
          path: '/restaurant/:id',
          pageBuilder: (context, state) => _buildPageWithAnimation(RestaurantDetailsScreen(restaurantId: state.pathParameters['id']!), state),
        ),
        GoRoute(
          path: '/food/:id',
          pageBuilder: (context, state) => _buildPageWithAnimation(FoodDetailsScreen(foodId: state.pathParameters['id']!), state),
        ),
        GoRoute(
          path: '/checkout',
          pageBuilder: (context, state) => _buildPageWithAnimation(const CheckoutScreen(), state),
        ),
        GoRoute(
          path: '/order_success',
          pageBuilder: (context, state) => _buildPageWithAnimation(const OrderSuccessScreen(), state),
        ),
        GoRoute(
          path: '/tracking',
          pageBuilder: (context, state) => _buildPageWithAnimation(const TrackingScreen(), state),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Foodly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
