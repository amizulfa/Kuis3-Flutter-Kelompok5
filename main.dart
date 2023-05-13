import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'detail_jenis.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ListPinjamanCubit>(create: (_) => ListPinjamanCubit()),
        BlocProvider<ListDetailPinjamanCubit>(
            create: (_) => ListDetailPinjamanCubit()),
      ],
      child: HalamanUtama(),
    );
  }
}

class Pinjaman {
  String id;
  String nama;
  Pinjaman({required this.id, required this.nama});
}

class ListPinjamanModel {
  List<Pinjaman> listPinjamanModel = <Pinjaman>[];
  ListPinjamanModel({required this.listPinjamanModel});
}

class ListPinjamanCubit extends Cubit<ListPinjamanModel> {
  String selectedId = "1";

  ListPinjamanCubit() : super(ListPinjamanModel(listPinjamanModel: [])) {
    fetchData();
  }

  void setSelectedId(String id) {
    selectedId = id;
    fetchData();
  }

  void setFromJson(Map<String, dynamic> json) {
    var data = json["data"];
    List<Pinjaman> listPinjamanModel = <Pinjaman>[];
    for (var val in data) {
      var id = val["id"];
      var nama = val["nama"];
      listPinjamanModel.add(Pinjaman(id: id, nama: nama));
    }
    emit(ListPinjamanModel(listPinjamanModel: listPinjamanModel));
  }

  void fetchData() async {
    String url = "http://178.128.17.76:8000/jenis_pinjaman/$selectedId";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class HalamanUtama extends StatelessWidget {
  HalamanUtama({Key? key}) : super(key: key);

  final List<DropdownMenuItem<String>> countries = [
    const DropdownMenuItem<String>(
      value: "1",
      child: Text("Jenis Pinjaman 1"),
    ),
    const DropdownMenuItem<String>(
      value: "2",
      child: Text("Jenis Pinjaman 2"),
    ),
    const DropdownMenuItem<String>(
      value: "3",
      child: Text("Jenis Pinjaman 3"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Kuis 3',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Kuis 3'),
          ),
          body: Center(
            child: Column(
              children: [
                Text(
                    '2101147, Amida Zulfa Laila; 2103507, Indah Resti Fauzi; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang'),
                BlocBuilder<ListPinjamanCubit, ListPinjamanModel>(
                  buildWhen: (previousState, state) {
                    developer.log(
                      "${previousState.listPinjamanModel} -> ${state.listPinjamanModel}",
                      name: 'logMindah',
                    );
                    return true;
                  },
                  builder: (context, model) {
                    return DropdownButton<String>(
                      value: context.watch<ListPinjamanCubit>().selectedId,
                      onChanged: (String? newValue) {
                        context
                            .read<ListPinjamanCubit>()
                            .setSelectedId(newValue!);
                      },
                      items: countries,
                    );
                  },
                ),
                Expanded(
                  child: BlocBuilder<ListPinjamanCubit, ListPinjamanModel>(
                    builder: (context, model) {
                      if (model.listPinjamanModel.isNotEmpty) {
                        return ListView.builder(
                          itemCount: model.listPinjamanModel.length,
                          itemBuilder: (context, index) {
                            final id = model.listPinjamanModel[index].id;
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(id: id),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Id :", textAlign: TextAlign.left),
                                      Text(model.listPinjamanModel[index].id,
                                          textAlign: TextAlign.left),
                                      Text("Nama", textAlign: TextAlign.left),
                                      Text(model.listPinjamanModel[index].nama,
                                          textAlign: TextAlign.left),
                                    ],
                                  ),
                                ));
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
