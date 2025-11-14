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
    return FutureBuilder<List<CategoryModel>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final categories = snapshot.data ?? [];

        if (categories.isEmpty) {
          return const Center(child: Text('Chưa có danh mục nào.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final category = categories[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: const Icon(Icons.label_outline, color: Color(0xFFD0021B)),
              title: Text(
                category.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                category.description,
                style: const TextStyle(color: Colors.black54),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
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
            );
          },
        );
      },
    );
  }
}
