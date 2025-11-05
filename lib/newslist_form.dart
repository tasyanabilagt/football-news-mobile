import 'package:flutter/material.dart';
import 'package:football_news/widgets/left_drawer.dart';

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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Berita berhasil disimpan!'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Judul: $_title'),
                              Text('Isi: $_content'),
                              Text('Kategori: $_category'),
                              Text('Thumbnail: $_thumbnail'),
                              Text('Unggulan: ${_isFeatured ? "Ya" : "Tidak"}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      _formKey.currentState!.reset();
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