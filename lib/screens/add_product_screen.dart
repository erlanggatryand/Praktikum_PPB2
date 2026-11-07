import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/api_services_product.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final ApiServiceProducts _api = ApiServiceProducts();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final category = _categoryController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga harus berupa angka lebih dari 0'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _api.addProduct({
        'title': title,
        'description': '',
        'category': category,
        'price': price,
        'thumbnail': '',
        'stock': 0,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambah produk: $e'),
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
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
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
                'Tambah Produk Baru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Lengkapi informasi produk di bawah ini.',
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
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
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
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Masukkan harga produk',
                  prefixIcon: const Icon(Icons.payments_outlined),
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

              const SizedBox(height: 20),

              // KATEGORI PRODUK
              const Text(
                'Kategori Produk',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _categoryController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Contoh: beauty, electronics, furniture',
                  prefixIcon: const Icon(Icons.category_outlined),
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
                    return 'Kategori produk tidak boleh kosong';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
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
                          'Simpan Produk',
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