import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/entities/category/category.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/filter/filter_cubit.dart';
import '../../../blocs/cart/cart_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';
import '../../../../domain/usecases/product/get_product_usecase.dart';

class NewWebProductsView extends StatefulWidget {
  final Category? category;
  final String? categoryId;
  const NewWebProductsView({Key? key, this.category, this.categoryId})
      : super(key: key);

  @override
  State<NewWebProductsView> createState() => _NewWebProductsViewState();
}

class _NewWebProductsViewState extends State<NewWebProductsView> {
  @override
  void initState() {
    super.initState();
    // Seed FilterCubit with incoming category if provided
    if (widget.category != null) {
      context.read<FilterCubit>().update(category: widget.category);
    } else if (widget.categoryId != null && widget.categoryId!.isNotEmpty) {
      // Seed with a lightweight placeholder Category so filtering works immediately
      context.read<FilterCubit>().update(
            category: Category(
              id: widget.categoryId!,
              name: '',
              image: '',
              body: null,
              location: null,
            ),
          );
    }
    // Ensure products are loaded
    final productState = context.read<ProductBloc>().state;
    if (productState.products.isEmpty) {
      context.read<ProductBloc>().add(const GetProducts(FilterProductParams()));
    }
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
              maxWidth: ResponsiveHelper.getContentMaxWidth(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<FilterCubit, FilterProductParams>(
                    builder: (context, filterState) {
                      return BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          final all = state.products;
                          if (all.isEmpty && state is! ProductLoading) {
                            return const Center(
                                child: Text('No products')); // fallback
                          }

                          // Filter by selected categories (ids) if any
                          List<Product> filtered = all;
                          if (filterState.categories.isNotEmpty) {
                            final selectedIds =
                                filterState.categories.map((c) => c.id).toSet();
                            filtered = filtered
                                .where((p) => p.categories
                                    .any((id) => selectedIds.contains(id)))
                                .toList();
                          }
                          // Keyword filter (case-insensitive)
                          final kw = filterState.keyword?.trim() ?? '';
                          if (kw.isNotEmpty) {
                            filtered = filtered
                                .where((p) => p.name
                                    .toLowerCase()
                                    .contains(kw.toLowerCase()))
                                .toList();
                          }

                          if (state is ProductLoading && filtered.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final crossCount = ResponsiveHelper.responsive(
                            context: context,
                            mobile: 2,
                            tablet: 3,
                            desktop: 4,
                          );
                          return RefreshIndicator(
                            onRefresh: () async {
                              context.read<ProductBloc>().add(
                                  const GetProducts(FilterProductParams()));
                            },
                            child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: filtered.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossCount,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.75,
                              ),
                              itemBuilder: (ctx, i) => _ProductCard(
                                product: filtered[i],
                              ),
                            ),
                          );
                        },
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

  Widget _buildSearchBar(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<FilterCubit, FilterProductParams>(
            builder: (context, state) {
              final controller = context.read<FilterCubit>().searchController;
              return TextField(
                controller: controller,
                onChanged: (val) {
                  context.read<FilterCubit>().update(keyword: val);
                  setState(() {});
                },
                style: const TextStyle(color: QiratTheme.darkOnBackground),
                decoration: InputDecoration(
                  hintText: 'Search in this category',
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
              );
            },
          ),
        ),
        if (!isMobile) const SizedBox(width: 12),
        if (!isMobile)
          IconButton(
            tooltip: 'Global search',
            onPressed: () => context.push(NewWebRouter.newSearch),
            icon: const Icon(Icons.travel_explore,
                color: QiratTheme.darkOnSurface),
          ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

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
