import 'package:cfb_store/cfb_store.dart';
import 'package:web_fetcher/core/controller/i_controller.dart';
import 'package:web_fetcher/core/models/web_site.dart';
import 'package:web_fetcher/core/utils/app_util.dart';
import 'package:web_fetcher/keys.dart';

class WebSiteDataChanged extends IControllerEvent {}

class WebSiteController extends IController {
  final _db = CFBStore();
  static const String dbName = 'website.list.cfb';
  List<WebSite> list = [];

  @override
  Future<void> init() async {
    AppUtil.instance.config.stream.put
        .where((e) => e.key == websitePathEnableKey)
        .listen((event) {
          _open();
        });
    _open();
  }

  Future<void> _open() async {
    String path = AppUtil.instance.getPlatformExternalConfigPath(dbName);

    final enable = AppUtil.instance.config.getBool(websitePathEnableKey, false);
    if (enable) {
      path = AppUtil.instance.getPlatformConfigPath(dbName);
    }
    await _db.open(path);
    fetchList();
  }

  Future<void> fetchList() async {
    list = _db.getMapList('list').map((e) => WebSite.fromJson(e)).toList();
    addEvent(WebSiteDataChanged());
  }

  Future<void> _save() async {
    final res = list.map((e) => e.toJson()).toList();
    await _db.putAndWriteAll('list', res);
  }

  Future<void> add(WebSite site) async {
    list.add(site);
    await _save();
    addEvent(WebSiteDataChanged());
  }

  Future<void> update(WebSite site) async {
    final index = list.indexWhere((e) => e.url == site.url);
    if (index == -1) return;
    list[index] = site;
    await _save();
    addEvent(WebSiteDataChanged());
  }

  Future<void> delete(WebSite site) async {
    final index = list.indexWhere((e) => e.id == site.id);
    if (index == -1) return;
    list.removeAt(index);
    await _save();
    addEvent(WebSiteDataChanged());
  }
}
