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
                      subtitle: Text(
                          '${o.orderItems.length} items • ₹${o.total}',
                          style: const TextStyle(fontFamily: 'Inter')),
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
