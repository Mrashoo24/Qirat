
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import all your views
import 'package:eshop/presentation/views/main/main_view.dart';
import 'package:eshop/presentation/views/authentication/signin_view.dart';
import 'package:eshop/presentation/views/authentication/signup_view.dart';
import 'package:eshop/presentation/views/product/product_details_view.dart';
import 'package:eshop/presentation/views/main/other/profile/profile_screen.dart';
import 'package:eshop/presentation/views/order_chekout/order_checkout_view.dart';
import 'package:eshop/presentation/views/main/other/delivery_info/delivery_info.dart';
import 'package:eshop/presentation/views/main/other/orders/order_view.dart';
import 'package:eshop/presentation/views/main/other/settings/settings_view.dart';
import 'package:eshop/presentation/views/main/other/terms/terms.dart';
import 'package:eshop/presentation/views/main/other/notification/notification_view.dart';
import 'package:eshop/presentation/views/main/other/about/about_view.dart';
import 'package:eshop/presentation/views/main/home/filter/filter_view.dart';
import 'package:eshop/presentation/views/main/home/productview.dart';
import 'package:eshop/presentation/views/main/home/searchView.dart';
import 'package:eshop/presentation/views/main/other/deleteAccount.dart';

// Entities
import '../../domain/entities/product/product.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/entities/cart/cart_item.dart';


class AppRouter {
  //main menu
  static const String home = '/';
  //authentication
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  //products
  static const String productDetails = '/product-details';
  //other
  static const String userProfile = '/user-profile';
  static const String orderCheckout = '/order-checkout';
  static const String deliveryDetails = '/delivery-details';
  static const String orders = '/orders';
  static const String settings = '/settings';
  static const String terms = '/terms';
  static const String notifications = '/notifications';
  static const String about = '/about';
  static const String filter = '/filter';
  static const String productPage = '/product-page';
  static const String deletePage = '/deleteAccountView';
static const String searchView = "/searchView";
  // static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
  //   switch (routeSettings.name) {
  //     case home:
  //       return MaterialPageRoute(builder: (_) => const MainView());
  //     case signIn:
  //       return MaterialPageRoute(builder: (_) => const SignInView());
  //     case signUp:
  //       return MaterialPageRoute(builder: (_) => const SignUpScreen());
  //     case productDetails:
  //       Product product = routeSettings.arguments as Product;
  //       return MaterialPageRoute(
  //           builder: (_) => ProductDetailsView(product: product));
  //     case userProfile:
  //       User user = routeSettings.arguments as User;
  //       return MaterialPageRoute(
  //           builder: (_) => UserProfileScreen(
  //                 user: user,
  //               ));
  //     case orderCheckout:
  //       List<CartItem> items = routeSettings.arguments as List<CartItem>;
  //       return MaterialPageRoute(
  //           builder: (_) => OrderCheckoutView(
  //                 items: items,
  //               ));
  //     case deliveryDetails:
  //       return MaterialPageRoute(builder: (_) => const DeliveryInfoView());
  //     case orders:
  //       return MaterialPageRoute(builder: (_) => const OrderView());
  //     case settings:
  //       return MaterialPageRoute(builder: (_) => const PrivacyPolicyView());
  //
  //     case terms:
  //       return MaterialPageRoute(builder: (_) => const TermsView());    case notifications:
  //       return MaterialPageRoute(builder: (_) => const ContactUsView());
  //     case about:
  //       return MaterialPageRoute(builder: (_) => const AboutView());
  //     case filter:
  //       return MaterialPageRoute(builder: (_) => const FilterView());
  //     case productPage:
  //       return MaterialPageRoute(builder: (_) => const ProductPageView());
  //     case deletePage:
  //       return MaterialPageRoute(builder: (_) => const DeleteAccountView());
  //     case searchView:
  //       return MaterialPageRoute(builder: (_) => const SearchView());
  //
  //     default:
  //       throw const RouteException('Route not found!');
  //   }
  // }
}

/// 🚀 GoRouter Configuration
final GoRouter router = GoRouter(
  routes: [
    // /// 🏠 Main Menu
    // GoRoute(
    //   name: AppRouter.home,
    //   path: '/',
    //   builder: (context, state) => const MainView(),
    // ),

    /// 🔐 Authentication
    GoRoute(
      name: AppRouter.signIn,
      path: '/sign-in',
      builder: (context, state) => const SignInView(),
    ),
    GoRoute(
      name: AppRouter.signUp,
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),

    /// 🛍️ Product Details
    GoRoute(
      name: AppRouter.productDetails,
      path: '/product-details',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailsView(product: product);
      },
    ),

    /// 🧩 Product Page
    GoRoute(
      name: AppRouter.productPage,
      path: '/product-page',
      builder: (context, state) => const ProductPageView(),
    ),

    /// 👤 User Profile
    GoRoute(
      name: AppRouter.userProfile,
      path: '/user-profile',
      builder: (context, state) {
        final user = state.extra as User;
        return UserProfileScreen(user: user);
      },
    ),

    /// ❌ Delete Account
    GoRoute(
      name: AppRouter.deletePage,
      path: '/deleteAccountView',
      builder: (context, state) => const DeleteAccountView(),
    ),

    /// 🧾 Order Checkout
    GoRoute(
      name: AppRouter.orderCheckout,
      path: '/order-checkout',
      builder: (context, state) {
        final items = state.extra as List<CartItem>;
        return OrderCheckoutView(items: items);
      },
    ),

    /// 🚚 Delivery Info
    GoRoute(
      name: AppRouter.deliveryDetails,
      path: '/delivery-details',
      builder: (context, state) => const DeliveryInfoView(),
    ),

    /// 📦 Orders
    GoRoute(
      name: AppRouter.orders,
      path: '/orders',
      builder: (context, state) => const OrderView(),
    ),

    /// ⚙️ Settings

    GoRoute(
        name: AppRouter.settings,
        path: '/settings',
        builder: (context, state) {
          final showAppBar = state.extra as bool?;
          return  PrivacyPolicyView(showAppBar : showAppBar);
        }
    ),

    /// 📄 Terms & Conditions
    GoRoute(
      name: AppRouter.terms,
      path: '/terms',
      builder: (context, state) {
        final showAppBar = state.extra as bool?;
        return  TermsView(showAppBar : showAppBar);
      }
    ),

    /// 🔔 Notifications
    GoRoute(
      name: AppRouter.notifications,
      path: '/notifications',
      builder: (context, state) => const ContactUsView(),
    ),

    /// ℹ️ About
    GoRoute(
      name: AppRouter.about,
      path: '/about',
      builder: (context, state) => const AboutView(),
    ),

    /// 🧩 Filter
    GoRoute(
      name: AppRouter.filter,
      path: '/filter',
      builder: (context, state) => const FilterView(),
    ),

    /// 🔍 Search
    GoRoute(
      name: AppRouter.searchView,
      path: '/searchView',
      builder: (context, state) => const SearchView(),
    ),
  ],
);
