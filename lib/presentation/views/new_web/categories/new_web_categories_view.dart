import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/qirat_theme.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../domain/entities/category/category.dart';
import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/filter/filter_cubit.dart';
import '../../../blocs/product/product_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/new_web_router.dart';
import '../../../widgets/new_web/common/qirat_header_widget.dart';

class NewWebCategoriesView extends StatelessWidget {
  const NewWebCategoriesView({Key? key}) : super(key: key);

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
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                List<Category> categories =
                    (state is CategoryLoaded || state is CategoryCacheLoaded)
                        ? state.categories
                        : const [];
                if (categories.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                categories.sort((a, b) {
                  final aMain = a.location!.toLowerCase().contains('main') ? 0 : 1;
                  final bMain = b.location!.toLowerCase().contains('main') ? 0 : 1;
                  if (aMain != bMain) return aMain - bMain;
                  return a.location!.compareTo(b.location!);
                });
                final cols = ResponsiveHelper.responsive(
                    context: context, mobile: 2, tablet: 3, desktop: 4);
                return GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (_, i) {
                    final c = categories[i];
                    return InkWell(
                      onTap: () {
                        context.read<FilterCubit>().update(category: c);
                        context.read<ProductBloc>().add(
                            GetProducts(context.read<FilterCubit>().state));
                        context.push(NewWebRouter.newProducts);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: QiratTheme.darkSurface,
                          border: Border.all(color: QiratTheme.goldBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: c.image.isNotEmpty
                                    ? Image.network(c.image,
                                        fit: BoxFit.fill,
                                        width: double.infinity)
                                    : Container(
                                        color: QiratTheme.darkSurfaceVariant),
                              ),
                            ),
                            // const SizedBox(height: 10),
                            // Text(c.name,
                            //     maxLines: 1,
                            //     overflow: TextOverflow.ellipsis,
                            //     style: const TextStyle(
                            //       color: QiratTheme.qiratGold,
                            //       fontWeight: FontWeight.w700,
                            //       fontFamily: 'Inter',
                            //     )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
