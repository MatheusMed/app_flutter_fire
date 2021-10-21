import 'package:app_firebase/app/search.dart';
import 'package:app_firebase/app/vinho.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'incluse_route.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Vinhos'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Search()));
              },
              icon: Icon(Icons.search_sharp))
        ],
      ),
      body: _body(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InclusaoRoute()),
          );
        },
        tooltip: 'Adicionar Vinho',
        child: Icon(Icons.add),
      ),
    );
  }

  CollectionReference cfVinhos =
      FirebaseFirestore.instance.collection("vinhos");

  Column _body(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: cfVinhos.orderBy("vinho").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final data = snapshot.requireData;

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Vinho(
                              foto: data.docs[index].get("foto"),
                              vinho: data.docs[index].get("vinho"),
                              marca: data.docs[index].get("marca"),
                              preco: data.docs[index].get("preco"),
                              id: data.docs[index].reference.id)));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        data.docs[index].get("foto"),
                      ),
                    ),
                    trailing: Icon(data.docs[index].get("favorit") == true
                        ? Icons.favorite
                        : Icons.favorite_border),
                    title: Text(data.docs[index].get("vinho")),
                    subtitle: Text(data.docs[index].get("marca") +
                        "\n" +
                        NumberFormat.simpleCurrency(locale: "pt_BR")
                            .format(data.docs[index].get("preco"))),
                    isThreeLine: true,
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Exclusão'),
                            content: Text(
                                'Confirma a exclusão do suco de ${data.docs[index].get("vinho")}?'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  cfVinhos.doc(data.docs[index].id).delete();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Sim'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Não'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
