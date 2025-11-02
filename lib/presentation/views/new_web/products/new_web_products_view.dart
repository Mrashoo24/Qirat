import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/filter/filter_cubit.dart';
import '../../../blocs/cart/cart_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebProductsView extends StatelessWidget {
  const NewWebProductsView({Key? key}) : super(key: key);

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
              maxWidth: ResponsiveHelper.getContentMaxWidth(context),
            ),
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final products = state.products;
                if (products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final crossCount = ResponsiveHelper.responsive(
                  context: context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 4,
                );
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (ctx, i) => _ProductCard(product: products[i]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(NewWebRouter.newProductDetails, extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: QiratTheme.darkSurface,
          border: Border.all(color: QiratTheme.goldBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.images.isNotEmpty
                    ? Image.network(product.images.first,
                        fit: BoxFit.cover, width: double.infinity)
                    : Container(color: QiratTheme.darkSurfaceVariant),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: QiratTheme.qiratGold,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            if (product.priceTags.isNotEmpty)
              Row(
                children: [
                  Text(
                    '₹${product.priceTags.first.price}',
                    style: const TextStyle(
                      color: QiratTheme.qiratGold,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      context.read<CartBloc>().add(AddProduct(
                            cartItem: CartItem(
                              id: 'tmp-${product.id}-${product.priceTags.first.id}',
                              product: product,
                              priceTag: product.priceTags.first,
                              quantity: 1,
                              uid: '1',
                            ),
                          ));
                    },
                    icon: const Icon(Icons.add_shopping_cart,
                        color: QiratTheme.qiratGold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
