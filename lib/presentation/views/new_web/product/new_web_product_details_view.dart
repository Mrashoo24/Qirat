import 'package:eshop/core/router/new_web_router.dart';
import 'package:eshop/data/models/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/cart/cart_item.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/entities/product/price_tag.dart';
import '../../../blocs/cart/cart_bloc.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/home/navbar_cubit.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';
import '../../../widgets/input_form_button.dart';
import '../../../widgets/counterButton.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/firebase/firebase_services.dart';
import '../../../../core/services/services_locator.dart';

class NewWebProductDetailsLoader extends StatelessWidget {
  final String productId;
  const NewWebProductDetailsLoader({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        // Wait for products to be available (ProductLoaded or any state with non-empty list)
        final List<Product> products = state.products;
        if (products.isEmpty) {
          return const Scaffold(
            backgroundColor: QiratTheme.darkBackground,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final product = products.firstWhere(
          (p) => p.id == productId,
          orElse: () =>  ProductModel(
            id: '',
            name: '',
            description: '',
            images: [],
            priceTags: [],
            categories: [],
            tags: [],
            createdAt:DateTime.now(), // Safe placeholder if your entity allows null/adjust to your constructor
            updatedAt: DateTime.now(), // Safe placeholder if your entity allows null/adjust to your constructor
          ),
        );

        if (product.id.isEmpty) {
          // Invalid ID -> redirect to home gracefully
          Future.microtask(() => context.go(NewWebRouter.newHome));
          return const SizedBox.shrink();
        }

        return NewWebProductDetailsView(product: product);
      },
    );
  }
}

class NewWebProductDetailsView extends StatefulWidget {
  final Product product;
  const NewWebProductDetailsView({Key? key, required this.product})
      : super(key: key);

  @override
  State<NewWebProductDetailsView> createState() =>
      _NewWebProductDetailsViewState();
}

class _NewWebProductDetailsViewState extends State<NewWebProductDetailsView> {
  int _currentIndex = 0;
  PriceTag? _selected;

  @override
  void initState() {
    _selected = widget.product.priceTags.isNotEmpty
        ? widget.product.priceTags.first
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: const QiratHeaderWidget(showShadow: true),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            return Padding(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.getContentMaxWidth(context),
                ),
                child: ResponsiveLayout(
                  mobileLayout: _buildMobile(context),
                  desktopLayout: _buildDesktop(context),
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCarousel(context),
                const SizedBox(height: 12),
                _buildDots(),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(child: _buildInfo(context)),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        _buildCarousel(context),
        const SizedBox(height: 12),
        _buildDots(),
        const SizedBox(height: 24),
        _buildInfo(context),
      ],
    );
  }

  Widget _buildCarousel(BuildContext context) {
    final images =
        widget.product.images.isEmpty ? <String>[''] : widget.product.images;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: CarouselSlider(
        options: CarouselOptions(
          height: double.infinity,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: images.map((image) {
          return Builder(builder: (context) {
            return Hero(
              tag: widget.product.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          color: QiratTheme.darkSurfaceVariant,
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: QiratTheme.textMuted,
                          ),
                        ),
                      )
                    : Container(
                        color: QiratTheme.darkSurfaceVariant,
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: QiratTheme.textMuted,
                          ),
                        ),
                      ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildDots() {
    final count =
        widget.product.images.isEmpty ? 1 : widget.product.images.length;
    return Align(
      alignment: Alignment.center,
      child: AnimatedSmoothIndicator(
        activeIndex: _currentIndex,
        count: count,
        effect: ScrollingDotsEffect(
          dotColor: QiratTheme.borderDark,
          maxVisibleDots: 7,
          activeDotColor: QiratTheme.qiratGold,
          dotHeight: 6,
          dotWidth: 6,
          activeDotScale: 1.1,
          spacing: 6,
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.product.name,
            style: const TextStyle(
              color: QiratTheme.darkOnBackground,
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter',
              fontSize: 32,
            )),
        const SizedBox(height: 12),
        Text(widget.product.description,
            style: const TextStyle(
              color: QiratTheme.textSecondary,
              fontFamily: 'Inter',
              height: 1.5,
            )),
        const SizedBox(height: 24),
        if (widget.product.priceTags.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.product.priceTags.map((p) {
              final selected = _selected?.id == p.id;
              return GestureDetector(
                onTap: () => setState(() => _selected = p),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? QiratTheme.qiratGold.withOpacity(0.12)
                        : QiratTheme.darkSurfaceVariant,
                    border: Border.all(
                      width: selected ? 2 : 1,
                      color: selected
                          ? QiratTheme.qiratGold
                          : QiratTheme.goldBorder,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p.name,
                        style: TextStyle(
                          color: selected
                              ? QiratTheme.qiratGold
                              : QiratTheme.darkOnBackground,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${p.price}',
                        style: TextStyle(
                          color: selected
                              ? QiratTheme.qiratGold
                              : QiratTheme.textSecondary,
                          fontSize: 12,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
        if (_selected != null)
          Text('₹${_selected!.price}',
              style: const TextStyle(
                color: QiratTheme.qiratGold,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                fontSize: 28,
              )),
        const SizedBox(height: 24),
        // Tags
        if (widget.product.tags.isNotEmpty) ...[
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: widget.product.tags
                .map((t) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        Icon(Icons.circle,
                            size: 6, color: QiratTheme.qiratGold),
                        SizedBox(width: 6),
                        Text(
                            widget.product.tags.isNotEmpty ? t : 'No Tags',
                          style: TextStyle(
                            color: QiratTheme.textSecondary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final cartstate = context.watch<CartBloc>().state;
    final currentCartItem = cartstate.cart.firstWhereOrNull((element) =>
        element.product.id == widget.product.id &&
        element.priceTag.id == (_selected?.id ?? ''));

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      height: 80 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 10,
        top: 10,
        left: 20,
        right: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(
                _selected == null ? '—' : '₹${_selected!.price}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 120,
            child: currentCartItem == null ||  (currentCartItem.quantity).toInt() == 0
                ? InputFormButton(
                    onClick: () {
                      if (_selected == null) return;
                      var state = context.read<UserBloc>().state;
                      var uid = '1';
                      if (state is UserLogged) {
                        uid = state.user.id;
                      }

                      context.read<CartBloc>().add(
                            AddProduct(
                              cartItem: CartItem(
                                id: uid +
                                    widget.product.id +
                                    (_selected?.id ?? ''),
                                product: widget.product,
                                priceTag: _selected!,
                                quantity: 1,
                                uid: uid,
                              ),
                            ),
                          );

                      // Optional: if NavbarCubit exists, keep legacy behavior
                      try {
                        context.read<NavbarCubit>().update(2);
                        context.read<NavbarCubit>().controller.animateToPage(
                              2,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.linear,
                            );
                      } catch (_) {}

                      // Analytics
                      try {
                        final firebaseService = sl.get<FirebaseService>();
                        firebaseService.logEvent(context, 'Add_to_cart', {
                          'product': widget.product.id + (_selected?.id ?? ''),
                        });
                      } catch (_) {}

                      // Navigator.pop(context);
                    },
                    titleText: 'Add to Cart',
                  )
                : CartCounter(
                    initialQuantity: (currentCartItem.quantity).toInt(),
                    onQuantityIncrease: (quantity) {
                      var state = context.read<UserBloc>().state;
                      var uid = '1';
                      if (state is UserLogged) {
                        uid = state.user.id;
                      }

                      context.read<CartBloc>().add(
                            AddProduct(
                              cartItem: CartItem(
                                id: uid +
                                    widget.product.id +
                                    (_selected?.id ?? ''),
                                product: widget.product,
                                priceTag: _selected!,
                                quantity: currentCartItem.quantity + 1,
                                uid: uid,
                              ),
                            ),
                          );
                    },
                    onQuantityDecrease: (quantity) {
                      var state = context.read<UserBloc>().state;
                      var uid = '1';
                      if (state is UserLogged) {
                        uid = state.user.id;
                      }

                      if (quantity < 1) {
                        context.read<CartBloc>().add(
                              RemoveProduct(
                                cartItem: CartItem(
                                  id: uid +
                                      widget.product.id +
                                      (_selected?.id ?? ''),
                                  product: widget.product,
                                  priceTag: _selected!,
                                  quantity: currentCartItem.quantity,
                                  uid: uid,
                                ),
                              ),
                            );
                      } else {
                        context.read<CartBloc>().add(
                              AddProduct(
                                cartItem: CartItem(
                                  id: uid +
                                      widget.product.id +
                                      (_selected?.id ?? ''),
                                  product: widget.product,
                                  priceTag: _selected!,
                                  quantity: currentCartItem.quantity - 1,
                                  uid: uid,
                                ),
                              ),
                            );
                      }
                    },
                  ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 90,
            child: InputFormButton(
              onClick: () {
                if (_selected == null) return;
                var state = context.read<UserBloc>().state;
                var uid = '1';
                if (state is UserLogged) {
                  uid = state.user.id;
                }

                context.pushNamed(
                  NewWebRouter.newCheckout,
                  extra: [
                    CartItem(
                      product: widget.product,
                      priceTag: _selected!,
                      quantity: 1,
                      uid: uid,
                    ),
                  ],
                );
              },
              titleText: 'Buy',
            ),
          ),
        ],
      ),
    );
  }
}
