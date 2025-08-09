import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/store_view_model.dart';
import 'product_detail_view.dart';
import '../view_model/cart_view_model.dart';

class ProductsPage extends StatelessWidget {
  final String? initialCategory;

  ProductsPage({this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = StoreViewModel();
        if (initialCategory != null && initialCategory!.isNotEmpty) {
          vm.fetchByCategory(initialCategory!);
        } else {
          vm.fetchRandomProducts();
        }
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            initialCategory?.isNotEmpty == true ? initialCategory! : 'Ürün Ara',
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFF8F8F8),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _CountryDropdown(),
                  const SizedBox(height: 16),
                  _SearchBar(),
                ],
              ),
            ),
            Expanded(child: _ProductList()),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: TextField(
        style: const TextStyle(color: Color(0xFF333333)),
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Ürün ara...',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF7C7C7C)),
            onPressed: () {
              final viewModel = Provider.of<StoreViewModel>(
                context,
                listen: false,
              );
              final query = _controller.text.trim();
              if (query.isEmpty) {
                viewModel.fetchRandomProducts();
              } else {
                viewModel.search(query);
              }
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF7C7C7C), width: 2),
          ),
        ),
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        return Container(
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: model.selectedCountry.isEmpty ? null : model.selectedCountry,
            hint: const Text('Ülke seç', style: TextStyle(color: Colors.grey)),
            items: model.countries
                .map(
                  (country) => DropdownMenuItem(
                    value: country,
                    child: Text(
                      country,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                model.setCountry(value);
              }
            },
            underline: Container(),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF7C7C7C),
            ),
            dropdownColor: Colors.white,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        );
      },
    );
  }
}

class _ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        if (model.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (model.products.isEmpty) {
          return Center(child: Text('Ürün bulunamadı'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemCount: model.products.length,
          itemBuilder: (context, index) {
            final product = model.products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailView(product: product),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: product['image_thumb_url'] != null
                          ? Image.network(
                              product['image_thumb_url'],
                              fit: BoxFit.contain,
                            )
                          : Icon(Icons.image_not_supported, size: 48),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product['product_name'] ?? 'Ürün adı yok',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['brands'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        color: Color(0xFF7C7C7C),
                      ),
                      onPressed: () {
                        Provider.of<CartViewModel>(
                          context,
                          listen: false,
                        ).addToCart(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ürün sepete eklendi')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
