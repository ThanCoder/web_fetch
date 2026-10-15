import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';
import 'package:web_fetcher/core/utils/app_util.dart';

import 'platforms/platform_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtil.instance.init();

  if (Platform.isLinux) {
    await ThanPkgLinux.getInstance.window.setWindowSize(
      width: 400,
      height: 600,
    );
    await ThanPkgLinux.getInstance.window.setWindowTitle(
      AppUtil.instance.appName,
    );
  }

  runApp(const PlatformApp());
}
