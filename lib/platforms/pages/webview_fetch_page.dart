import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_fetcher/core/models/web_site.dart';
import 'package:web_fetcher/platforms/components/dialog/error_alert_dialog.dart';
import 'package:web_fetcher/platforms/components/dialog/snack_alert.dart';
import 'package:webview_all/webview_all.dart';

class WebviewFetchPage extends StatefulWidget {
  const new({super.key, required this.controller, required this.site});
  final WebSite site;
  final WebViewController controller;

  @override
  State<WebviewFetchPage> createState() => _WebviewFetchPageState();
}

///fiction-info
class _WebviewFetchPageState extends State<WebviewFetchPage> {
  bool isLoading = false;
  String result = '';
  void fetch(String jsCode) async {
    try {
      setState(() {
        isLoading = true;
      });
      final res = await widget.controller.runJavaScriptReturningResult(jsCode);
      if (res is String) {
        result = res; //.replaceAll('', '\n');
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, e.toString());
    }
  }

  void copyText() async {
    await Clipboard.setData(.new(text: result));
    if (!mounted) return;
    showSnackbar(context, 'Copied');
  }

  void create() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetcher')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _headerWidget,
            Divider(),
            Row(
              children: [
                Text(
                  'Result',
                  style: TextStyle(fontWeight: .w700, fontSize: 18),
                ),
                Spacer(),
                if (result.isNotEmpty && result != 'null')
                  FilledButton(
                    onPressed: copyText,
                    child: Text('Copy Content'),
                  ),
              ],
            ),
            SizedBox(height: 10),
            _resultWidget,
          ],
        ),
      ),
    );
  }

  Widget get _headerWidget {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton(
          onPressed: () {
            fetch("document.querySelector('body').innerHTML");
          },
          child: Text('Body Html'),
        ),
        FilledButton(
          onPressed: () {
            fetch("document.querySelector('body').textContent");
          },
          child: Text('Body textContent'),
        ),
        FilledButton(
          onPressed: () {
            fetch("document.querySelector('.fiction-info').innerText");
          },
          child: Text('fiction-info'),
        ),
        IconButton(onPressed: create, icon: Icon(Icons.add_circle_outline)),
      ],
    );
  }

  Widget get _resultWidget {
    if (isLoading) {
      return Center(child: CircularProgressIndicator.adaptive());
    }
    return SelectableText(result);
  }
}
