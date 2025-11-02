import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constant/strings.dart';
import 'core/router/app_router.dart';
import 'core/router/new_web_router.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/qirat_theme.dart';
import 'domain/usecases/product/get_product_usecase.dart';
import 'firebase_options.dart';
import 'main.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/category/category_bloc.dart';
import 'presentation/blocs/delivery_info/delivery_info_action/delivery_info_action_cubit.dart';
import 'presentation/blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import 'presentation/blocs/filter/filter_cubit.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'core/services/services_locator.dart' as di;
import 'presentation/blocs/home/navbar_cubit.dart';
import 'presentation/blocs/order/order_fetch/order_fetch_cubit.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/user/user_bloc.dart';

/// Entry point for testing the new web UI
/// Use this temporarily to preview the new design

Future<void> main() async {
  // Error handling for the app
  setUrlStrategy(PathUrlStrategy()); // ✅ key for seeing URL

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await di.init();
    // await NotificationService.initialize();
    runApp(const NewWebTestApp());
    configLoading();
    FirebaseAnalytics.instance.logEvent(
      name: "AppOpenedCustom",
      parameters: {"signUpMethod": "Web"},
    );
  }, (error, stackTrace) async {
    // Log errors (Crashlytics can be re-added later)
    // await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // await FirebaseCrashlytics.instance.recordFlutterError(
    //   FlutterErrorDetails(exception: error, stack: stackTrace),
    // );
  });
}

class NewWebTestApp extends StatelessWidget {
  const NewWebTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavbarCubit(),
        ),
        BlocProvider(
          create: (context) => FilterCubit(),
        ),
        BlocProvider(
          create: (context) => di.sl<ProductBloc>()
            ..add(const GetProducts(FilterProductParams())),
        ),
        BlocProvider(
          create: (context) =>
              di.sl<CategoryBloc>()..add(const GetCategories()),
        ),
        BlocProvider(
          create: (context) => di.sl<CartBloc>()..add(const GetCart()),
        ),
        BlocProvider(
          create: (context) => di.sl<UserBloc>()..add(CheckUser()),
        ),
        BlocProvider(
          create: (context) => di.sl<DeliveryInfoActionCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              di.sl<DeliveryInfoFetchCubit>()..fetchDeliveryInfo(),
        ),
        BlocProvider(
          create: (context) => di.sl<OrderFetchCubit>()..getOrders(),
        ),
      ],
      child: OKToast(
          child: MaterialApp.router(
        title: 'Qirat Attars - New Web UI',
        debugShowCheckedModeBanner: false,
        theme: QiratTheme.darkTheme,
        routerConfig: newWebRouter,
        builder: EasyLoading.init(),
      )),
    );
  }
}
