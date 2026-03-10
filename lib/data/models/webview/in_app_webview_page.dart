import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebviewPage extends StatefulWidget {
  const InAppWebviewPage({super.key});

  @override
  State<InAppWebviewPage> createState() => _InAppWebviewPageState();
}

class _InAppWebviewPageState extends State<InAppWebviewPage> {
  late final String title;
  late final String url;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments as Map<String, dynamic>? ?? {};
    title = (args['title'] as String?)?.trim().isNotEmpty == true
        ? args['title'] as String
        : 'Web View';
    url = (args['url'] as String?) ?? 'https://www.google.com';

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            Get.snackbar(
              'Không tải được trang',
              error.description,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: kIsWeb
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'webview_flutter không hỗ trợ Flutter Web.\nHãy mở link này trên mobile app:\n$url',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : WebViewWidget(controller: controller),
    );
  }
}
