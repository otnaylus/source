import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SiswaCreate extends StatefulWidget {
  const SiswaCreate({super.key});
  @override
  //_SiswaCreateState createState() => _SiswaCreateState();
  State<SiswaCreate> createState() => _SiswaCreateState();
}

class _SiswaCreateState extends State<SiswaCreate> {
  final List<Map<String, dynamic>> _siswaList = [];
  final TextEditingController _nisnController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSiswa();
  }

  Future<void> _fetchSiswa() async {
    final response =
        await Supabase.instance.client.from('siswa').select().execute();
    setState(() {
      _siswaList.clear();
      _siswaList.addAll(response.data);
    });
  }

  Future<void> _addSiswa() async {
    final response = await Supabase.instance.client.from('siswa').insert({
      'nisn': _nisnController.text,
      'nama': _namaController.text,
      'kelas': _kelasController.text,
    }).execute();
    if (response.error == null) {
      _fetchSiswa();
    }
  }

  Future<void> _updateSiswa(String nisn) async {
    final response = await Supabase.instance.client
        .from('siswa')
        .update({
          'nama': _namaController.text,
          'kelas': _kelasController.text,
        })
        .eq('nisn', nisn)
        .execute();
    if (response.error == null) {
      _fetchSiswa();
    }
  }

  Future<void> _deleteSiswa(String nisn) async {
    final response = await Supabase.instance.client
        .from('siswa')
        .delete()
        .eq('nisn', nisn)
        .execute();
    if (response.error == null) {
      _fetchSiswa();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRUD Siswa')),
      body: ListView.builder(
        itemCount: _siswaList.length,
        itemBuilder: (context, index) {
          final siswa = _siswaList[index];
          return ListTile(
            title: Text(siswa['nama']),
            subtitle: Text('NISN: ${siswa['nisn']} - Kelas: ${siswa['kelas']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _nisnController.text = siswa['nisn'];
                    _namaController.text = siswa['nama'];
                    _kelasController.text = siswa['kelas'];
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Update Siswa'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(controller: _nisnController),
                            TextField(controller: _namaController),
                            TextField(controller: _kelasController),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _updateSiswa(siswa['nisn']);
                              Navigator.of(context).pop();
                            },
                            child: Text('Update'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteSiswa(siswa['nisn']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Siswa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: _nisnController,
                      decoration: InputDecoration(labelText: 'NISN')),
                  TextField(
                      controller: _namaController,
                      decoration: InputDecoration(labelText: 'Nama')),
                  TextField(
                      controller: _kelasController,
                      decoration: InputDecoration(labelText: 'Kelas')),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _addSiswa();
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
