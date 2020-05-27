// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'colors.dart';

class HomePage extends StatelessWidget {
  // TODO: Make a collection of cards (102)
  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      // TODO: Add app bar (102)
      appBar: AppBar(
        backgroundColor: primaryDarkColor,
//        textTheme: ,
        // TODO: Add buttons and title (102)
        title: Text('BLUP',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            semanticLabel: 'menu',
            color: Colors.white,
          ),
          onPressed: () {
            print('Menu button');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_alert,
              semanticLabel: 'filter',
              color: Colors.white,
            ),
            onPressed: () {
              print('Filter button');
            },
          ),
        ],
      ),

      // TODO: Add a grid view (102)
      body: ListView(
        padding: EdgeInsets.all(8.0),
        // TODO: Build a grid of cards (102)
        children: <Widget>[
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomListItem(
                        user: 'Ángel Ruiz',
                        saldoAcumulado: 2000,
                        puedesRetirar: 1000,
                        diasAlaNomina: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(),
          ),
      ],
      ),
      // TODO: Set resizeToAvoidBottomInset (101)
    );
  }
}
class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.user,
    this.saldoAcumulado,
    this.puedesRetirar,
    this.diasAlaNomina,
  });

  final String user;
  final int saldoAcumulado;
  final int puedesRetirar;
  final int diasAlaNomina;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: _UserDescription(
              user: user,
              saldoAcumulado: saldoAcumulado,
              puedesRetirar: puedesRetirar,
              diasAlaNomina: diasAlaNomina,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}
class _UserDescription extends StatelessWidget {
  const _UserDescription({
    Key key,
    this.user,
    this.saldoAcumulado,
    this.puedesRetirar,
    this.diasAlaNomina,
  }) : super(key: key);

  final String user;
  final int saldoAcumulado;
  final int puedesRetirar;
  final int diasAlaNomina;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            Row(
                children: <Widget>[
                  Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 26.0,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.black,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 0,
            ),
            Row(
//              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      saldoAcumulado.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                        'Saldo acumulado',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
                VerticalDivider(),
                Column(
                  children: <Widget>[
                    Text(
                      puedesRetirar.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                        'Puedes Retirar',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
                VerticalDivider(),
                Column(
                  children: <Widget>[
                    Text(
                      diasAlaNomina.toString(),
                      style: const TextStyle (
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                        'A la nómina',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 30.0,
      width: 1.0,
      color: Colors.black,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}
