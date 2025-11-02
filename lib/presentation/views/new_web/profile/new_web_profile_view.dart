import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/delivery_info/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../blocs/order/order_fetch/order_fetch_cubit.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/new_web_router.dart';

class NewWebProfileView extends StatelessWidget {
  const NewWebProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: const QiratHeaderWidget(showShadow: true),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final name = state is UserLogged ? state.user.firstName : 'Guest';
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                Text(
                  'Hi, $name',
                  style: const TextStyle(
                    color: QiratTheme.qiratGold,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                _SectionTile(
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Information',
                  subtitle: 'Manage your addresses',
                  onTap: () => context.goNamed(NewWebRouter.newDeliveryInfo),
                ),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLogged) {
                      return _SectionTile(
                        icon: Icons.receipt_long_outlined,
                        title: 'Orders',
                        subtitle: 'View order history and status',
                        onTap: () => context.goNamed(NewWebRouter.newOrders),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),


                // _SectionTile(
                //   icon: Icons.favorite_border,
                //   title: 'Wishlist',
                //   subtitle: 'Your saved products',
                //   onTap: () => context.goNamed(NewWebRouter.newWishlist),
                // ),
                const Divider(color: QiratTheme.borderDark, height: 24),
                _SectionTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Understand how we handle your data',
                  onTap: () => context.goNamed(NewWebRouter.newPrivacyPolicy),
                ),
                _SectionTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                  onTap: () => context.goNamed(NewWebRouter.newTerms),
                ),
                _SectionTile(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Learn how to request deletion',
                  onTap: () => context.goNamed(NewWebRouter.newDeleteAccount),
                ),
                const Divider(color: QiratTheme.borderDark, height: 24),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLogged) {
                      return _SectionTile(
                        icon: Icons.logout,
                        title: 'Sign Out',
                        subtitle: 'Sign out from this device',
                        onTap: () {
                          context.read<UserBloc>().add(SignOutUser());
                          context.read<CartBloc>().add(const ClearCart());
                          context
                              .read<DeliveryInfoFetchCubit>()
                              .clearLocalDeliveryInfo();
                          context.read<OrderFetchCubit>().clearLocalOrders();
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SectionTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: QiratTheme.darkSurface,
        border: Border.all(color: QiratTheme.goldBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: QiratTheme.qiratGold),
        title: Text(title,
            style: const TextStyle(
                color: QiratTheme.darkOnBackground,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: QiratTheme.textSecondary, fontFamily: 'Inter')),
        trailing:
            const Icon(Icons.chevron_right, color: QiratTheme.darkOnSurface),
        onTap: onTap,
      ),
    );
  }
}
