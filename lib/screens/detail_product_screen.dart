
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/product_model.dart';
import '../providers/product_providers.dart';
import '../services/api_services_product.dart';

class DetailProductScreen extends StatefulWidget {
  final int productId;

  const DetailProductScreen({
    super.key,
    required this.productId,
  });

  @override
  State<DetailProductScreen> createState() =>
      _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  void _loadProduct() {
    _productFuture = ApiServiceProducts().getProduct(widget.productId);
  }

  Future<void> _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: Text(
            'Yakin ingin menghapus ${product.title}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    try {
      final success = await context
          .read<ProductProvider>()
          .deleteProduct(widget.productId);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus produk'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editProduct(Product product) {
    context.push(
      '/edit/${product.id}',
      extra: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        backgroundColor: const Color(0xFFD6E2EC),
        foregroundColor: const Color(0xFF2C3E50),
        elevation: 0,

        actions: [
          FutureBuilder<Product>(
            future: _productFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final product = snapshot.data!;

              return Row(
                children: [
                  IconButton(
                    tooltip: 'Edit Produk',
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editProduct(product);
                    },
                  ),
                  IconButton(
                    tooltip: 'Hapus Produk',
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteProduct(product);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Gagal memuat produk: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Produk tidak ditemukan'),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GAMBAR PRODUK
                Container(
                  height: 300,
                  width: double.infinity,
                  color: const Color(0xFFE9EEF4),
                  child: CachedNetworkImage(
                    imageUrl: product.thumbnail ?? '',
                    fit: BoxFit.contain,
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                // INFORMASI PRODUK
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title ?? 'Nama Produk',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Rp ${product.price ?? 0}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C7AEA),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Divider(
                        color: Color(0xFFD0DCE5),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Informasi Produk',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _infoItem(
                        'Kategori',
                        product.category ?? '-',
                      ),

                      _infoItem(
                        'Brand',
                        product.brand ?? '-',
                      ),

                      _infoItem(
                        'Stok',
                        '${product.stock ?? 0}',
                      ),

                      _infoItem(
                        'Rating',
                        '${product.rating ?? 0} ⭐',
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Deskripsi Produk',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        product.description ??
                            'Tidak ada deskripsi untuk produk ini.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5A6B7C),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // TOMBOL KERANJANG DAN BELI
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFF4F6F9),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Produk dimasukkan ke keranjang!',
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF5C7AEA),
                    side: const BorderSide(
                      color: Color(0xFF5C7AEA),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  child: const Text('+ Keranjang'),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Menuju halaman checkout...',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C7AEA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Beli Sekarang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7B8794),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
