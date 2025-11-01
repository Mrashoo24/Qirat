import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/new_web/new_web_landing_page_view.dart';

// TODO: Uncomment these imports when implementing the actual views
// import '../../../domain/entities/product/product.dart';
// import '../../../domain/entities/user/user.dart';
// import '../../../domain/entities/cart/cart_item.dart';

/// New Web Router for the redesigned web application
/// Keeps existing routes separate to avoid conflicts
class NewWebRouter {
  // New Web Routes
  static const String newHome = '/new-home';
  static const String newProducts = '/new-products';
  static const String newProductDetails = '/new-product-details';
  static const String newCart = '/new-cart';
  static const String newCheckout = '/new-checkout';
  static const String newProfile = '/new-profile';
  static const String newSearch = '/new-search';
  static const String newCategories = '/new-categories';
  static const String newOrders = '/new-orders';
  static const String newWishlist = '/new-wishlist';

  // Authentication routes (new design)
  static const String newSignIn = '/new-sign-in';
  static const String newSignUp = '/new-sign-up';

  // Admin routes (if needed)
  static const String newAdmin = '/new-admin';
  static const String newDashboard = '/new-dashboard';
}

/// New GoRouter configuration for the redesigned web app
/// This will be used once the new UI is complete
final GoRouter newWebRouter = GoRouter(
  initialLocation: NewWebRouter.newHome,
  routes: [
    /// 🏠 New Home
    GoRoute(
      name: NewWebRouter.newHome,
      path: NewWebRouter.newHome,
      builder: (context, state) => const NewWebLandingPageView(),
    ),

    /// 🛍️ New Products
    GoRoute(
      name: NewWebRouter.newProducts,
      path: NewWebRouter.newProducts,
      builder: (context, state) {
        // TODO: Replace with NewWebProductsView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Products - Coming Soon'),
          ),
        );
      },
    ),

    /// 📱 New Product Details
    GoRoute(
      name: NewWebRouter.newProductDetails,
      path: '${NewWebRouter.newProductDetails}/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        // final product = state.extra as Product?; // TODO: Use when implementing view
        // TODO: Replace with NewWebProductDetailsView when created
        return Scaffold(
          body: Center(
            child: Text('New Web Product Details - Product ID: $productId'),
          ),
        );
      },
    ),

    /// 🛒 New Cart
    GoRoute(
      name: NewWebRouter.newCart,
      path: NewWebRouter.newCart,
      builder: (context, state) {
        // TODO: Replace with NewWebCartView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Cart - Coming Soon'),
          ),
        );
      },
    ),

    /// 🧾 New Checkout
    GoRoute(
      name: NewWebRouter.newCheckout,
      path: NewWebRouter.newCheckout,
      builder: (context, state) {
        // final items = state.extra as List<CartItem>?; // TODO: Use when implementing view
        // TODO: Replace with NewWebCheckoutView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Checkout - Coming Soon'),
          ),
        );
      },
    ),

    /// 👤 New Profile
    GoRoute(
      name: NewWebRouter.newProfile,
      path: NewWebRouter.newProfile,
      builder: (context, state) {
        // final user = state.extra as User?; // TODO: Use when implementing view
        // TODO: Replace with NewWebProfileView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Profile - Coming Soon'),
          ),
        );
      },
    ),

    /// 🔍 New Search
    GoRoute(
      name: NewWebRouter.newSearch,
      path: NewWebRouter.newSearch,
      builder: (context, state) {
        final query = state.uri.queryParameters['q'];
        // TODO: Replace with NewWebSearchView when created
        return Scaffold(
          body: Center(
            child: Text('New Web Search - Query: ${query ?? ""}'),
          ),
        );
      },
    ),

    /// 📂 New Categories
    GoRoute(
      name: NewWebRouter.newCategories,
      path: NewWebRouter.newCategories,
      builder: (context, state) {
        // TODO: Replace with NewWebCategoriesView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Categories - Coming Soon'),
          ),
        );
      },
    ),

    /// 📦 New Orders
    GoRoute(
      name: NewWebRouter.newOrders,
      path: NewWebRouter.newOrders,
      builder: (context, state) {
        // TODO: Replace with NewWebOrdersView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Orders - Coming Soon'),
          ),
        );
      },
    ),

    /// ❤️ New Wishlist
    GoRoute(
      name: NewWebRouter.newWishlist,
      path: NewWebRouter.newWishlist,
      builder: (context, state) {
        // TODO: Replace with NewWebWishlistView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Wishlist - Coming Soon'),
          ),
        );
      },
    ),

    /// 🔐 New Sign In
    GoRoute(
      name: NewWebRouter.newSignIn,
      path: NewWebRouter.newSignIn,
      builder: (context, state) {
        // TODO: Replace with NewWebSignInView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Sign In - Coming Soon'),
          ),
        );
      },
    ),

    /// 📝 New Sign Up
    GoRoute(
      name: NewWebRouter.newSignUp,
      path: NewWebRouter.newSignUp,
      builder: (context, state) {
        // TODO: Replace with NewWebSignUpView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Sign Up - Coming Soon'),
          ),
        );
      },
    ),

    /// 👨‍💼 New Admin
    GoRoute(
      name: NewWebRouter.newAdmin,
      path: NewWebRouter.newAdmin,
      builder: (context, state) {
        // TODO: Replace with NewWebAdminView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Admin - Coming Soon'),
          ),
        );
      },
    ),

    /// 📊 New Dashboard
    GoRoute(
      name: NewWebRouter.newDashboard,
      path: NewWebRouter.newDashboard,
      builder: (context, state) {
        // TODO: Replace with NewWebDashboardView when created
        return const Scaffold(
          body: Center(
            child: Text('New Web Dashboard - Coming Soon'),
          ),
        );
      },
    ),
  ],

  // Error handling
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.toString()}" could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(NewWebRouter.newHome),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  },
);
