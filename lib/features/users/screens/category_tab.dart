import 'package:flutter/material.dart';
import '../../viewmodel/category_viewmodel.dart';
import '../../models/category_model.dart';
import 'articles_by_category_screen.dart'; 

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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            final List<List<Color>> gradients = [
              [Colors.blue.shade300, const Color.fromARGB(255, 0, 136, 255)],
              [Colors.purple.shade300, const Color.fromARGB(255, 200, 0, 255)],
              [const Color.fromARGB(255, 252, 240, 75), const Color.fromARGB(255, 217, 184, 0)],
              [Colors.green.shade300, const Color.fromARGB(255, 15, 163, 23)],
              [Colors.red.shade300, const Color.fromARGB(255, 255, 32, 29)],
            ];

            final gradientColors = gradients[index % gradients.length];

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticlesByCategoryScreen(
                        categoryId: category.id,
                        categoryTitle: category.title,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.label_outline, color: Colors.white),
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
                    trailing: const Icon(Icons.chevron_right, color: Colors.white),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
