import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:web_fetcher/core/models/web_site.dart';
import 'package:web_fetcher/platforms/pages/webview_fetch_page.dart';
import 'package:webview_all/webview_all.dart';

class WebviewPage extends StatefulWidget {
  const new({super.key, required this.site});
  final WebSite site;

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late WebViewController controller;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.site.url))
    //
    ;
    super.initState();
  }

  void fetch() async {
    context.pushMaterialPageRoute(
      builder: (mainCtx) =>
          WebviewFetchPage(controller: controller, site: widget.site),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canGoback = await controller.canGoBack();
        if (!context.mounted) return;
        if (canGoback) {
          await controller.goBack();
          return;
        }
        context.pop();
      },
      child: Scaffold(
        appBar: _appbar(),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  AppBar _appbar() => AppBar(
    title: Text(widget.site.title),
    actions: [
      FutureBuilder(
        future: controller.canGoBack(),
        builder: (context, asyncSnapshot) {
          final enable = asyncSnapshot.data ?? false;
          return IconButton(
            onPressed: !enable
                ? null
                : () async {
                    await controller.goBack();
                  },
            icon: Icon(Icons.arrow_back_ios_new_outlined),
          );
        },
      ),
      FutureBuilder(
        future: controller.canGoForward(),
        builder: (context, asyncSnapshot) {
          final enable = asyncSnapshot.data ?? false;
          return IconButton(
            onPressed: !enable
                ? null
                : () async {
                    await controller.goForward();
                  },
            icon: Icon(Icons.arrow_forward_ios_outlined),
          );
        },
      ),
      SizedBox(width: 20),
      IconButton(onPressed: fetch, icon: Icon(Icons.download_outlined)),
    ],
  );
}
