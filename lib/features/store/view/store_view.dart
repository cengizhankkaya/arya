import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/store_view_model.dart';
import 'product_detail_view.dart';
import '../view_model/cart_view_model.dart';
import 'cart_view.dart';
import 'package:arya/features/auth/view/profile_view.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ürün Ara'),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartView()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _CountryDropdown(),
            Padding(padding: const EdgeInsets.all(8.0), child: _SearchBar()),
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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Ürün ara...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Provider.of<StoreViewModel>(
              context,
              listen: false,
            ).search(_controller.text);
          },
        ),
      ],
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, model, child) {
        return DropdownButton<String>(
          value: model.selectedCountry.isEmpty ? null : model.selectedCountry,
          hint: Text('Ülke seç'),
          items: model.countries
              .map(
                (country) =>
                    DropdownMenuItem(value: country, child: Text(country)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              model.setCountry(value);
            }
          },
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
        return ListView.builder(
          itemCount: model.products.length,
          itemBuilder: (context, index) {
            final product = model.products[index];
            return ListTile(
              title: Text(product['product_name'] ?? 'İsimsiz'),
              subtitle: Text(product['brands'] ?? ''),
              leading: product['image_thumb_url'] != null
                  ? Image.network(product['image_thumb_url'], width: 50)
                  : null,
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  Provider.of<CartViewModel>(
                    context,
                    listen: false,
                  ).addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ürün sepete eklendi')),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailView(product: product),
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
