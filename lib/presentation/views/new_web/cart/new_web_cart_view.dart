import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../blocs/cart/cart_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebCartView extends StatelessWidget {
  const NewWebCartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: const QiratHeaderWidget(showShadow: true),
        body: Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getContentMaxWidth(context)),
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final items = state.cart;
                final total = items.fold<double>(
                    0,
                    (sum, e) =>
                        sum + (e.priceTag.price.toDouble() * e.quantity));
                if (items.isEmpty) {
                  return const Center(
                      child: Text('Your cart is empty',
                          style: TextStyle(fontFamily: 'Inter')));
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) {
                          final it = items[i];
                          return Container(
                            decoration: BoxDecoration(
                              color: QiratTheme.darkSurface,
                              border: Border.all(color: QiratTheme.goldBorder),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: it.product.images.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                          it.product.images.first,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover),
                                    )
                                  : const SizedBox(width: 56, height: 56),
                              title: Text(it.product.name,
                                  style: const TextStyle(fontFamily: 'Inter')),
                              subtitle: Text(
                                  '${it.priceTag.name} • ₹${it.priceTag.price}',
                                  style: const TextStyle(fontFamily: 'Inter')),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: QiratTheme.qiratGold),
                                    onPressed: () {
                                      var state = context.read<UserBloc>().state;
                                      var uid = "1";
                                      if (state is UserLogged) {
                                        uid = state.user.id;
                                      }
                                      if (it.quantity < 1) {
                                        context.read<CartBloc>().add(RemoveProduct(
                                            cartItem: CartItem(
                                                id: it!.id,
                                                product: it!.product,
                                                priceTag: it!.priceTag,
                                                quantity: it?.quantity ?? 1,
                                                uid: uid)));
                                      } else {
                                        context.read<CartBloc>().add(AddProduct(
                                            cartItem: CartItem(
                                                id: it!.id,
                                                product: it!.product,
                                                priceTag: it!.priceTag,
                                                quantity:
                                                (it?.quantity ?? 1) - 1,
                                                uid: uid)));
                                      }
                                    },
                                  ),
                                  Text('${it.quantity}',
                                      style:
                                          const TextStyle(fontFamily: 'Inter')),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: QiratTheme.qiratGold),
                                    onPressed: (){
                                      var state = context.read<UserBloc>().state;
                                      var uid = "1";
                                      if (state is UserLogged) {
                                        uid = state.user.id;
                                      }
                                      context.read<CartBloc>().add(AddProduct(
                                          cartItem: CartItem(
                                              id: it!.id,
                                              product: it!.product,
                                              priceTag: it!.priceTag,
                                              quantity:
                                              (it?.quantity ?? 1) + 1,
                                              uid: uid)));
                                    }
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Total: ₹$total',
                              style: const TextStyle(
                                color: QiratTheme.qiratGold,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                                fontSize: 18,
                              )),
                        ),
                        ElevatedButton(
                          onPressed: () => context.go(NewWebRouter.newCheckout),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
