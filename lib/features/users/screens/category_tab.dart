import 'package:flutter/material.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../models/category_model.dart';
import 'articles_by_category_screen.dart';
import '../../../core/animation';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  final CategoryViewModel _viewModel = CategoryViewModel();
  late Future<List<CategoryModel>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = _viewModel.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: FutureBuilder<List<CategoryModel>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return Center(
              child: Text(
                'Chưa có danh mục nào.',
                style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: categories.length,
            separatorBuilder: (_, __) => Divider(
              color: theme.dividerColor,
              thickness: 1,
              height: 16,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return Material(
                color: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Colors.transparent, 
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: const Icon(
                    Icons.label_outline,
                    color: Color(0xFF015E53),
                  ),
                  title: Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    category.description,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context)
                        .iconTheme
                        .color
                        ?.withOpacity(0.6),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      createSlideRoute(
                        ArticlesByCategoryScreen(
                          categoryId: category.id,
                          categoryTitle: category.title,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
