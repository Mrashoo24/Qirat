import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/router/app_router.dart';
import '../../domain/entities/product/product.dart';

class ProductCard extends StatelessWidget {
  final Product? product;
  final Function? onFavoriteToggle;
  final Function? onClick;

  const ProductCard({
    Key? key,
    this.product,
    this.onFavoriteToggle,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return product == null
        ? Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: buildBody(context),
    )
        : buildBody(context);
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (product != null) {
          Navigator.of(context)
              .pushNamed(AppRouter.productDetails, arguments: product);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth; // Get the available width

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: width,
                height: width, // Ensure height is equal to the width
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    border: Border.all(
                      color: Theme.of(context).shadowColor.withOpacity(0.15),
                    ),
                  ),
                  child: product == null
                      ? Material(
                    child: GridTile(
                      footer: Container(),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  )
                      : Hero(
                    tag: product!.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: product!.images.first,
                        placeholder: (context, url) =>
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.white,
                              child: Container(),
                            ),
                        errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: SizedBox(
                  child: product == null
                      ? Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                      : Text(
                    product!.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: Row(
                  children: [
                    SizedBox(
                      child: product == null
                          ? Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                          : Text(
                        '₹' + product!.priceTags.first.price.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
