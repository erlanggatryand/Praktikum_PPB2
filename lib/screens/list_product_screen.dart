
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../providers/product_providers.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() =>
      _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProduct();
      context.read<ProductProvider>().fetchCategories();
    });
  }

  Future<void> _deleteProduct(int id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text(
          'Yakin ingin menghapus $title?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final success = await context
        .read<ProductProvider>()
        .deleteProduct(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Produk berhasil dihapus'
              : 'Gagal menghapus produk',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan harga tertinggi',
            onPressed: () {
              provider.sortProducts('price', 'desc');
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    provider.fetchProduct();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: provider.searchProducts,
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.categoryList.length,
              itemBuilder: (context, index) {
                final category = provider.categoryList[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  child: ChoiceChip(
                    label: Text(category),
                    selected:
                        provider.selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        provider.filterByCategory(category);
                      } else {
                        provider.fetchProduct();
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(),

          Expanded(
            child: provider.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.error != null
                    ? Center(
                        child: Text(
                          'Error: ${provider.error}',
                        ),
                      )
                    : provider.product.isEmpty
                        ? const Center(
                            child: Text('Belum ada produk'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              bottom: 90,
                            ),
                            itemCount: provider.product.length,
                            itemBuilder: (context, index) {
                              final product =
                                  provider.product[index];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            EdgeInsets.zero,
                                        leading: CachedNetworkImage(
                                          imageUrl:
                                              product.thumbnail ?? '',
                                          width: 65,
                                          height: 65,
                                          fit: BoxFit.cover,
                                          errorWidget:
                                              (_, __, ___) =>
                                                  const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                          ),
                                        ),
                                        title: Text(
                                          product.title ?? '',
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Harga: \$${product.price}\n'
                                          'Kategori: ${product.category}',
                                        ),
                                        onTap: () {
                                          context.go(
                                            '/detail/${product.id}',
                                          );
                                        },
                                      ),

                                      const Divider(),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {
                                                context.go(
                                                  '/edit/${product.id}',
                                                  extra: product,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Edit',
                                              ),
                                              style:
                                                  OutlinedButton
                                                      .styleFrom(
                                                foregroundColor:
                                                    Colors.blue,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 10),

                                          Expanded(
                                            child: ElevatedButton
                                                .icon(
                                              onPressed: () {
                                                if (product.id !=
                                                    null) {
                                                  _deleteProduct(
                                                    product.id!,
                                                    product.title ??
                                                        'Produk',
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                'Hapus',
                                              ),
                                              style:
                                                  ElevatedButton
                                                      .styleFrom(
                                                backgroundColor:
                                                    Colors.red,
                                                foregroundColor:
                                                    Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
