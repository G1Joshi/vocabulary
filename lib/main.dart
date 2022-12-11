import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Vocabulary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController? controller;
  final url = 'https://feedium.app/getvocab.php';
  int value = 0;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    if (kIsWeb) {
      WebView.platform = WebWebViewPlatform();
    } else if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: error
                ? const Text(
                    'Something went wrong!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      wordSpacing: 1,
                      fontSize: 16,
                    ),
                  )
                : WebView(
                    onProgress: (val) => setState(() => value = val),
                    onPageStarted: (_) => setState(() => loading = true),
                    onPageFinished: (_) => setState(() => loading = false),
                    onWebViewCreated: (control) => controller = control,
                    onWebResourceError: (_) => setState(() => error = true),
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
          ),
          Visibility(
            visible: loading,
            child: Container(
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  const Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(strokeWidth: 5),
                    ),
                  ),
                  Center(
                    child: Text(
                      '$value%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !loading,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              value = 0;
              loading = true;
              error = false;
            });
            controller?.reload();
          },
          tooltip: 'Refresh',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
