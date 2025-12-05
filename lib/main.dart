import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: MmMallApp()));

class MmMallApp extends StatelessWidget {
  const MmMallApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MM Mall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.amber),
      home: const ProductGridPage(),
    );
  }
}

/* ---------- STATE ---------- */
final cartProvider = StateProvider<List<Product>>((ref) => []);

class Product {
  final int id;
  final String name;
  final int price;
  final String image;
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.image});
}

final productList = [
  Product(id: 1, name: 'Shan Noodle', price: 800, image: ''),
  Product(id: 2, name: 'Laphet Thoke', price: 1200, image: ''),
  Product(id: 3, name: 'Myanmar Coffee', price: 2500, image: ''),
  Product(id: 4, name: 'Longyi', price: 5500, image: ''),
];

/* ---------- UI ---------- */
class ProductGridPage extends ConsumerWidget {
  const ProductGridPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MM Mall'),
        actions: [
          Badge(
            label: Text('${cart.length}'),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cart total: ${cart.length} items')),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: productList.length,
        itemBuilder: (_, i) => ProductCard(product: productList[i]),
      ),
    );
  }
}

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inCart = ref.watch(cartProvider).contains(product);
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const FlutterLogo(size: 60),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${product.price} Ks',
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 6),
                FilledButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).update((state) {
                      if (inCart) {
                        return state.where((p) => p.id != product.id).toList();
                      }
                      return [...state, product];
                    });
                  },
                  child: Text(inCart ? 'Remove' : 'Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
