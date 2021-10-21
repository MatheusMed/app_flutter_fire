import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Vinho extends StatefulWidget {
  Vinho({this.foto, this.marca, this.preco, this.vinho, this.id});
  final String? foto;
  final String? vinho;
  final String? marca;
  final dynamic id;
  final double? preco;
  @override
  _VinhoState createState() => _VinhoState();
}

class _VinhoState extends State<Vinho> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vinhos'),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: ListTile(
                      title: Text('Favoritar'),
                      onTap: () async {
                        var cfVinhos =
                            FirebaseFirestore.instance.collection("vinhos");
                        await cfVinhos
                            .doc(widget.id)
                            .update({"favorit": true})
                            .then((_) => print('deu certo'))
                            .catchError((er) => print("erro $er"));
                        Navigator.of(context).pop();
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      title: Text('Remover Favorito'),
                      onTap: () async {
                        var cfVinhos =
                            FirebaseFirestore.instance.collection("vinhos");
                        await cfVinhos
                            .doc(widget.id)
                            .update({"favorit": false})
                            .then((_) => print('deu certo'))
                            .catchError((er) => print("erro $er"));
                        Navigator.of(context).pop();
                      },
                    )),
                  ]),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.foto == null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                        "https://image.shutterstock.com/image-vector/picture-vector-icon-no-image-600w-1732584341.jpg"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      widget.foto.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text('Vinhos'),
                children: [
                  ListTile(
                    title: Text.rich(
                      TextSpan(text: 'Nome do vinho: ', children: [
                        TextSpan(
                            text: '${widget.vinho!}',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                          text: 'Marca do vinho: ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: '${widget.marca!}',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ]),
                    ),
                    trailing: Text.rich(
                      TextSpan(text: 'Preço do vinho: ', children: [
                        TextSpan(
                            text: NumberFormat.simpleCurrency(locale: "pt_BR")
                                .format(widget.preco),
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
