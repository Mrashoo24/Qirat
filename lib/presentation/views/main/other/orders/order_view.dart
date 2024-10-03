
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/images.dart';
import '../../../../../domain/entities/order/order_details.dart';
import '../../../../blocs/order/order_fetch/order_fetch_cubit.dart';
import '../../../../widgets/order_info_card.dart';
import '../../../../../core/services/services_locator.dart' as di;

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {


  @override
  void initState() {
    context.read<OrderFetchCubit>().getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: BlocBuilder<OrderFetchCubit, OrderFetchState>(
        builder: (context, state) {
          if(state is! OrderFetchLoading && state.orders.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(kOrderDelivery),
                const Text("Orders are Empty!"),
                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * 0.1,
                )
              ],
            );
          }
          if (state is OrderFetchSuccess) {

            var orderList = state.orders;
            orderList.sort((OrderDetails a,OrderDetails b) => b.date.compareTo(a.date));

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: orderList.length,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: (10 + MediaQuery.of(context).padding.bottom),
                top: 10,
              ),
              itemBuilder: (context, index) => OrderInfoCard(
                orderDetails: orderList[index],
              ),
            );
          } else {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 6,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: (10 + MediaQuery.of(context).padding.bottom),
                top: 10,
              ),
              itemBuilder: (context, index) => const OrderInfoCard(),
            );
          }
        },
      ),
    );
  }
}
