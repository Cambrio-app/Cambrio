import 'package:cambrio/models/user_profile.dart';
import 'package:flutter/material.dart';

import '../../pages/edit_book.dart';
import '../../services/firebase_service.dart';
import '../book_list_view.dart';


class TabBarToggle extends StatefulWidget {
  final int initialIndex;
  final UserProfile profile;
  const TabBarToggle({Key? key, required this.profile, this.initialIndex = 1}) : super(key: key);

  @override
  _TabBarToggleState createState() => _TabBarToggleState();
}

class _TabBarToggleState extends State<TabBarToggle>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(initialIndex: widget.initialIndex, length: 2, vsync: this);

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
                    Tab(text: "Your Works"),
                  ])),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
                const BookListView(collectionToPull: 'books', collectionTitle: "Subscriptions", queryType: QueryTypes.subscribed),
                Scaffold(
                  body: BookListView(collectionToPull: 'books', collectionTitle: "The Ingenious Works of ${widget.profile.full_name}", queryType: QueryTypes.works),
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.add),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditBook()),
                    ),
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}