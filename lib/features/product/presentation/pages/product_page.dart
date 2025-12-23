import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductPage extends StatelessWidget {
  final String productId;
  final Map<String, dynamic>? notificationData;

  const ProductPage({super.key, required this.productId, this.notificationData});

  @override
  Widget build(BuildContext context) {
    // Extract notification data
    final title = notificationData?['title'] as String? ?? 'Product Details';
    final body = notificationData?['body'] as String? ?? 'View product information';
    final productName = notificationData?['productName'] as String? ?? 'Product $productId';
    final productPrice = notificationData?['productPrice'] as String? ?? 'N/A';
    final source = notificationData?['source'] as String? ?? 'direct';
    final rawData = notificationData?['notificationData'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/home')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product ID Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ID: $productId',
                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // Notification Source Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          source == 'local_notification' ? Icons.notifications_active : Icons.cloud_queue,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Opened from Notification',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Source: ${source == 'local_notification' ? 'Local Notification' : 'Push Notification'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notification Content Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Content',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Title', title),
                    const Divider(),
                    _buildInfoRow('Message', body),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Information Card
            Card(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_bag, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Product Information',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Product Name', productName),
                    const Divider(),
                    _buildInfoRow('Price', '\$$productPrice'),
                    const Divider(),
                    _buildInfoRow('Product ID', productId),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Raw Data Card (if available)
            if (rawData != null && rawData.isNotEmpty) ...[
              Card(
                child: ExpansionTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Raw Notification Data'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                        child: SelectableText(
                          _formatJson(rawData),
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Simulate adding to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$productName added to cart'), behavior: SnackBarBehavior.floating),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Simulate sharing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product shared!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  String _formatJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}
