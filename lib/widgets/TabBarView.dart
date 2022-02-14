import 'package:flutter/material.dart';

import '../pages/add_book.dart';

int _selectedIndex = 0;

class TabBarToggle extends StatefulWidget {
  const TabBarToggle({Key? key}) : super(key: key);

  @override
  _TabBarToggleState createState() => _TabBarToggleState();
}

class _TabBarToggleState extends State<TabBarToggle>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);

    return Expanded(
      child: Column(
        children: [
          Container(
              height: 60,
              width: double.infinity,
              child: TabBar(
                  indicatorColor: Colors.grey,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  controller: _tabController,
                  labelStyle: TextStyle(
                      fontSize: 16, fontFamily: "Montserrat-Semibold"),
                  tabs: [
                    Tab(
                      text: "Subscriptions",
                    ),
                    Tab(text: "Your Books"),
                  ])),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
                Center(
                    child: Text(
                  "Subscriptions Page",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Montserrat-Semibold"),
                )),
                Scaffold(
                  body: Center(
                      child: Text(
                    "Your Books",
                    style: TextStyle(
                        fontSize: 16, fontFamily: "Montserrat-Semibold"),
                  )),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.add),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddBook()),
                    ),
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
