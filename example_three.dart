import 'dart:convert';

import 'package:api/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExampleThree extends StatefulWidget {
  const ExampleThree({super.key});

  @override
  State<ExampleThree> createState() => _ExampleThreeState();
}

class _ExampleThreeState extends State<ExampleThree> {
  List<UserModel> userList = [];

  Future<List<UserModel>> getUserApi() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return (data as List).map((i) => UserModel.fromJson(i)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'User List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUserApi(),
              builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load data',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No users found'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4,
                        shadowColor: Colors.indigoAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReusableRow(
                                title: 'Name',
                                value: snapshot.data![index].name.toString(),
                                titleColor: Colors.indigo,
                                valueColor: Colors.black,
                              ),
                              const Divider(),
                              ReusableRow(
                                title: 'Username',
                                value:
                                snapshot.data![index].username.toString(),
                                titleColor: Colors.indigo,
                                valueColor: Colors.black,
                              ),
                              const Divider(),
                              ReusableRow(
                                title: 'Email',
                                value: snapshot.data![index].email.toString(),
                                titleColor: Colors.indigo,
                                valueColor: Colors.black,
                              ),
                              const Divider(),
                              ReusableRow(
                                title: 'Address (Lat)',
                                value: snapshot.data![index].address?.geo?.lat ??
                                    'N/A',
                                titleColor: Colors.indigo,
                                valueColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title;
  final String value;
  final Color titleColor;
  final Color valueColor;

  const ReusableRow({
    Key? key,
    required this.title,
    required this.value,
    this.titleColor = Colors.black,
    this.valueColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
