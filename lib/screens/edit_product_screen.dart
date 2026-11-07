
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../models/product_model.dart';
import '../providers/product_providers.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _priceController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.product.title ?? '',
    );

    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (price == null || price <= 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProduct = widget.product.copyWith(
        title: title,
        price: price,
      );

      final success = await context.read<ProductProvider>().updateProduct(
        widget.product.id!,
        updatedProduct,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil memperbarui produk'),
            backgroundColor: Colors.green,
          ),
        );

        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memperbarui produk'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        title: const Text(
          'Edit Produk',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFD6E2EC),
        foregroundColor: const Color(0xFF2C3E50),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perbarui Informasi Produk',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Ubah nama atau harga produk sesuai kebutuhan.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7B8794),
                ),
              ),

              const SizedBox(height: 25),

              // NAMA PRODUK
              const Text(
                'Nama Produk',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama produk',
                  prefixIcon: const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFDCE3EA),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // HARGA PRODUK
              const Text(
                'Harga Produk',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan harga produk',
                  prefixIcon: const Icon(
                    Icons.payments_outlined,
                  ),
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFDCE3EA),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga produk tidak boleh kosong';
                  }

                  final price = double.tryParse(value.trim());

                  if (price == null) {
                    return 'Masukkan harga berupa angka';
                  }

                  if (price <= 0) {
                    return 'Harga harus lebih dari 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // TOMBOL PERBARUI
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _update,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C7AEA),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Perbarui Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
