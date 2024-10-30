// ignore_for_file: prefer_const_constructors

//import 'dart:convert';

//import 'package:belajar_widget/pages_siswa/siswa_create_page.dart';
//import 'package:belajar_widget/pages_siswa/siswa_update_page.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:flutter_supabase/siswa_create.dart';

class SiswaHome extends StatefulWidget {
  const SiswaHome({super.key});

  @override
  State<SiswaHome> createState() => _SiswaHomeState();
}

class _SiswaHomeState extends State<SiswaHome> {
  //List _listdata = [];

  //final supabase = Supabase.instance.client;
  //final siswaStream = supabase.from('siswa').stream(primaryKey: ['nisn']);

  final siswaStream =
      Supabase.instance.client.from('siswa').stream(primaryKey: ['nisn']);

  //Create Siswa
  Future<void> createSiswa(
      String siswaNisn, String updatedNama, String updatedKelas) async {
    await Supabase.instance.client.from('siswa').insert(
        {'nisn': siswaNisn, 'nama': updatedNama, 'kelas': updatedKelas});
  }

  // Update Siswa
  Future<void> updateSiswa(
      String siswaNisn, String updatedNama, String updatedKelas) async {
    await Supabase.instance.client.from('siswa').update(
        {'nama': updatedNama, 'kelas': updatedKelas}).eq('nisn', siswaNisn);
  }

  // Delete Siswa
  Future<void> deleteSiswa(String siswaNisn) async {
    await Supabase.instance.client.from('siswa').delete().eq('nisn', siswaNisn);
  }

  /*
  Future _getdata() async {
    try {
      final responnya =
          await http.get(Uri.parse('http://192.168.43.224/API/read.php'));

      if (responnya.statusCode == 200) {
        //print(responnya.body);
        final dataNya = jsonDecode(responnya.body);
        setState(() {
          _listdata = dataNya;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _hapus(String id) async {
    final responnya = await http
        .post(Uri.parse('http://192.168.43.224/API/delete.php'), body: {
      "id": id,
    });

    if (responnya.statusCode == 200) {
      return true;
    }
    return false;
  }
  @override
  void initState() {
    _getdata();
    //print(_listdata);
    super.initState();
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[400],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Data Siswa RIS',
            style: TextStyle(
              fontSize: 25,
              color: Colors.green[400],
            ),
          ),
          backgroundColor: Colors.green[900],
        ),
        body: StreamBuilder(
          stream: siswaStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final datanya = snapshot.data!;
            return ListView.builder(
              itemCount: datanya.length,
              itemBuilder: ((context, index) {
                return Card(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  //child: InkWell(
                  child: ListTile(
                    title: Text(
                      datanya[index]['nama'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(datanya[index]['nisn']),
                        //SizedBox(height: 4.0),
                        Text(datanya[index]['kelas']),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize
                          .min, // To make sure the row doesn't take full width
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              /* 
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => SiswaUpdatePage(
                                        listData: {
                                          //"id": datanya[index]['id_siswa'],
                                          "nisn": datanya[index]['nisn'],
                                          "nama": datanya[index]
                                              ['nama'],
                                          "kelas": datanya[index]
                                              ['kelas'],
                                        },
                                      )),
                                ),
                              );
                              */
                            }),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      content: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: 'Yakin data '),
                                            TextSpan(
                                              text:
                                                  datanya[index]['nama'] ?? '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            TextSpan(
                                              text: ' akan dihapus???',
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              deleteSiswa(
                                                      datanya[index]['nisn'])
                                                  .then((value) {
                                                //if (value) {
                                                final snackBar = SnackBar(
                                                  content: const Text(
                                                      'Data Berhasil di Hapus'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);

                                                setState(() {
                                                  datanya.removeAt(index);
                                                });
                                                /*
                                                } else {
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        'Data Gagal di Hapus'),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                                */
                                              });
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          SiswaHome())),
                                                  (route) => false);
                                            },
                                            child: Text("Ya")),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Batal")),
                                      ],
                                    );
                                  }));
                            }),
                      ],
                    ),
                  ),
                  //),
                );
              }),
              //);
/*
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SiswaCreate())));
                  }),
                  */
            );
          },
        ));
  }
}
