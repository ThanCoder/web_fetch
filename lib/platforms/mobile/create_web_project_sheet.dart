import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:web_fetcher/core/models/web_site.dart';

class CreateWebProjectSheet extends StatefulWidget {
  const new({super.key, this.editSite});
  final WebSite? editSite;

  @override
  State<CreateWebProjectSheet> createState() => _CreateWebProjectSheetState();

  static Future<WebSite?> show(
    BuildContext context, {
    WebSite? editSite,
  }) async {
    return await showModalBottomSheet<WebSite>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => CreateWebProjectSheet(editSite: editSite),
    );
  }
}

class _CreateWebProjectSheetState extends State<CreateWebProjectSheet> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    titleCon.dispose();
    urlCon.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final titleCon = TextEditingController();
  final urlCon = TextEditingController();

  void init() {
    final ed = widget.editSite;
    if (ed != null) {
      titleCon.text = ed.title;
      urlCon.text = ed.url;
      setState(() {});
    }
  }

  void save() async {
    if (!_formKey.currentState!.validate()) {
      return null;
    }
    final newWeb = WebSite(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleCon.text,
      url: urlCon.text,
    );

    context.pop(newWeb);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 12,
              children: [
                TextFormField(
                  controller: titleCon,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: Text('Title'),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: .next,

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'required!';
                    }
                    return null;
                  },
                ),
                // url
                TextFormField(
                  controller: urlCon,
                  maxLines: 1,
                  decoration: InputDecoration(
                    label: Text('Website Url'),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: .next,

                  validator: (value) {
                    final val = value!;
                    if (val.isEmpty) {
                      return 'required!';
                    }
                    if (!val.startsWith('http')) {
                      return 'url is required!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: save,
                        label: Text(
                          widget.editSite == null ? 'Create' : 'Update',
                        ),
                        icon: Icon(Icons.create_outlined),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
