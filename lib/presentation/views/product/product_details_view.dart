import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/presentation/blocs/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../domain/entities/cart/cart_item.dart';
import '../../../../../domain/entities/product/price_tag.dart';
import '../../../../../domain/entities/product/product.dart';
import '../../../core/constant/colors.dart';
import '../../../core/router/app_router.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/home/navbar_cubit.dart';
import '../../widgets/counterButton.dart';
import '../../widgets/input_form_button.dart';
import 'package:collection/collection.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  const ProductDetailsView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentIndex = 0;
  late PriceTag _selectedPriceTag;
  late int quantity = 0;

  @override
  void initState() {
    _selectedPriceTag = widget.product.priceTags.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(builder: (context, cartstate) {
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).width,
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
                items: widget.product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Hero(
                        tag: widget.product.id,
                        child: CachedNetworkImage(
                          imageUrl: image,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                    Colors.grey.shade50.withOpacity(0.25),
                                    BlendMode.softLight),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: widget.product.images.length,
                  effect: ScrollingDotsEffect(
                      dotColor: Colors.grey.shade300,
                      maxVisibleDots: 7,
                      activeDotColor: Colors.grey,
                      dotHeight: 6,
                      dotWidth: 6,
                      activeDotScale: 1.1,
                      spacing: 6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 14, top: 20, bottom: 4),
              child: Text(
                widget.product.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Wrap(
                children: widget.product.priceTags
                    .map((priceTag) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedPriceTag = priceTag;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: _selectedPriceTag.id == priceTag.id
                                    ? 2.0
                                    : 1.0,
                                color: Colors.grey,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(right: 4),
                            child: Column(
                              children: [
                                Text(priceTag.name),
                                Text("₹" + priceTag.price.toString()),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 10,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.product.tags.map<Widget>((tag) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color:
                                kLightPrimaryColor, // Custom bullet point color
                          ),
                          const SizedBox(width: 4),
                          Text(tag, style: const TextStyle(fontSize: 14)),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                      height: 12), // Space between description and tags
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        );
      }),
      bottomNavigationBar:
          BlocBuilder<CartBloc, CartState>(builder: (context, cartstate) {
        var currentCartItem = cartstate.cart.firstWhereOrNull((element) =>
            element.product.id == widget.product.id &&
            element.priceTag.id == _selectedPriceTag.id);

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
                    "Total",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    '₹${_selectedPriceTag.price}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 120,
                child: currentCartItem == null
                    ? InputFormButton(
                        onClick: () {
                          var state = context.read<UserBloc>().state;
                          var uid = "1";
                          if (state is UserLogged) {
                            uid = state.user.id;
                          }
                          if (currentCartItem != null) {
                            context.read<CartBloc>().add(AddProduct(
                                cartItem: CartItem(
                                    id: uid +
                                        widget.product.id +
                                        _selectedPriceTag.id,
                                    product: widget.product,
                                    priceTag: _selectedPriceTag,
                                    quantity: currentCartItem?.quantity ?? 1,
                                    uid: uid)));
                          } else {
                            context.read<CartBloc>().add(AddProduct(
                                cartItem: CartItem(
                                    id: uid +
                                        widget.product.id +
                                        _selectedPriceTag.id,
                                    product: widget.product,
                                    priceTag: _selectedPriceTag,
                                    quantity: 1,
                                    uid: uid)));
                          }

                          // print("test");
                          context.read<NavbarCubit>().update(2);
                          context.read<NavbarCubit>().controller.animateToPage(
                              2,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.linear);
                          Navigator.pop(context);
                        },
                        titleText: "Add to Cart",
                      )
                    : CartCounter(
                        initialQuantity:
                            (currentCartItem?.quantity ?? 1).toInt(),
                        onQuantityIncrease: (quantity) {

                          var state = context.read<UserBloc>().state;
                          var uid = "1";
                          if (state is UserLogged) {
                            uid = state.user.id;
                          }
                            context.read<CartBloc>().add(AddProduct(
                                cartItem: CartItem(
                                    id: uid +
                                        widget.product.id +
                                        _selectedPriceTag.id,
                                    product: widget.product,
                                    priceTag: _selectedPriceTag,
                                    quantity:
                                        (currentCartItem?.quantity ?? 1) + 1,
                                    uid: uid)));

                          // Handle quantity change logic here
                        },
                  onQuantityDecrease: (quantity) {
                    var state = context.read<UserBloc>().state;
                    var uid = "1";
                    if (state is UserLogged) {
                      uid = state.user.id;
                    }
                    if (quantity < 1) {
                      context.read<CartBloc>().add(RemoveProduct(
                          cartItem: CartItem(
                              id: uid +
                                  widget.product.id +
                                  _selectedPriceTag.id,
                              product: widget.product,
                              priceTag: _selectedPriceTag,
                              quantity: currentCartItem?.quantity ?? 1,
                              uid: uid)));
                    } else {
                      context.read<CartBloc>().add(AddProduct(
                          cartItem: CartItem(
                              id: uid +
                                  widget.product.id +
                                  _selectedPriceTag.id,
                              product: widget.product,
                              priceTag: _selectedPriceTag,
                              quantity:
                              (currentCartItem?.quantity ?? 1) - 1,
                              uid: uid)));
                    }
                    // Handle quantity change logic here
                  },
                      ),
              ),
              const SizedBox(
                width: 6,
              ),
              SizedBox(
                width: 90,
                child: InputFormButton(
                  onClick: () {
                    var state = context.read<UserBloc>().state;
                    var uid = "1";
                    if (state is UserLogged) {
                      uid = state.user.id;
                    }

                    Navigator.of(context)
                        .pushNamed(AppRouter.orderCheckout, arguments: [
                      CartItem(
                          product: widget.product,
                          priceTag: _selectedPriceTag,
                          quantity: 1,
                          uid: uid)
                    ]);
                  },
                  titleText: "Buy",
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
