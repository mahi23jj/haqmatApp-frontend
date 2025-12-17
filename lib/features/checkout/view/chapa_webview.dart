// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewPaymentScreen extends StatelessWidget {
//   final String url;

//   const WebViewPaymentScreen({super.key, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Complete Payment")),
//       body: WebViewWidget(
//         controller: WebViewController()
//           ..setJavaScriptMode(JavaScriptMode.unrestricted)
//           ..loadRequest(Uri.parse(url)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPaymentScreen extends StatefulWidget {
  final String url;

  const WebViewPaymentScreen({super.key, required this.url});

  @override
  State<WebViewPaymentScreen> createState() => _WebViewPaymentScreenState();
}

class _WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  late InAppWebViewController _webViewController;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
            onLoadStart: (controller, url) {
              print("Loading started: $url");
            },
            onLoadStop: (controller, url) {
              print("Loading finished: $url");
            },
            onReceivedError: (controller, request, error) {
              print("Error loading: $error");
            },
          ),
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
        ],
      ),
    );
  }
}
