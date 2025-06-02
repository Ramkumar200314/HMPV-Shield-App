import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WorldStatScreen extends StatefulWidget {
  @override
  _WorldStatScreenState createState() => _WorldStatScreenState();
}

class _WorldStatScreenState extends State<WorldStatScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://nextstrain.org/hmpv/all/genome'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HMPV Phylogeny'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
