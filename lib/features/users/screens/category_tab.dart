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
    return Container(
      color: const Color(0xFF2C1A1F), 
      child: FutureBuilder<List<CategoryModel>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có danh mục nào.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const Divider(
                  color: Color(0xFF4A3A3F),
                  thickness: 1,
                  height: 16,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C1A1F), 
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: const Icon(Icons.label_outline, color: Color(0xFFD0021B)),
                  title: Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    category.description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white70),
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
