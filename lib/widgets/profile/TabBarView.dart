import 'package:cambrio/models/tutorials_state.dart';
import 'package:cambrio/models/user_profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/edit_book.dart';
import '../../services/firebase_service.dart';
import '../book_grid_view.dart';
import '../book_list_view.dart';

class TabBarToggle extends StatefulWidget {
  final int initialIndex;
  final UserProfile profile;
  const TabBarToggle({Key? key, required this.profile, this.initialIndex = 1})

      : super(key: key);

  @override
  _TabBarToggleState createState() => _TabBarToggleState();
}

class _TabBarToggleState extends State<TabBarToggle>
    with TickerProviderStateMixin {

  late final TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(
      text: "SUBSCRIPTIONS",
    ),
    Tab(text: "YOUR WORKS"),
  ];


  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        initialIndex: widget.initialIndex, length: 2, vsync: this);
    _tabController.addListener(() {
      // log the page view
      FirebaseAnalytics.instance
          .logSelectContent(
        contentType: 'book_view',
        itemId: _tabs[_tabController.index].text!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    _tabController.index = context.watch<TutorialsState>().showAddBooksTutorial ? 1 : _tabController.index;
    return SizedBox(
      height: 260,
      child: Column(
        children: [
          Container(
              height: 60,
              width: double.infinity,
              child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight:FontWeight.w400, fontFamily: 'Montserrat', letterSpacing: 0,),
                  indicatorColor: Color(0xff000000),
                  indicatorPadding: EdgeInsets.only(left:30,right:30),
                  indicatorWeight: 2,
                  labelStyle: TextStyle(fontSize: 16, fontWeight:FontWeight.w700, fontFamily: 'Montserrat', letterSpacing: 0.5),
                  controller: _tabController,
                  tabs: _tabs)),
          Flexible(
              child: TabBarView(controller: _tabController, children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: BookGridView(
                  collectionToPull: 'books',
                    queryType: QueryTypes.subscribed),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  const BookGridView(
                      collectionToPull: 'books', queryType: QueryTypes.works),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.add, color: Colors.white, size: 35),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditBook()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ])),
        ],
      ),
    );
  }
}
