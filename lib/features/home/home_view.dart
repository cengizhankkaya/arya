import 'package:flutter/material.dart';
import 'package:arya/features/store/view/store_view.dart';

class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}

class CategoryScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(
      name: 'Fruits & Vegetables',
      imageUrl: 'assets/images/categories/cat_fruits.png',
    ),
    Category(
      name: 'Breakfast',
      imageUrl: 'assets/images/categories/cat_breakfast.png',
    ),
    Category(
      name: 'Beverages',
      imageUrl: 'assets/images/categories/cat_beverages.png',
    ),
    Category(
      name: 'Meat & Fish',
      imageUrl: 'assets/images/categories/cat_meat_fish.png',
    ),
    Category(
      name: 'Snacks',
      imageUrl: 'assets/images/categories/cat_snacks.png',
    ),
    Category(name: 'Dairy', imageUrl: 'assets/images/categories/cat_dairy.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(category: categories[index]);
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductsPage(initialCategory: category.name),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(category.imageUrl, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
