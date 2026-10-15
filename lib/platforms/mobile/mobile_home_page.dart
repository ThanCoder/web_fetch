import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:web_fetcher/core/controller/i_controller.dart';
import 'package:web_fetcher/core/controller/web_site_controller.dart';
import 'package:web_fetcher/core/models/web_site.dart';
import 'package:web_fetcher/core/utils/app_util.dart';
import 'package:web_fetcher/platforms/mobile/create_web_project_sheet.dart';
import 'package:web_fetcher/platforms/mobile/website_item_menu_sheet.dart';
import 'package:web_fetcher/platforms/pages/webview_page.dart';

class MobileHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage> {
  @override
  void initState() {
    super.initState();
  }

  final con = ControllerManager.read<WebSiteController>();

  void create() async {
    final res = await CreateWebProjectSheet.show(context);
    if (res == null) return;
    con.add(res);
  }

  void showItemMenu(WebSite site) async {
    WebsiteItemMenuSheet.show(context, site: site);
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppUtil.instance.appName),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: con.fetchList,
              icon: Icon(Icons.refresh_outlined),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: create,
        child: Icon(Icons.add_outlined),
      ),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _body),
    );
  }

  Widget get _body {
    return StreamBuilder(
      stream: con.events.whereType<WebSiteDataChanged>(),
      builder: (context, asyncSnapshot) {
        return RefreshIndicator.adaptive(
          onRefresh: con.fetchList,
          child: ListView.separated(
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = con.list[index];
              return listItem(item);
            },
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemCount: con.list.length,
          ),
        );
      },
    );
  }

  Widget listItem(WebSite site) {
    return GestureDetector(
      onLongPress: () => showItemMenu(site),
      onSecondaryTap: () => showItemMenu(site),
      child: ListTile(
        tileColor: col.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(Icons.web_outlined),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        title: Text(site.title),
        subtitle: Text(site.url, maxLines: 2, overflow: .ellipsis),
        onTap: () {
          context.pushMaterialPageRoute(
            builder: (mainCtx) => WebviewPage(site: site),
          );
        },
      ),
    );
  }
}
