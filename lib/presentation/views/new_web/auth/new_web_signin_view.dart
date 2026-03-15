import 'package:eshop/core/router/new_web_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/constant/images.dart';
import '../../../../core/router/app_router.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/home/navbar_cubit.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';
import '../../../widgets/input_form_button.dart';
import 'package:eshop/data/models/user/user_model.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../../core/analytics/app_analytics.dart';

class NewWebSignInView extends StatefulWidget {
  final Object? flowPayload;
  const NewWebSignInView({Key? key, this.flowPayload}) : super(key: key);

  @override
  State<NewWebSignInView> createState() => _NewWebSignInViewState();
}

class _NewWebSignInViewState extends State<NewWebSignInView> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLogged) {
            // Preserve legacy behavior
            context.read<CartBloc>().add(const GetCart());
            try {
              context.read<NavbarCubit>().update(0);
            } catch (_) {}
            _handlePostLoginRedirect(context, state);
          }
        },
        child: Scaffold(
          backgroundColor: QiratTheme.darkBackground,
          appBar: const QiratHeaderWidget(showShadow: true),
          body: Center(
            child: Padding(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.getContentMaxWidth(context) < 560
                      ? ResponsiveHelper.getContentMaxWidth(context)
                      : 560,
                ),
                child: _buildCard(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        border: Border.all(color: QiratTheme.goldBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          SizedBox(
            height: 120,
            child: Image.asset(kAppLogo),
          ),
          const SizedBox(height: 24),

          // Google Sign-In (kept exactly as legacy flow triggers SignInUser without credentials)
          InkWell(
            onTap: () {
              // Match legacy behavior: dispatch SignInUser with placeholder user model
              context.read<UserBloc>().add(SignInUser(
                    UserModel(
                      id: 'id',
                      firstName: 'firstName',
                      lastName: 'lastName',
                      email: 'email',
                      token: '',
                    ),
                  ));
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 64,
              width: double.infinity,
              decoration: BoxDecoration(
                color: QiratTheme.darkSurfaceVariant,
                border: Border.all(color: QiratTheme.goldBorder),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/other_images/google_signin.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: QiratTheme.borderDark),
          const SizedBox(height: 16),

          // Back button identical behavior
          SizedBox(
            width: double.infinity,
            child: InputFormButton(
              color: QiratTheme.qiratGold,
              onClick: () => context.pop(),
              titleText: 'Back',
            ),
          ),
        ],
      ),
    );
  }

  void _handlePostLoginRedirect(BuildContext context, UserLogged state) {
    final payload = widget.flowPayload;
    if (payload is! Map) {
      context.goNamed(NewWebRouter.newHome);
      return;
    }

    final nextRoute = payload['nextRoute']?.toString();
    final source = (payload['source']?.toString() ?? 'cart').toLowerCase();
    final requiresDelivery = payload['requiresDelivery'] == true;
    final rawItems = payload['items'];
    final items = rawItems is List<CartItem> ? rawItems : <CartItem>[];

    if (requiresDelivery && state.user.deliveryInfos.isEmpty) {
      AppAnalytics.logAuthSuccessRedirect(
          destination: NewWebRouter.newDeliveryInfo);
      context.go(
        NewWebRouter.newDeliveryInfo,
        extra: {
          'flow': 'checkout',
          'source': source,
          'nextRoute': nextRoute ?? NewWebRouter.checkoutv2,
          'items': items,
        },
      );
      return;
    }

    if (nextRoute != null && nextRoute.isNotEmpty) {
      AppAnalytics.logAuthSuccessRedirect(destination: nextRoute);
      context.go(
        nextRoute,
        extra: {
          'source': source,
          'items': items,
        },
      );
      return;
    }

    AppAnalytics.logAuthSuccessRedirect(destination: NewWebRouter.newHome);
    context.goNamed(NewWebRouter.newHome);
  }
}
