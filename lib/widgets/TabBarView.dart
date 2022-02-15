import 'package:cambrio/models/user_profile.dart';
import 'package:flutter/material.dart';

import '../pages/add_book.dart';
import 'book_list_view.dart';

int _selectedIndex = 0;

class TabBarToggle extends StatefulWidget {
  final UserProfile profile;
  const TabBarToggle({Key? key, required this.profile}) : super(key: key);

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
                  labelStyle: const TextStyle(
                      fontSize: 16, fontFamily: "Montserrat-Semibold"),
                  tabs: const [
                    Tab(
                      text: "Subscriptions",
                    ),
                    Tab(text: "Your Books"),
                  ])),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
                const Center(
                    child: Text(
                  "Subscriptions Page",
                  style: TextStyle(
                      fontSize: 16, fontFamily: "Montserrat-Semibold"),
                )),
                Scaffold(
                  body: BookListView(collectionToPull: 'books', collectionTitle: "The Ingenious Work of ${widget.profile.full_name}"),
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
