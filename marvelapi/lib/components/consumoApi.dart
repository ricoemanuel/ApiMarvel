import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = [];

  Future fetchData() async {
    const ts = '1357';
    const apiKey = '41854044bd65056f57878e238f45eb7c';
    const hash = '82704b23bd3d2ad1f55bef5db3643f7c';

    const url =
        'https://gateway.marvel.com:443/v1/public/characters?ts=$ts&apikey=$apiKey&hash=$hash&limit=20&offset=1';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        data = jsonData['data']['results'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de personajes")),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: data.isEmpty
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                data[index]['name'],
                                                style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      data[index]['thumbnail']
                                                              ['path'] +
                                                          '.' +
                                                          data[index]
                                                                  ['thumbnail']
                                                              ['extension'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Descripción:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              data[index]['description'] != ""
                                                  ? Text(data[index]
                                                      ['description'])
                                                  : Text(
                                                      'No hay descripción disponible'),
                                              const SizedBox(height: 16),
                                              Text(
                                                'comics: ${data[index]['comics']['available']}',
                                              ),
                                              Text(
                                                'series: ${data[index]['series']['available']}',
                                              ),
                                              Text(
                                                'stories: ${data[index]['stories']['available']}',
                                              ),
                                              Text(
                                                'eventos: ${data[index]['events']['available']}',
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Series:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 120,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: data[index]
                                                                      ['series']
                                                                  ['items']
                                                              .length >
                                                          3
                                                      ? 3
                                                      : data[index]['series']
                                                              ['items']
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int seriesIndex) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            data[index]['series']
                                                                        [
                                                                        'items']
                                                                    [
                                                                    seriesIndex]
                                                                ['name'],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              color: const Color(0xFFFF5454),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    data[index]['thumbnail']['path'] +
                                        '.' +
                                        data[index]['thumbnail']['extension'],
                                  ),
                                ),
                                title: Text(
                                  data[index]['name'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 2,
                            color: Colors.white,
                            thickness: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ],
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
