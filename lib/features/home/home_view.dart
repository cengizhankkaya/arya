import 'package:flutter/material.dart';
import 'package:arya/features/store/view/store_view.dart';

class Category {
  final String name;
  final String imageUrl;
  final Color backgroundColor;
  final Color borderColor;

  Category({
    required this.name,
    required this.imageUrl,
    required this.backgroundColor,
    required this.borderColor,
  });
}

class CategoryScreen extends StatelessWidget {
  final List<Category> categories = [
    Category(
      name: 'Fruits & Vegetables',
      imageUrl: 'assets/images/categories/cat_fruits.png',
      backgroundColor: const Color(0xFFE8F7EE), // soft green
      borderColor: const Color(0xFFB7E4C7),
    ),
    Category(
      name: 'Breakfast',
      imageUrl: 'assets/images/categories/cat_breakfast.png',
      backgroundColor: const Color(0xFFF0E6FF), // soft purple
      borderColor: const Color(0xFFD4C2FF),
    ),
    Category(
      name: 'Beverages',
      imageUrl: 'assets/images/categories/cat_beverages.png',
      backgroundColor: const Color(0xFFEFF7FF), // soft blue
      borderColor: const Color(0xFFBBDFFF),
    ),
    Category(
      name: 'Meat & Fish',
      imageUrl: 'assets/images/categories/cat_meat_fish.png',
      backgroundColor: const Color(0xFFFFEEF1), // soft pink
      borderColor: const Color(0xFFFFC7D1),
    ),
    Category(
      name: 'Snacks',
      imageUrl: 'assets/images/categories/cat_snacks.png',
      backgroundColor: const Color(0xFFFFF1E6), // soft peach
      borderColor: const Color(0xFFFFD4B3),
    ),
    Category(
      name: 'Dairy',
      imageUrl: 'assets/images/categories/cat_dairy.png',
      backgroundColor: const Color(0xFFFFF6DD), // soft yellow
      borderColor: const Color(0xFFFFE9A9),
    ),
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
          color: category.backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: category.borderColor, width: 1),
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
