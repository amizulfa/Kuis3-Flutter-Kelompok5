import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'main.dart';

class DetailPinjaman {
  String id;
  String nama;
  String bunga;
  String is_syariah;

  DetailPinjaman(
      {required this.id,
      required this.nama,
      required this.bunga,
      required this.is_syariah});
}

class ListDetailPinjamanCubit extends Cubit<DetailPinjaman> {
  ListDetailPinjamanCubit()
      : super(DetailPinjaman(id: "", nama: "", bunga: "", is_syariah: ""));

  void setFromJson(Map<String, dynamic> json) {
    String id = json["id"];
    String nama = json["nama"];
    String bunga = json["bunga"];
    String is_syariah = json["is_syariah"];
    emit(DetailPinjaman(
        id: id, nama: nama, bunga: bunga, is_syariah: is_syariah));
  }

  void fetchData(String id) async {
    String url = "http://178.128.17.76:8000/detil_jenis_pinjaman/$id";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    // TODO: Implementasi tampilan halaman detail berdasarkan 'id'
    return Scaffold(
      appBar: AppBar(
        title: Text('Detil'),
      ),
      body: Center(
          child: Column(children: [
        BlocBuilder<ListDetailPinjamanCubit, DetailPinjaman>(
          builder: (context, pinjaman) {
            BlocProvider.of<ListDetailPinjamanCubit>(context).fetchData(id);
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(
                    "id: " + pinjaman.id,
                  ),
                  Text(
                    "Nama: " + pinjaman.nama,
                  ),
                  Text(
                    "Bunga: " + pinjaman.bunga,
                  ),
                  Text(
                    "Syariah: " + pinjaman.is_syariah,
                  ),
                ]));
          },
        ),
      ])),
    );
  }
}
