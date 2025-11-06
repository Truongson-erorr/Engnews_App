import 'package:flutter/material.dart';
import '../viewmodels/category_viewmodel.dart';
import '../model/category_model.dart';

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
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.label_outline, color: Colors.blue),
                title: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  category.description,
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/articlesByCategory',
                    arguments: category.id,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
