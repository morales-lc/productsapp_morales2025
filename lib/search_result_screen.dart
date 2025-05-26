import 'package:flutter/material.dart';
import 'config.dart';
import 'productinfo.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;
  final List<Map<String, dynamic>> allProducts;
  final List<Map<String, dynamic>> categories;

  const SearchResultScreen({
    super.key,
    required this.query,
    required this.allProducts,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final lowerQuery = query.toLowerCase();
    final queryWords =
        lowerQuery.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final matchedCategory = categories.firstWhere(
      (cat) => cat['name'].toString().toLowerCase() == lowerQuery,
      orElse: () => <String, dynamic>{},
    );
    final results = allProducts.where((product) {
      final name = (product['name'] ?? '').toString().toLowerCase();
      final nameWords =
          name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
      final nameMatch = queryWords
          .any((q) => nameWords.any((nw) => nw.contains(q) || q.contains(nw)));
      final categoryMatch = matchedCategory.isNotEmpty &&
          product['category_id'] == matchedCategory['id'];
      return nameMatch || categoryMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: results.isEmpty
          ? Center(
              child: Text('No results found.',
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.separated(
              padding: EdgeInsets.all(18),
              itemCount: results.length,
              separatorBuilder: (context, i) => SizedBox(height: 18),
              itemBuilder: (context, i) {
                final product = results[i];
                final imageWidget = product['image_path'] != null &&
                        product['image_path'].toString().isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          '${product['image_path'].toString().startsWith('http') ? '' : '${AppConfig.baseUrl}/storage/'}${product['image_path']}',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/product_placeholder.png',
                                  width: 90, height: 90, fit: BoxFit.cover),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset('assets/product_placeholder.png',
                            width: 90, height: 90, fit: BoxFit.cover),
                      );
                // Highlight query in product name
                final productName = product['name'] ?? '';
                final spans = <TextSpan>[];
                String nameLower = productName.toString().toLowerCase();
                int start = 0;
                for (final word in queryWords) {
                  int idx = nameLower.indexOf(word, start);
                  if (idx >= 0) {
                    if (idx > start) {
                      spans.add(TextSpan(
                          text: productName.toString().substring(start, idx)));
                    }
                    spans.add(TextSpan(
                        text: productName
                            .toString()
                            .substring(idx, idx + word.length),
                        style: TextStyle(
                            backgroundColor: Colors.yellow.withOpacity(0.5),
                            fontWeight: FontWeight.bold)));
                    start = idx + word.length;
                  }
                }
                if (start < productName.toString().length) {
                  spans.add(
                      TextSpan(text: productName.toString().substring(start)));
                }
                return Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(18),
                  shadowColor: Colors.black12,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageWidget,
                          SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                    children: spans.isNotEmpty
                                        ? spans
                                        : [
                                            TextSpan(
                                                text: productName.toString())
                                          ],
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  product['description'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text('₱${product['price'] ?? ''}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 18, color: Colors.grey[400]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
