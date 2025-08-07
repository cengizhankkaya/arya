import 'package:arya/features/profile/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/store_view_model.dart';
import 'product_detail_view.dart';
import '../view_model/cart_view_model.dart';
import 'cart_view.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          StoreViewModel()
            ..fetchRandomProducts(), // İlk açılışta rastgele ürünleri getir
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
            final viewModel = Provider.of<StoreViewModel>(
              context,
              listen: false,
            );
            final query = _controller.text.trim();
            if (query.isEmpty) {
              viewModel.fetchRandomProducts(); // boşsa random getir
            } else {
              viewModel.search(query); // arama yap
            }
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

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
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
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
                      const SizedBox(height: 8),
                      Text(
                        product['product_name'] ?? 'Ürün adı yok',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['brands'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          Provider.of<CartViewModel>(
                            context,
                            listen: false,
                          ).addToCart(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ürün sepete eklendi'),
                            ),
                          );
                        },
                      ),
                    ],
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

// class ProductsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => StoreViewModel(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Ürün Ara'),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.shopping_cart),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CartView()),
//                 );
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.person),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProfileScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             _CountryDropdown(),
//             Padding(padding: const EdgeInsets.all(8.0), child: _SearchBar()),
//             Expanded(child: _ProductList()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SearchBar extends StatefulWidget {
//   @override
//   State<_SearchBar> createState() => _SearchBarState();
// }

// class _SearchBarState extends State<_SearchBar> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _controller,
//             decoration: InputDecoration(
//               hintText: 'Ürün ara...',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.search),
//           onPressed: () {
//             Provider.of<StoreViewModel>(
//               context,
//               listen: false,
//             ).search(_controller.text);
//           },
//         ),
//       ],
//     );
//   }
// }

// class _CountryDropdown extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<StoreViewModel>(
//       builder: (context, model, child) {
//         return DropdownButton<String>(
//           value: model.selectedCountry.isEmpty ? null : model.selectedCountry,
//           hint: Text('Ülke seç'),
//           items: model.countries
//               .map(
//                 (country) =>
//                     DropdownMenuItem(value: country, child: Text(country)),
//               )
//               .toList(),
//           onChanged: (value) {
//             if (value != null) {
//               model.setCountry(value);
//             }
//           },
//         );
//       },
//     );
//   }
// }

// class _ProductList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<StoreViewModel>(
//       builder: (context, model, child) {
//         if (model.isLoading) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (model.products.isEmpty) {
//           return Center(child: Text('Ürün bulunamadı'));
//         }

//         return GridView.builder(
//           padding: const EdgeInsets.all(12),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2, // 2 sütunlu grid
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: 0.75,
//           ),
//           itemCount: model.products.length,
//           itemBuilder: (context, index) {
//             final product = model.products[index];
//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailView(product: product),
//                   ),
//                 );
//               },
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: product['image_thumb_url'] != null
//                             ? Image.network(
//                                 product['image_thumb_url'],
//                                 fit: BoxFit.contain,
//                               )
//                             : Icon(Icons.image_not_supported, size: 48),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         product['product_name'] ?? 'Ürün adı yok',
//                         textAlign: TextAlign.center,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         product['brands'] ?? '',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       IconButton(
//                         icon: const Icon(Icons.add_shopping_cart),
//                         onPressed: () {
//                           Provider.of<CartViewModel>(
//                             context,
//                             listen: false,
//                           ).addToCart(product);

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Ürün sepete eklendi'),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
