import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:web_fetcher/core/utils/app_util.dart';
import 'package:web_fetcher/keys.dart';

class WebsiteSettingPageListTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return ListTile(
      tileColor: col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text('Website Setting'),
      leading: Icon(Icons.settings_outlined),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        context.pushMaterialPageRoute(
          builder: (mainCtx) => WebsiteSettingPage(),
        );
      },
    );
  }
}

class WebsiteSettingPage extends StatefulWidget {
  const new({super.key});

  @override
  State<WebsiteSettingPage> createState() => _WebsiteSettingPageState();
}

class _WebsiteSettingPageState extends State<WebsiteSettingPage> {
  final cf = AppUtil.instance.config;
  final pkg = ThanPkgAndroid.getInstance.storagePermissionHandler;

  Future<bool> reqStoragePermis() async {
    if (Platform.isAndroid) {
      if (!await pkg.isStoragePermissionGranted()) {
        await pkg.requestStoragePermission();
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSite Setting')),
      body: Column(
        spacing: 12,
        children: [
          StreamBuilder(
            stream: cf.stream.put.where((e) => e.key == websitePathEnableKey),
            builder: (context, asyncSnapshot) {
              final enable = cf.getBool(websitePathEnableKey, false);
              return SwitchListTile.adaptive(
                title: Text('External Website List Database'),
                value: enable,
                onChanged: (value) async {
                  if (value) {
                    if (!await reqStoragePermis()) {
                      return;
                    }
                  }
                  cf.putAndWriteAll(websitePathEnableKey, value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
