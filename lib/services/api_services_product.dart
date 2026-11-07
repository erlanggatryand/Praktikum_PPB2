
import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ApiServiceProducts {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost/products_api/api.php',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // READ: mengambil semua produk
  Future<ProductResponse> getAllProducts({
    int limit = 100,
    int skip = 0,
  }) async {
    final response = await _dio.get('');
    return ProductResponse.fromJson(response.data);
  }

  // READ: mengambil satu produk
  Future<Product> getProduct(int id) async {
    final response = await _dio.get(
      '',
      queryParameters: {'id': id},
    );

    return Product.fromJson(response.data['product']);
  }

  // Mengambil daftar kategori unik
  Future<List<String>> getCategoryList() async {
    final response = await _dio.get('');
    final products = response.data['products'] as List;

    return products
        .map((item) => item['category'].toString())
        .toSet()
        .toList();
  }

  // SEARCH: mencari produk berdasarkan nama
  Future<ProductResponse> searchProducts(String query) async {
    final response = await _dio.get('');
    final products = response.data['products'] as List;

    final filtered = products.where((item) {
      return item['title']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    return ProductResponse.fromJson({
      'products': filtered,
      'total': filtered.length,
      'skip': 0,
      'limit': filtered.length,
    });
  }

  // FILTER: berdasarkan kategori
  Future<ProductResponse> getProductsByCategory(String category) async {
    final response = await _dio.get('');
    final products = response.data['products'] as List;

    final filtered = products.where((item) {
      return item['category'].toString().toLowerCase() ==
          category.toLowerCase();
    }).toList();

    return ProductResponse.fromJson({
      'products': filtered,
      'total': filtered.length,
      'skip': 0,
      'limit': filtered.length,
    });
  }

  // SORT: berdasarkan kolom dan urutan
  Future<ProductResponse> sortProducts(
    String sortBy,
    String order,
  ) async {
    final response = await _dio.get('');
    final products = response.data['products'] as List;

    final sorted = List<dynamic>.from(products);

    sorted.sort((a, b) {
      int result;

      if (sortBy == 'price' || sortBy == 'rating' || sortBy == 'stock') {
        result = double.parse(a[sortBy].toString())
            .compareTo(double.parse(b[sortBy].toString()));
      } else {
        result = a[sortBy]
            .toString()
            .toLowerCase()
            .compareTo(b[sortBy].toString().toLowerCase());
      }

      return order.toLowerCase() == 'desc' ? -result : result;
    });

    return ProductResponse.fromJson({
      'products': sorted,
      'total': sorted.length,
      'skip': 0,
      'limit': sorted.length,
    });
  }

  // CREATE: menambahkan produk
  Future<void> addProduct(Map<String, dynamic> data) async {
    await _dio.post('', data: data);
  }

  // UPDATE: mengubah produk
  Future<void> updateProduct(int id, Map<String, dynamic> data) async {
    await _dio.put(
      '',
      queryParameters: {'id': id},
      data: data,
    );
  }

  // DELETE: menghapus produk
  Future<void> deleteProduct(int id) async {
    await _dio.delete(
      '',
      queryParameters: {'id': id},
    );
  }
}
