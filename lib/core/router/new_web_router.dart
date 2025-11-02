import 'package:eshop/domain/entities/product/product.dart';
import 'package:eshop/presentation/views/new_web/delivery_info/delivery_info_new.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/cart/cart_item.dart';
import '../../presentation/views/new_web/new_web_landing_page_view.dart';
// Add new imports
import '../../presentation/views/new_web/products/new_web_products_view.dart';
import '../../presentation/views/new_web/product/new_web_product_details_view.dart';
import '../../presentation/views/new_web/cart/new_web_cart_view.dart';
import '../../presentation/views/new_web/checkout/new_web_checkout_view.dart';
import '../../presentation/views/new_web/categories/new_web_categories_view.dart';
import '../../presentation/views/new_web/orders/new_web_orders_view.dart';
import '../../presentation/views/new_web/wishlist/new_web_wishlist_view.dart';
import '../../presentation/views/new_web/profile/new_web_profile_view.dart';
import '../../presentation/views/new_web/search/new_web_search_view.dart';
import '../../presentation/views/new_web/auth/new_web_signin_view.dart';

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

  static const newDeliveryInfo = '/new-delivery-info';
}

/// New GoRouter configuration for the redesigned web app
/// This will be used once the new UI is complete
final GoRouter newWebRouter = GoRouter(
  initialLocation: NewWebRouter.newHome,
  routes: [
    GoRoute(
      name: NewWebRouter.newHome,
      path: NewWebRouter.newHome,
      builder: (context, state) => const NewWebLandingPageView(),
    ),
    GoRoute(
      name: NewWebRouter.newProducts,
      path: NewWebRouter.newProducts,
      builder: (context, state) => const NewWebProductsView(),
    ),
    GoRoute(
      name: NewWebRouter.newProductDetails,
      path: NewWebRouter.newProductDetails,
      builder: (context, state) {
        // Pass Product via state.extra
        return NewWebProductDetailsView(product: state.extra as Product);
      },
    ),
    GoRoute(
      name: NewWebRouter.newCart,
      path: NewWebRouter.newCart,
      builder: (context, state) => const NewWebCartView(),
    ),
    GoRoute(
      name: NewWebRouter.newCheckout,
      path: NewWebRouter.newCheckout,
      builder: (context, state) {
        final items = state.extra as List<CartItem>;
        return NewWebCheckoutView(items: items);
      },
    ),
    GoRoute(
      name: NewWebRouter.newProfile,
      path: NewWebRouter.newProfile,
      builder: (context, state) => const NewWebProfileView(),
    ),
    GoRoute(
      name: NewWebRouter.newSearch,
      path: NewWebRouter.newSearch,
      builder: (context, state) => NewWebSearchView(
        query: state.uri.queryParameters['q'] ?? '',
      ),
    ),
    GoRoute(
      name: NewWebRouter.newCategories,
      path: NewWebRouter.newCategories,
      builder: (context, state) => const NewWebCategoriesView(),
    ),
    GoRoute(
      name: NewWebRouter.newOrders,
      path: NewWebRouter.newOrders,
      builder: (context, state) => const NewWebOrdersView(),
    ),
    GoRoute(
      name: NewWebRouter.newWishlist,
      path: NewWebRouter.newWishlist,
      builder: (context, state) => const NewWebWishlistView(),
    ),
    // Auth placeholders (can reuse old views if needed)
    GoRoute(
      name: NewWebRouter.newSignIn,
      path: NewWebRouter.newSignIn,
      builder: (context, state) => const NewWebSignInView(),
    ),
    GoRoute(
      name: NewWebRouter.newSignUp,
      path: NewWebRouter.newSignUp,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Sign Up'))),
    ),

    GoRoute(
      path: NewWebRouter.newDeliveryInfo,
      name: NewWebRouter.newDeliveryInfo,
      builder: (context, state) => DeliveryInfoViewNew(),
    )
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
