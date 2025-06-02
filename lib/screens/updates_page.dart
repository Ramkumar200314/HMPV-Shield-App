import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

class UpdatesPage extends StatefulWidget {
  final Color color;
  final String imgPath;

  const UpdatesPage({required this.color, required this.imgPath});

  @override
  _UpdatesPageState createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  List<dynamic> _newsArticles = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNews();

    // Initialize WebView for both Android and iOS platforms
    if (Platform.isAndroid || Platform.isIOS) {
      WebViewWidget(
        controller: WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted),
      );
    }
  }

  Future<void> _fetchNews() async {
    final url =
        'https://newsapi.org/v2/everything?q=hmpv&language=en&apiKey=bb2225b1edd14c479ea67b09353535c6';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'ok' && data['articles'] != null) {
          setState(() {
            _newsArticles = data['articles'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No articles found or unexpected response from API.';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load news. Status Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: ${e.toString()}';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HMPV Virus Updates'),
        backgroundColor: widget.color,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text('Error: $_errorMessage'))
              : ListView.builder(
                  itemCount: _newsArticles.length,
                  itemBuilder: (context, index) {
                    final article = _newsArticles[index];
                    return NewsCard(article: article);
                  },
                ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final dynamic article;

  NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (article['url'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(url: article['url']),
            ),
          );
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (article['urlToImage'] != null)
                Image.network(
                  article['urlToImage'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    );
                  },
                ),
              SizedBox(height: 8),
              if (article['title'] != null)
                Text(
                  article['title'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 8),
              if (article['description'] != null)
                Text(
                  article['description'],
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              SizedBox(height: 10),
              if (article['source'] != null)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Source: ${article['source']['name']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        backgroundColor: Colors.blue,
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse(url))
          ..setJavaScriptMode(JavaScriptMode.unrestricted),
      ),
    );
  }
}
