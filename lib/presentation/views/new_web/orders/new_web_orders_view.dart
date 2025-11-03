import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../blocs/order/order_fetch/order_fetch_cubit.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebOrdersView extends StatelessWidget {
  const NewWebOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: QiratTheme.darkTheme,
      child: Scaffold(
        backgroundColor: QiratTheme.darkBackground,
        appBar: const QiratHeaderWidget(showShadow: true),
        body: BlocBuilder<OrderFetchCubit, OrderFetchState>(
          builder: (context, state) {
            if (state is OrderFetchLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderFetchSuccess) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return const Center(
                    child: Text('No orders yet',
                        style: TextStyle(fontFamily: 'Inter')));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final o = orders[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: QiratTheme.darkSurface,
                      border: Border.all(color: QiratTheme.goldBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Order #${o.id}',
                          style: const TextStyle(fontFamily: 'Inter')),
                      subtitle: Column(
                        children: [
                          Text(
                              '${o.orderItems.length} items • ₹${o.total}',
                              style: const TextStyle(fontFamily: 'Inter')),
                          Text(
                              'Placed on ${o.date.toString()}',
                              style: const TextStyle(fontFamily: 'Inter')),
                          Text(
                            "Discount : ${o!.discount}",
                              style: const TextStyle(fontFamily: 'Inter')
                          ),
                          Text(
                              "Information : ${o!.info}",
                              style: const TextStyle(fontFamily: 'Inter')
                          ),

                          Column(
                            children: o!.orderItems
                                .map((product) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 75,
                                    child: AspectRatio(
                                      aspectRatio: 0.88,
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: CachedNetworkImage(
                                              imageUrl: product
                                                  .product.images.first,
                                            ),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.product.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 24,
                                                child:  Text(
                                                  product.priceTag.name.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              SizedBox(
                                                height: 24,
                                                child: Text(
                                                  "Quantity: " + product.quantity.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                            'Unit Rate: ₹${product.priceTag.price.toStringAsFixed(2)}')
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                                .toList(),
                          )
                        ],
                      ),
                      trailing: Text(o.status,
                          style: const TextStyle(
                              color: QiratTheme.qiratGold,
                              fontFamily: 'Inter')),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
