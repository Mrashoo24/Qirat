import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../blocs/order/order_fetch/order_fetch_cubit.dart';
import '../../../blocs/user/user_bloc.dart';

/// Fixed Header Navigation Bar for Qirat Website
class QiratHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showShadow;
  final VoidCallback? onCartTap;
  final VoidCallback? onMenuTap;

  const QiratHeaderWidget({
    Key? key,
    this.showShadow = true,
    this.onCartTap,
    this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: QiratTheme.darkBackground,
        border: Border(
          bottom: BorderSide(color: QiratTheme.borderDark, width: 1),
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: ResponsiveHelper.responsive(
            context: context,
            mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: ResponsiveLayout(
            mobileLayout: _buildMobileLayout(context),
            desktopLayout: _buildDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final ishome =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            NewWebRouter.newHome;
    return Row(
      children: [
        // Back button (always visible on mobile)
        ishome ? SizedBox() :  IconButton(
          tooltip: 'Back',
          onPressed: ishome
              ? null
              : () {
                  if (Navigator.canPop(context)) {
                    context.pop();
                  } else {
                    context.go(NewWebRouter.newHome);
                  }
                },
          icon: const Icon(Icons.arrow_back_ios_new,
              color: QiratTheme.darkOnSurface, size: 22),
        ),
        const SizedBox(width: 4),
        // Clickable logo -> Home
        _buildLogoButton(context),
        const Spacer(),
        IconButton(
          onPressed: () => context.go(NewWebRouter.newSearch),
          icon: const Icon(Icons.search,
              color: QiratTheme.darkOnSurface, size: 24),
        ),
        _buildCartButton(context),
        IconButton(
          onPressed: () => _openMobileMenu(context),
          icon: const Icon(Icons.menu, color: QiratTheme.qiratGold, size: 28),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Clickable logo -> Home
        _buildLogoButton(context),
        const Spacer(),
        _buildNavigation(context),
        const SizedBox(width: 32),
        IconButton(
          onPressed: () => context.go(NewWebRouter.newSearch),
          icon: const Icon(Icons.search,
              color: QiratTheme.darkOnSurface, size: 24),
        ),
        _buildCartButton(context),
        IconButton(
          onPressed: () => context.go(NewWebRouter.newProfile),
          icon: const Icon(Icons.person,
              color: QiratTheme.darkOnSurface, size: 24),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Qirat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: QiratTheme.qiratGold,
              fontFamily: 'Inter',
              letterSpacing: 1.2,
            ),
          ),
          TextSpan(
            text: ' Attars',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: QiratTheme.darkOnSurface,
              fontFamily: 'Inter',
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoButton(BuildContext context) {
    return InkWell(
      onTap: () => context.go(NewWebRouter.newHome),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: _buildLogo(),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Row(
      children: [
        _buildNavItem('Home', true,
            onTap: () => context.go(NewWebRouter.newHome)),
        const SizedBox(width: 32),
        _buildCategoriesMenu(context),
        const SizedBox(width: 32),
        _buildNavItem('Our Story', false),
        const SizedBox(width: 32),
        _buildNavItem('Contact', false),
      ],
    );
  }

  Widget _buildNavItem(String text, bool isActive, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: isActive
            ? BoxDecoration(
                color: QiratTheme.darkSurfaceVariant,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: QiratTheme.darkOnSurface,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesMenu(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final categories =
            (state is CategoryLoaded || state is CategoryCacheLoaded)
                ? state.categories
                : const [];

        return PopupMenuButton<int>(
          tooltip: 'Products',
          color: QiratTheme.darkSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: QiratTheme.goldBorder),
          ),
          position: PopupMenuPosition.under,
          onSelected: (i) {
            if (i == -1) {
              context.go(NewWebRouter.newProducts);
            } else {
              final cat = categories[i];
              context.go(NewWebRouter.newProducts, extra: {'category': cat});
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem<int>(
              value: -1,
              child:
                  Text('All Products', style: TextStyle(fontFamily: 'Inter')),
            ),
            const PopupMenuDivider(height: 4),
            ...List.generate(categories.length, (i) {
              final c = categories[i];
              return PopupMenuItem<int>(
                value: i,
                child: Row(
                  children: [
                    if (c.image.isNotEmpty)
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(c.image),
                        backgroundColor: Colors.transparent,
                      ),
                    if (c.image.isNotEmpty) const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Inter'),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          child: _buildNavItem('Products', false),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);

  Widget _buildCartButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final count = state.cart.isEmpty
            ? 0
            : state.cart.fold<int>(0, (sum, item) => sum + item.quantity);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () => context.go(NewWebRouter.newCart),
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: QiratTheme.darkOnSurface,
                size: 24,
              ),
            ),
            if (count > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: QiratTheme.qiratGold,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: QiratTheme.goldBorder, width: 1),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _openMobileMenu(BuildContext context) {
    final parentContext = context;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(ctx).size.width * 0.85,
              height: MediaQuery.of(ctx).size.height,
              decoration: BoxDecoration(
                color: QiratTheme.darkSurface,
                border: Border(left: BorderSide(color: QiratTheme.goldBorder)),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.menu, color: QiratTheme.qiratGold),
                          const SizedBox(width: 8),
                          const Text(
                            'Menu',
                            style: TextStyle(
                              color: QiratTheme.darkOnBackground,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(Icons.close,
                                color: QiratTheme.darkOnSurface),
                          )
                        ],
                      ),
                    ),
                    const Divider(color: QiratTheme.borderDark, height: 1),
                    Expanded(
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, userState) {
                          return ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            children: [
                              if (userState is UserLogged)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 8),
                                  child: Text(
                                    'Hi, ${userState.user.firstName}',
                                    style: const TextStyle(
                                      color: QiratTheme.qiratGold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              if (userState is! UserLogged)
                                _buildSideTile(
                                  icon: Icons.login,
                                  title: 'Sign In',
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                    parentContext.go(NewWebRouter.newSignIn);
                                  },
                                ),
                              _buildSideTile(
                                icon: Icons.home_outlined,
                                title: 'Home',
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  parentContext.go(NewWebRouter.newHome);
                                },
                              ),
                              _buildSideTile(
                                icon: Icons.shopping_bag_outlined,
                                title: 'Products',
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  parentContext.go(NewWebRouter.newProducts);
                                },
                              ),
                              BlocBuilder<CategoryBloc, CategoryState>(
                                builder: (context, catState) {
                                  final cats = (catState is CategoryLoaded ||
                                          catState is CategoryCacheLoaded)
                                      ? catState.categories
                                      : const [];
                                  if (cats.isEmpty)
                                    return const SizedBox.shrink();
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 12, top: 8, bottom: 4),
                                        child: Text(
                                          'Categories',
                                          style: TextStyle(
                                            color: QiratTheme.textSecondary,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      ...cats
                                          .take(10)
                                          .map((c) => _buildSideTile(
                                                icon: Icons.label_outline,
                                                title: c.name,
                                                onTap: () {
                                                  Navigator.of(ctx).pop();
                                                  parentContext.go(
                                                      NewWebRouter.newProducts,
                                                      extra: {'category': c});
                                                },
                                              )),
                                      if (cats.length > 10)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, bottom: 8),
                                          child: Text(
                                              '+ ${cats.length - 10} more',
                                              style: const TextStyle(
                                                  color:
                                                      QiratTheme.textSecondary,
                                                  fontFamily: 'Inter',
                                                  fontSize: 12)),
                                        )
                                    ],
                                  );
                                },
                              ),
                              _buildSideTile(
                                icon: Icons.search,
                                title: 'Search',
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  parentContext.go(NewWebRouter.newSearch);
                                },
                              ),
                              if (userState is UserLogged)
                                _buildSideTile(
                                  icon: Icons.receipt_long_outlined,
                                  title: 'Orders',
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                    parentContext.go(NewWebRouter.newOrders);
                                  },
                                ),
                              if (userState is UserLogged)
                                _buildSideTile(
                                  icon: Icons.location_on_outlined,
                                  title: 'Delivery Info',
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                    parentContext
                                        .go(NewWebRouter.newDeliveryInfo);
                                  },
                                ),
                              _buildSideTile(
                                icon: Icons.privacy_tip_outlined,
                                title: 'Privacy Policy',
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  parentContext
                                      .go(NewWebRouter.newPrivacyPolicy);
                                },
                              ),
                              _buildSideTile(
                                icon: Icons.description_outlined,
                                title: 'Terms & Conditions',
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  parentContext.go(NewWebRouter.newTerms);
                                },
                              ),
                              _buildSideTile(
                                icon: Icons.delete_outline,
                                title: 'Delete Account',
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  parentContext
                                      .go(NewWebRouter.newDeleteAccount);
                                },
                              ),
                              const Divider(color: QiratTheme.borderDark),
                              if (userState is UserLogged)
                                _buildSideTile(
                                  icon: Icons.logout,
                                  title: 'Sign Out',
                                  onTap: () {
                                    parentContext
                                        .read<UserBloc>()
                                        .add(SignOutUser());
                                    parentContext
                                        .read<CartBloc>()
                                        .add(const ClearCart());
                                    parentContext
                                        .read<DeliveryInfoFetchCubit>()
                                        .clearLocalDeliveryInfo();
                                    parentContext
                                        .read<OrderFetchCubit>()
                                        .clearLocalOrders();
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim, secAnim, child) {
        final offsetAnim =
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(anim);
        return SlideTransition(position: offsetAnim, child: child);
      },
    );
  }

  Widget _buildSideTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: QiratTheme.darkSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: QiratTheme.goldBorder),
      ),
      child: ListTile(
        leading: Icon(icon, color: QiratTheme.qiratGold),
        title: Text(
          title,
          style: const TextStyle(
            color: QiratTheme.darkOnBackground,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing:
            const Icon(Icons.chevron_right, color: QiratTheme.darkOnSurface),
        onTap: onTap,
      ),
    );
  }
}
