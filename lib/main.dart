import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constant/strings.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/usecases/product/get_product_usecase.dart';
import 'firebase_options.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/category/category_bloc.dart';
import 'presentation/blocs/delivery_info/delivery_info_action/delivery_info_action_cubit.dart';
import 'presentation/blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import 'presentation/blocs/filter/filter_cubit.dart';

import 'core/services/services_locator.dart' as di;
import 'presentation/blocs/home/navbar_cubit.dart';
import 'presentation/blocs/order/order_fetch/order_fetch_cubit.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/user/user_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print("Handling a background message: ${message.messageId}");
}

// Android notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);

Future<void> main() async {

  // Error handling for the app
  // Run your app in the same zone
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    // Initialize local notifications for Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Initialize Firebase Messaging
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize local notifications settings
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await di.init();
    runApp(const MyApp());
    configLoading();
    FirebaseAnalytics.instance.logEvent(name:"AppOpenedCustom",parameters: {"signUpMethod":"Web"});
  }, (error, stackTrace) async {
    // Log errors to Crashlytics
    // await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    // await FirebaseCrashlytics.instance.recordFlutterFatalError(FlutterErrorDetails(exception: error,stack: stackTrace));
    // await FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(exception: error,stack: stackTrace));

  });

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // Display local notification
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

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
          create: (context) => di.sl<DeliveryInfoFetchCubit>()..fetchDeliveryInfo(),
        ),
        BlocProvider(
          create: (context) => di.sl<OrderFetchCubit>()..getOrders(),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouter.home,
          onGenerateRoute: AppRouter.onGenerateRoute,
          title: appTitle,
          theme: AppTheme.lightTheme,
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = true;
}
