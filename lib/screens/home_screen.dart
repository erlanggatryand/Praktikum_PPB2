import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_providers.dart';

// ==================== HALAMAN DETAIL PRODUK (BLUE/LAVENDER PASTEL) ====================
class ProductDetailScreen extends StatelessWidget {
  final dynamic product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text(
          product.title ?? 'Detail Produk',
          style: const TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
        ),
        backgroundColor: const Color(0xFFD6E2EC),
        foregroundColor: const Color(0xFF2C3E50),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: const Color(0xFFE9EEF4),
              child: Image.network(
                product.thumbnail ?? '',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price ?? 0}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5C7AEA),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFD0DCE5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
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
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFF4F6F9),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Produk dimasukkan ke keranjang!'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFBAC8E0)),
                  backgroundColor: const Color(0xFFE8EDF5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '+ Keranjang',
                  style: TextStyle(
                    color: Color(0xFF2C3E50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Menuju halaman checkout...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5C7AEA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Beli Sekarang',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HALAMAN UTAMA (HOME SCREEN - FLAT PASTEL) ====================
// Palet warna pastel HomeScreen:
//   Background   : 0xFFFFF9FB   Lavender   : 0xFFE8DFF5
//   Lavender muda: 0xFFF3ECFA   Pink       : 0xFFF9E3EE
//   Peach        : 0xFFFFC9B9   Kuning     : 0xFFFFF3CF
//   Teks utama   : 0xFF4A4458   Teks kedua : 0xFF7B7389
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'Default';

  // Menyimpan judul produk yang di-favoritkan (ikon hati)
  final Set<String> _favorites = {};

  // Warna kartu produk yang bergantian
  static const List<Color> _cardColors = [
    Color(0xFFE8DFF5), // lavender
    Color(0xFFF9E3EE), // pink
    Color(0xFFFFE5DC), // peach muda
    Color(0xFFFFF3CF), // kuning pastel
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProduct();
      Provider.of<ProductProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    // Menambahkan opsi 'ALL' ke dalam daftar kategori
    List<String> categories = ['ALL', ...productProvider.categoryList];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFFFF9FB),
        toolbarHeight: 64,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC9B9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC9B9).withOpacity(0.6),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                color: Color(0xFF4A4458),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, selamat datang 👋',
                  style: TextStyle(color: Color(0xFF7B7389), fontSize: 11),
                ),
                Text(
                  'Store App',
                  style: TextStyle(
                    color: Color(0xFF4A4458),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DFF5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Color(0xFF4A4458),
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
                // Titik penanda di pojok ikon keranjang
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF08FA8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE8DFF5),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar (flat dengan outline tipis)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3ECFA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8DFF5)),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Color(0xFF4A4458), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari produk, merek, atau kategori...',
                  hintStyle: TextStyle(
                    color: const Color(0xFF4A4458).withOpacity(0.45),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9C89D9),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF7B7389),
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                            productProvider.searchProducts('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
                onChanged: (query) {
                  setState(() {});
                  productProvider.searchProducts(query);
                },
              ),
            ),
          ),

          // Header Kategori & Sort Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB8A4E3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Kategori',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A4458),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3ECFA),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFE8DFF5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      isDense: true,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      icon: const Icon(
                        Icons.swap_vert_rounded,
                        size: 14,
                        color: Color(0xFF9C89D9),
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A4458),
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedSort = newValue;
                          });
                        }
                      },
                      items: <String>['Default', 'Termurah', 'Termahal']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('Harga: $value'),
                            );
                          })
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Horizontal Category List
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected =
                    (productProvider.selectedCategory == category) ||
                    (category == 'ALL' &&
                        productProvider.selectedCategory == null);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 7.0,
                  ),
                  child: ChoiceChip(
                    label: Text(category.toUpperCase()),
                    labelStyle: TextStyle(
                      color: const Color(0xFF4A4458),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 11,
                    ),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFFC9B9),
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    elevation: 0,
                    pressElevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : const Color(0xFFE8DFF5),
                      ),
                    ),
                    onSelected: (bool selected) {
                      if (category == 'ALL') {
                        productProvider.fetchProduct();
                      } else if (selected) {
                        productProvider.filterByCategory(category);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          // Section Header "Daftar Produk" dan Jumlah Item
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC9B9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Daftar Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A4458),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DFF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${productProvider.product.length} item',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B63C9),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid View Produk
          Expanded(
            child: productProvider.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFB8A4E3)),
                  )
                : productProvider.product.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Color(0xFFDCD0F0),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Produk tidak ditemukan",
                          style: TextStyle(
                            color: Color(0xFF7B7389),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemCount: productProvider.product.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.product[index];
                      final Color cardColor =
                          _cardColors[index % _cardColors.length];
                      final String productKey = (product.title ?? '$index')
                          .toString();
                      final bool isFav = _favorites.contains(productKey);

                      return InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: cardColor.withOpacity(0.7),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar Produk (bingkai putih membulat) + tombol favorit
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Image.network(
                                            product.thumbnail ?? '',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons.image_outlined,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                      ),
                                      // Tombol Favorit (hati)
                                      Positioned(
                                        top: 6,
                                        right: 6,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isFav) {
                                                _favorites.remove(productKey);
                                              } else {
                                                _favorites.add(productKey);
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              size: 14,
                                              color: isFav
                                                  ? const Color(0xFFF08FA8)
                                                  : const Color(0xFF7B7389),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Detail Teks, Rating & Tombol Keranjang
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    0,
                                    10,
                                    10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  (product.category ?? '')
                                                      .toString()
                                                      .toUpperCase(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                    color: Color(0xFF7B7389),
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.star_rounded,
                                                color: Color(0xFFF2A93B),
                                                size: 13,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                '${product.rating ?? 4.0}',
                                                style: const TextStyle(
                                                  color: Color(0xFF4A4458),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            product.title ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: Color(0xFF4A4458),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${product.price ?? 0}',
                                            style: const TextStyle(
                                              color: Color(0xFF4A4458),
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                            ),
                                          ),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            onTap: () {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${product.title} ditambahkan ke keranjang!',
                                                  ),
                                                  duration: const Duration(
                                                    seconds: 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF4A4458),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.add_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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