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
      color: Colors.white, 
      child: FutureBuilder<List<CategoryModel>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final categories = snapshot.data ?? [];

          if (categories.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có danh mục nào.',
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            itemCount: categories.length,
            separatorBuilder: (_, __) => Divider(
              color: Colors.grey[300],
              thickness: 1,
              height: 16,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: const Icon(Icons.label_outline, color: Color(0xFFB42652)), 
                  title: Text(
                    category.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black, 
                    ),
                  ),
                  subtitle: Text(
                    category.description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black38),
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
