import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:web_fetcher/core/controller/i_controller.dart';
import 'package:web_fetcher/core/controller/web_site_controller.dart';
import 'package:web_fetcher/core/models/web_site.dart';
import 'package:web_fetcher/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:web_fetcher/platforms/mobile/create_web_project_sheet.dart';

class WebsiteItemMenuSheet extends StatefulWidget {
  const new({super.key, required this.site});
  final WebSite site;

  @override
  State<WebsiteItemMenuSheet> createState() => _WebsiteItemMenuSheetState();

  static Future<void> show(
    BuildContext context, {
    required WebSite site,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => WebsiteItemMenuSheet(site: site),
    );
  }
}

class _WebsiteItemMenuSheetState extends State<WebsiteItemMenuSheet> {
  final con = ControllerManager.read<WebSiteController>();

  void edit() async {
    context.pop();
    final res = await CreateWebProjectSheet.show(
      context,
      editSite: widget.site,
    );
    if (res == null) return;
  }

  void delete() async {
    context.pop();
    final conf = await showConfirmDialog(
      context,
      'Want To Delete?',
      confirmText: 'Delete Forever!',
      confirmColor: col.error,
      confirmForegroundColor: col.onError,
    );
    if (!conf) return;
    con.delete(widget.site);
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 12,
          children: [
            ListTile(
              tileColor: col.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit'),
              onTap: edit,
            ),
            ListTile(
              tileColor: col.errorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              leading: Icon(Icons.delete_forever_outlined),
              title: Text('Delete'),
              onTap: delete,
            ),

            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
