import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uas/helpers/ModelDosen.dart';
import 'package:http/http.dart' as http;
import 'package:uas/helpers/base_response.dart';
import 'package:uas/helpers/constants.dart';
import 'package:uas/widget/Textnput.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Dosen',
      showSemanticsDebugger: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'List Dosen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ModelDosen> listDosen = [];
  TextEditingController nipController = TextEditingController(text: '');
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController genderController = TextEditingController(text: '');
  TextEditingController addressController = TextEditingController(text: '');
  var selectedId;

  void getListDosen() async {
    var response = await http.get(Uri.parse('$URL_SERVER$path'));
    print(response);
    if (response.statusCode == 200) {
      listDosen.clear();
    }
    var decodedData = BaseResponse.fromJson(jsonDecode(response.body)).data;
    for (var dosen in decodedData) {
      listDosen.add(ModelDosen(dosen['id'], dosen['nip'], dosen['name'],
          dosen['gender'], dosen['address']));
    }
    setState(() {
      listDosen = listDosen;
    });
  }

  showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void deleteData(BuildContext context, id) async {
    var response = await http.delete(Uri.parse('$URL_SERVER$path/$id'));
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode);
      getListDosen();
      showToast(context, 'Berhasil Hapus');
    }
  }

  void addData(
    BuildContext context,
  ) async {
    var response = await http
        .post(Uri.parse('$URL_SERVER$path'), headers: <String, String>{
      'Context-Type': 'application/json;charset=UTF-8',
    }, body: <String, String>{
      'nip': nipController.text,
      'name': nameController.text,
      'gender': genderController.text,
      'address': addressController.text,
    });
    if (BaseResponse.fromJson(jsonDecode(response.body)).statusCode == 201) {
      nipController.text = '';
      nameController.text = '';
      genderController.text = '';
      addressController.text = '';
      showToast(context, 'Berhasil Menambahkan Data');
      getListDosen();
    } else {
      showToast(context, 'Gagal Menambahkan Data');
    }
  }

  void editData(
    BuildContext context,
  ) async {
    var response = await http.put(Uri.parse('$URL_SERVER$path/$selectedId'),
        headers: <String, String>{
          'Context-Type': 'application/json;charset=UTF-8',
        },
        body: <String, String>{
          'nip': nipController.text,
          'name': nameController.text,
          'gender': genderController.text,
          'address': addressController.text,
        });
    if (BaseResponse.fromJson(jsonDecode(response.body)).statusCode == 200) {
      nipController.text = '';
      nameController.text = '';
      genderController.text = '';
      addressController.text = '';
      setState(() {
        selectedId = null;
      });
      showToast(context, 'Berhasil Update Data');
      getListDosen();
    } else {
      showToast(context, 'Gagal Update Data');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    getListDosen();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("NIP"),
                                Container(
                                  width: 250,
                                  decoration: BoxDecoration(boxShadow: []),
                                  child: TextInput(
                                    controller: nipController,
                                    onChanged: (val) {},
                                    hintText: 'Ex: 115050',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Name"),
                                Container(
                                  width: 250,
                                  decoration: BoxDecoration(boxShadow: []),
                                  child: TextInput(
                                    controller: nameController,
                                    onChanged: (val) {},
                                    hintText: 'Ex: Muhammad Junaedi',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Gender"),
                                Container(
                                  width: 250,
                                  decoration: BoxDecoration(boxShadow: []),
                                  child: TextInput(
                                    controller: genderController,
                                    onChanged: (val) {},
                                    hintText: 'Ex: L',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Address"),
                                Container(
                                  width: 250,
                                  decoration: BoxDecoration(boxShadow: []),
                                  child: TextInput(
                                    controller: addressController,
                                    onChanged: (val) {},
                                    hintText: 'Ex: jl.Sawo',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (selectedId != null) {
                                      editData(context);
                                    } else {
                                      addData(context);
                                    }
                                  },
                                  child: Text(
                                    (selectedId != null) ? 'UPDATE' : "ADD",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (selectedId != null) ...[
                                  TextButton(
                                    onPressed: () {
                                      nipController.text = '';
                                      nameController.text = '';
                                      genderController.text = '';
                                      addressController.text = '';
                                      setState(() {
                                        selectedId = null;
                                      });
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listDosen.length,
                    itemBuilder: (BuildContext context, index) => InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listDosen[index].name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    listDosen[index].nip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                deleteData(context, listDosen[index].id);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                nipController.text = listDosen[index].nip;
                                nameController.text = listDosen[index].name;
                                genderController.text = listDosen[index].gender;
                                addressController.text =
                                    listDosen[index].address;
                                setState(() {
                                  selectedId = listDosen[index].id;
                                });
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
