import 'package:flutter/material.dart';
import 'package:football_news/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_news/menu.dart';

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({super.key});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  String _category = "update";
  String _thumbnail = "";
  bool _isFeatured = false;

  final List<String> _categories = [
    'transfer',
    'update',
    'exclusive',
    'match',
    'rumor',
    'analysis',
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Form Tambah Berita')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === TITLE ===
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Judul Berita",
                  labelText: "Judul Berita",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => setState(() => _title = value),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Judul tidak boleh kosong!" : null,
              ),
              const SizedBox(height: 10),

              // === CONTENT ===
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Isi Berita",
                  labelText: "Isi Berita",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => setState(() => _content = value),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Isi berita tidak boleh kosong!" : null,
              ),
              const SizedBox(height: 10),

              // === CATEGORY ===
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                value: _category,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat[0].toUpperCase() + cat.substring(1)),
                        ))
                    .toList(),
                onChanged: (newValue) => setState(() => _category = newValue!),
              ),
              const SizedBox(height: 10),

              // === THUMBNAIL ===
              TextFormField(
                decoration: InputDecoration(
                  hintText: "URL Thumbnail (opsional)",
                  labelText: "URL Thumbnail",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) => setState(() => _thumbnail = value),
              ),
              const SizedBox(height: 10),

              // === FEATURED ===
              SwitchListTile(
                title: const Text("Tandai sebagai Berita Unggulan"),
                value: _isFeatured,
                onChanged: (value) => setState(() => _isFeatured = value),
              ),

              // === BUTTON ===
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Replace the URL with your app's URL
                      // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                      // If you using chrome,  use URL http://localhost:8000

                      final response = await request.postJson(
                        "http://localhost:8000/create-flutter/",
                        jsonEncode({
                          "title": _title,
                          "content": _content,
                          "thumbnail": _thumbnail,
                          "category": _category,
                          "is_featured": _isFeatured,
                        }),
                      );
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("News successfully saved!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Something went wrong, please try again."),
                          ));
                        }
                      }
                    }
                  },
                  child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}