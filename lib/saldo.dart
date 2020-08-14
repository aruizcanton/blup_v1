import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:blupv1/colors.dart';
import 'package:blupv1/perfil.dart';

class Saldo extends StatefulWidget {
  Saldo(this.payload);

  final Map<String, dynamic> payload;
  @override
  SaldoState createState() => SaldoState(this.payload);
}
class SaldoState extends State<Saldo> with SingleTickerProviderStateMixin {
  final Map<String, dynamic> payload;
  SaldoState(this.payload);

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'SALDO ACTUAL'),
    Tab(text: 'HISTORIAL'),
  ];
  TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose (){
    _tabController.dispose();
    super.dispose();
  }

  Widget _tabSaldoActual (BuildContext context, Tab tab) {
    final String label = tab.text.toLowerCase();
    return ListView(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Total descontado',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$ 10.320',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        ),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Total retirado',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$ 10.000',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Monto compra folios',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                          '\$ 300',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Monto total cuotas',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$ 20',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: kBlupIndigo50,
                  height: 20,
                  thickness: 1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: null,
                      child: Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Ver retiros realizados',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],

    );
  }

  Widget _tabHistorial (BuildContext context, Tab tab) {
    final String label = tab.text.toLowerCase();
    return Center(
      child: Text(
      'This is the $label tab',
      style: const TextStyle(fontSize: 36),
    ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  semanticLabel: 'menu',
                  color: Colors.white,
                ),
                onPressed: () { Scaffold.of(context).openDrawer(); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }
        ),
        backgroundColor: primaryDarkColor,
//        textTheme: ,
        title: Text('BLUP',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: myTabs,
          labelColor: Colors.white,
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
      body: TabBarView (
        controller: _tabController,
        children: [_tabSaldoActual(context, myTabs[0]), _tabHistorial(context, myTabs[1])],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 80.0,
              child:DrawerHeader(
                  child: Text(
                    'BLUP',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: primaryColor
                  )
              ),
            ),
            ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Perfil'),
                onTap: () {
                  Navigator.push (
                      context,
                      MaterialPageRoute(
                        builder: (context) => Perfil(payload),
                      )
                  );
                }
            ),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text('Contraseña y PIN'),
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('Soporte'),
            ),
            ListTile(
              leading: Icon(Icons.live_help),
              title: Text('Preguntas frecuentes'),
            ),
            ListTile(
              leading: Icon(Icons.error),
              title: Text('Términos y condiciones'),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text(
              'Perfil',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            title: Text('Retiro'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
//            icon: Icon(Icons.format_list_bulleted),
            title: Text('Saldo'),
          ),
        ],
        currentIndex: 0,
//        selectedItemColor: Colors.amber[800],
        selectedItemColor: kBlupErrorRed,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Perfil(payload),
                )
            );
          }
          if (index == 1) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}