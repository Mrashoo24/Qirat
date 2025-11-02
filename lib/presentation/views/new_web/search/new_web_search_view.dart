import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../blocs/product/product_bloc.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebSearchView extends StatelessWidget {
  final String query;
  const NewWebSearchView({Key? key, required this.query}) : super(key: key);

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
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final q = query.toLowerCase();
                final results = state.products
                    .where((p) => p.name.toLowerCase().contains(q))
                    .toList();
                if (results.isEmpty) {
                  return Center(
                      child: Text('No results for "$query"',
                          style: const TextStyle(fontFamily: 'Inter')));
                }
                return ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: QiratTheme.borderDark),
                  itemBuilder: (_, i) => ListTile(
                    title: Text(results[i].name,
                        style: const TextStyle(fontFamily: 'Inter')),
                    subtitle: Text(results[i].description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            color: QiratTheme.textSecondary)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
