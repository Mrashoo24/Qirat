import 'package:eshop/domain/entities/product/product.dart';
import 'package:eshop/presentation/views/new_web/checkout/checkutv2.dart';
import 'package:eshop/presentation/views/new_web/delivery_info/delivery_info_new.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/cart/cart_item.dart';
import '../../presentation/views/new_web/new_web_landing_page_view.dart';
// Add new imports
import '../../presentation/views/new_web/products/new_web_products_view.dart';
import '../../domain/entities/category/category.dart';
import '../../presentation/views/new_web/product/new_web_product_details_view.dart';
import '../../presentation/views/new_web/cart/new_web_cart_view.dart';
import '../../presentation/views/new_web/checkout/new_web_checkout_view.dart';
import '../../presentation/views/new_web/checkout/payment_return_view.dart';
import '../../presentation/views/new_web/categories/new_web_categories_view.dart';
import '../../presentation/views/new_web/orders/new_web_orders_view.dart';
import '../../presentation/views/new_web/wishlist/new_web_wishlist_view.dart';
import '../../presentation/views/new_web/profile/new_web_profile_view.dart';
import '../../presentation/views/new_web/search/new_web_search_view.dart';
import '../../presentation/views/new_web/auth/new_web_signin_view.dart';
import '../../core/analytics/app_analytics.dart';
import '../../presentation/views/new_web/static/new_web_privacy_view.dart';
import '../../presentation/views/new_web/static/new_web_terms_view.dart';
import '../../presentation/views/new_web/static/new_web_delete_account_view.dart';
import '../../presentation/views/new_web/story/new_web_our_story_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/blocs/order/order_add/order_add_cubit.dart';
import '../../presentation/blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../core/services/services_locator.dart';

// TODO: Uncomment these imports when implementing the actual views
// import '../../../domain/entities/product/product.dart';
// import '../../../domain/entities/user/user.dart';
// import '../../../domain/entities/cart/cart_item.dart';

/// New Web Router for the redesigned web application
/// Keeps existing routes separate to avoid conflicts
class NewWebRouter {
  // New Web Routes
  static const String newHome = '/home';
  static const String newProducts = '/products';
  static const String newProductDetails = '/product-details';
  static const String newCart = '/cart';
  static const String newCheckout = '/checkout';
  static const String newProfile = '/profile';
  static const String newSearch = '/search';
  static const String newCategories = '/categories';
  static const String newOrders = '/orders';
  static const String newWishlist = '/wishlist';
  static const String newPrivacyPolicy = '/privacy';
  static const String newTerms = '/terms';
  static const String newDeleteAccount = '/delete-account';
  static const String newOurStory = '/our-story';
  static const String paymentReturn = '/payment-return';

  // Authentication routes (new design)
  static const String newSignIn = '/new-sign-in';
  static const String newSignUp = '/new-sign-up';

  // Admin routes (if needed)
  static const String newAdmin = '/new-admin';
  static const String newDashboard = '/new-dashboard';

  static const newDeliveryInfo = '/new-delivery-info';

  static const checkoutv2 = '/checkout-payment';
}

/// New GoRouter configuration for the redesigned web app
/// This will be used once the new UI is complete
final GoRouter newWebRouter = GoRouter(
  initialLocation: NewWebRouter.newHome,
  observers: [_RouteAnalyticsObserver()],
  routes: [
    GoRoute(
      name: NewWebRouter.newHome,
      path: NewWebRouter.newHome,
      builder: (context, state) => const NewWebLandingPageView(),
    ),
    GoRoute(
      name: NewWebRouter.newProducts,
      path: NewWebRouter.newProducts,
      builder: (context, state) {
        final extra = state.extra;
        Category? category;
        String? categoryId;
        if (extra is Map && extra['category'] is Category) {
          category = extra['category'] as Category;
        }
        if (extra is Map && extra['categoryId'] is String) {
          categoryId = extra['categoryId'] as String;
        }
        final q = state.uri.queryParameters;
        categoryId = categoryId ?? q['catid'] ?? q['categoryId'];
        return NewWebProductsView(category: category, categoryId: categoryId);
      },
    ),
    GoRoute(
      name: NewWebRouter.newProductDetails,
      path: NewWebRouter.newProductDetails,
      builder: (context, state) {
        // Supports:
        // - state.extra as Product
        // - /new-product-details?prodid=ID or ?id=ID
        final extra = state.extra;
        if (extra is Product) {
          return NewWebProductDetailsView(product: extra);
        } else if (extra is Map && extra['id'] is String) {
          return NewWebProductDetailsLoader(productId: extra['id'].trim());
        }
        final q = state.uri.queryParameters;
        final prodId = q['prodid'] ?? q['id'];
        if (prodId != null && prodId.trim().isNotEmpty) {
          return NewWebProductDetailsLoader(productId: prodId.trim());
        }
        // No data -> go home
        Future.microtask(() => context.go(NewWebRouter.newHome));
        return const SizedBox.shrink();
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
        final extra = state.extra;
        if (extra is List<CartItem>) {
          return NewWebCheckoutView(items: extra);
        }
        if (extra is Map) {
          final rawItems = extra['items'];
          if (rawItems is List<CartItem>) {
            return NewWebCheckoutView(
              items: rawItems,
              source: (extra['source']?.toString() ?? 'cart').toLowerCase(),
            );
          }
        }

        // No data -> go home
        Future.microtask(() => context.go(NewWebRouter.newHome));
        return const SizedBox.shrink();
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
    GoRoute(
      name: NewWebRouter.newPrivacyPolicy,
      path: NewWebRouter.newPrivacyPolicy,
      builder: (context, state) => const NewWebPrivacyView(),
    ),
    GoRoute(
      name: NewWebRouter.newTerms,
      path: NewWebRouter.newTerms,
      builder: (context, state) => const NewWebTermsView(),
    ),
    GoRoute(
      name: NewWebRouter.newDeleteAccount,
      path: NewWebRouter.newDeleteAccount,
      builder: (context, state) => const NewWebDeleteAccountView(),
    ),
    GoRoute(
      name: NewWebRouter.newSignIn,
      path: NewWebRouter.newSignIn,
      builder: (context, state) => NewWebSignInView(flowPayload: state.extra),
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
      builder: (context, state) =>
          DeliveryInfoViewNew(flowPayload: state.extra),
    ),
    GoRoute(
      name: NewWebRouter.newOurStory,
      path: NewWebRouter.newOurStory,
      builder: (context, state) => const NewWebOurStoryView(),
    ),
    // Cashfree payment return URL landing page for web
    GoRoute(
      name: NewWebRouter.paymentReturn,
      path: NewWebRouter.paymentReturn,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<OrderAddCubit>()),
          BlocProvider(create: (_) => sl<DeliveryInfoFetchCubit>()),
        ],
        child: const PaymentReturnView(),
      ),
    ),
    GoRoute(
        path: NewWebRouter.checkoutv2,
        name: NewWebRouter.checkoutv2,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is Map) {
            final rawItems = extra['items'];
            if (rawItems is List<CartItem>) {
              return CheckoutViewV2(
                checkoutItems: rawItems,
                source: (extra['source']?.toString() ?? 'cart').toLowerCase(),
              );
            }
          }
          return const CheckoutViewV2();
        })
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

class _RouteAnalyticsObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      _log(newRoute);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _log(Route<dynamic> route) {
    final routeName = route.settings.name;
    final page = (routeName != null && routeName.isNotEmpty)
        ? routeName
        : route.runtimeType.toString();
    AppAnalytics.logPageView(page, pageClass: route.runtimeType.toString());
  }
}
