import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/data/firebase/firebase_services.dart';
import 'package:eshop/presentation/blocs/category/category_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../data/models/product/product_model.dart';
import '../../../../domain/entities/product/product.dart';
import '../../../../domain/usecases/product/get_product_usecase.dart';
import '../../../blocs/filter/filter_cubit.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../widgets/alert_card.dart';
import '../../../widgets/input_form_button.dart';
import '../../../widgets/product_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController scrollController = ScrollController();

  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    double scrollPercentage = 0.7;
    if (currentScroll > (maxScroll * scrollPercentage)) {
      if (context.read<ProductBloc>().state is ProductLoaded) {
        context.read<ProductBloc>().add(const GetMoreProducts());
      }
    }
  }

  @override
  void initState() {
    // scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).padding.top + 10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserLogged) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        throw Exception();
                      },
                      child: Text(
                        "${state.user.firstName} ${state.user.lastName}",
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 8,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context).pushNamed(AppRouter.userProfile);
                    //   },
                    //   child: state.user.image != null
                    //       ? CachedNetworkImage(
                    //           imageUrl: state.user.image!,
                    //           imageBuilder: (context, image) => CircleAvatar(
                    //             radius: 24.0,
                    //             backgroundImage: image,
                    //             backgroundColor: Colors.transparent,
                    //           ),
                    //         )
                    //       : const CircleAvatar(
                    //           radius: 24.0,
                    //           backgroundImage: AssetImage(kUserAvatar),
                    //           backgroundColor: Colors.transparent,
                    //         ),
                    // )
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Welcome,",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 36),
                        ),
                        // Text(
                        //   "Qirat Shop",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.normal, fontSize: 22),
                        // ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRouter.signIn);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 24.0,
                          backgroundImage: AssetImage(kUserAvatar),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: BlocBuilder<FilterCubit, FilterProductParams>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          FirebaseAnalytics.instance
                              .logEvent(name: "SearchClicked");
                          Navigator.pushNamed(context, AppRouter.searchView);
                        },
                        child: TextField(
                          autofocus: false,
                          enabled: false,
                          controller:
                              context.read<FilterCubit>().searchController,
                          onChanged: (val) => setState(() {}),
                          onSubmitted: (val) => context.read<ProductBloc>().add(
                              GetProducts(FilterProductParams(keyword: val))),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  left: 20, bottom: 22, top: 22),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(Icons.search),
                              ),
                              suffixIcon: context
                                      .read<FilterCubit>()
                                      .searchController
                                      .text
                                      .isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: IconButton(
                                          onPressed: () {
                                            context
                                                .read<FilterCubit>()
                                                .searchController
                                                .clear();
                                            context
                                                .read<FilterCubit>()
                                                .update(keyword: '');
                                          },
                                          icon: const Icon(Icons.clear)),
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3.0),
                                  borderRadius: BorderRadius.circular(26)),
                              hintText: "Search Product",
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3.0),
                                  borderRadius: BorderRadius.circular(26)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(26),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 3.0),
                              )),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                // SizedBox(
                //   width: 55,
                //   child: BlocBuilder<FilterCubit, FilterProductParams>(
                //     builder: (context, state) {
                //       return Badge(
                //         alignment: AlignmentDirectional.topEnd,
                //         label: Text(
                //           context
                //               .read<FilterCubit>()
                //               .getFiltersCount()
                //               .toString(),
                //           style: const TextStyle(color: Colors.black87),
                //         ),
                //         isLabelVisible:
                //             context.read<FilterCubit>().getFiltersCount() != 0,
                //         backgroundColor: Theme.of(context).primaryColor,
                //         child: InputFormButton(
                //           color: Colors.black87,
                //           onClick: () {
                //             Navigator.of(context).pushNamed(AppRouter.filter);
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, catstate) {
                  return BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                    //Result Empty and No Error
                    if (state is ProductLoaded && state.products.isEmpty) {
                      return const AlertCard(
                        image: kEmpty,
                        message: "Products not found!",
                      );
                    }
                    //Error and no preloaded data
                    if (state is ProductError && state.products.isEmpty) {
                      if (state.failure is NetworkFailure) {
                        return AlertCard(
                          image: kNoConnection,
                          message: "Network failure\nTry again!",
                          onClick: () {
                            context.read<ProductBloc>().add(GetProducts(
                                FilterProductParams(
                                    keyword: context
                                        .read<FilterCubit>()
                                        .searchController
                                        .text)));
                          },
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.failure is ServerFailure)
                            Image.asset(
                                'assets/status_image/internal-server-error.png'),
                          if (state.failure is CacheFailure)
                            Image.asset(
                                'assets/status_image/no-connection.png'),
                          const Text("Products not found!"),
                          IconButton(
                              onPressed: () {
                                context.read<ProductBloc>().add(GetProducts(
                                    FilterProductParams(
                                        keyword: context
                                            .read<FilterCubit>()
                                            .searchController
                                            .text)));
                              },
                              icon: const Icon(Icons.refresh)),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          )
                        ],
                      );
                    }

                    // Group products by category
                    final Map<String, List<Product>> categoryProductMap = {};
                    for (var product in state.products) {
                      var catname = catstate.categories
                          .firstWhere((element) =>
                              element.id == product.categories.first)
                          .name;
                      categoryProductMap.putIfAbsent(
                        catname, // Assuming `category` is a field in the `ProductModel`
                        () => [],
                      );
                      categoryProductMap[catname]!.add(product);
                    }

                    return Padding(
                      padding: EdgeInsets.only(
                        top: 18,
                        left: 20,
                        right: 20,
                        bottom: (80 + MediaQuery.of(context).padding.bottom),
                      ),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<ProductBloc>()
                              .add(const GetProducts(FilterProductParams()));
                        },
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: categoryProductMap.entries.map((entry) {
                                final categoryName = entry.key;
                                final products = entry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            categoryName
                                                .toUpperCase(), // Display the category name
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              var firebaseService =
                                                  sl.get<FirebaseService>();

                                              firebaseService.logEvent(
                                                  context, "View_All", {
                                                "categoryName": categoryName
                                              });

                                              context.read<FilterCubit>().update(
                                                  category: catstate.categories
                                                      .firstWhere((element) =>
                                                          element.name ==
                                                          categoryName));
                                              Navigator.of(context).pushNamed(
                                                  AppRouter.productPage);
                                            },
                                            child: const Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "View All", // Display the category name
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Icon(Icons
                                                        .arrow_circle_right_rounded)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ProductGrid(products: products, scrollController: scrollController,state: state,),

                                    // Product Grid for this category
                                    // GridView.builder(
                                    //   itemCount: products.length +
                                    //       ((state is ProductLoading) ? 10 : 0),
                                    //   controller: scrollController,
                                    //   padding: EdgeInsets.only(bottom: 16),
                                    //   gridDelegate:
                                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                                    //     crossAxisCount: 2,
                                    //     childAspectRatio: 0.55,
                                    //     crossAxisSpacing: 12,
                                    //     mainAxisSpacing: 20,
                                    //   ),
                                    //   physics: const BouncingScrollPhysics(),
                                    //   shrinkWrap: true,
                                    //   itemBuilder:
                                    //       (BuildContext context, int index) {
                                    //     if (products.length > index) {
                                    //       return ProductCard(
                                    //         product: products[index],
                                    //       );
                                    //     } else {
                                    //       return Shimmer.fromColors(
                                    //         baseColor: Colors.grey.shade100,
                                    //         highlightColor: Colors.white,
                                    //         child: const ProductCard(),
                                    //       );
                                    //     }
                                    //   },
                                    // ),
                                  ],
                                );
                              }).toList()),
                        ),
                      ),
                    );
                  });
                })),
          )
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.scrollController, required this.state,

  });

  final List<Product> products;
  final ScrollController scrollController;
  final ProductState state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust crossAxisCount based on screen width for web compatibility
        int crossAxisCount =
            (constraints.maxWidth > 600)
                ? 4
                : 2;

        return MasonryGridView.builder(

          itemCount: products.length +
              ((state is ProductLoading)
                  ? 10
                  : 0),
          controller: scrollController,
          mainAxisSpacing: 10,
          crossAxisSpacing: 30,
          gridDelegate:
              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      crossAxisCount),
          padding:
              EdgeInsets.zero, // Remove padding
          physics:
              const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context,
              int index) {
            if (products.length > index) {
              if (products.length > index) {
                return ProductCard(
                  product: products[index],
                );
              } else {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.white,
                  child: const ProductCard(),
                );
              }
            } else {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade100,
                highlightColor: Colors.white,
                child: const ProductCard(),
              );
            }
          },
        );
      },
    );
  }
}
