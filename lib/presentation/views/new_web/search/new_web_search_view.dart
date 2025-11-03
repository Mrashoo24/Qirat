import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../../domain/usecases/product/get_product_usecase.dart';

class NewWebSearchView extends StatefulWidget {
  final String query;
  const NewWebSearchView({Key? key, required this.query}) : super(key: key);

  @override
  State<NewWebSearchView> createState() => _NewWebSearchViewState();
}

class _NewWebSearchViewState extends State<NewWebSearchView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    final productState = context.read<ProductBloc>().state;
    if (productState.products.isEmpty) {
      // Load products with initial keyword (server-side filter if supported)
      context
          .read<ProductBloc>()
          .add(GetProducts(FilterProductParams(keyword: widget.query)));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final kw = _controller.text.trim();
    context
        .read<ProductBloc>()
        .add(GetProducts(FilterProductParams(keyword: kw)));
    setState(() {});
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      final kw = _controller.text.trim().toLowerCase();
                      List<Product> results = state.products;
                      if (kw.isNotEmpty) {
                        results = results
                            .where((p) => p.name.toLowerCase().contains(kw))
                            .toList();
                      }
                      if (state is ProductLoading && results.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (results.isEmpty) {
                        return Center(
                          child: Text(
                            'No results for "${_controller.text}"',
                            style: const TextStyle(fontFamily: 'Inter'),
                          ),
                        );
                      }

                      final cross = ResponsiveHelper.responsive(
                        context: context,
                        mobile: 2,
                        tablet: 3,
                        desktop: 4,
                      );
                      return GridView.builder(
                        itemCount: results.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cross,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (_, i) =>
                            _SearchProductCard(product: results[i]),
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
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (_) => _submitSearch(),
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: QiratTheme.darkOnBackground),
            decoration: InputDecoration(
              hintText: 'Search products',
              hintStyle: const TextStyle(color: QiratTheme.textSecondary),
              prefixIcon:
                  const Icon(Icons.search, color: QiratTheme.textSecondary),
              filled: true,
              fillColor: QiratTheme.darkSurfaceVariant,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: QiratTheme.goldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: QiratTheme.goldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: QiratTheme.qiratGold),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _submitSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: QiratTheme.qiratGold,
            foregroundColor: Colors.black,
          ),
          child: const Text('Search', style: TextStyle(fontFamily: 'Inter')),
        )
      ],
    );
  }
}

class _SearchProductCard extends StatelessWidget {
  final Product product;
  const _SearchProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(NewWebRouter.newProductDetails, extra: product),
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
                    ? Image.network(
                        product.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
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
                    tooltip: 'Add to cart',
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
