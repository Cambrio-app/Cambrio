import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cambrio/widgets/chapter_infinite_scroll.dart';
import 'package:cambrio/widgets/book_list_view.dart';


class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({ Key? key }) : super(key: key);
  @override
  State<MyTabbedPage> createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Feed'),
    Tab(text: 'Library'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0,
          bottom: TabBar(
            indicatorColor: const Color(0xff000000),
            labelStyle: const TextStyle(fontSize: 16, fontWeight:FontWeight.bold, fontFamily: 'Montserrat'),
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
      ),
      body: TabBarView( //IT TOLD ME TO MAKE IT CONST, I DON'T KNOW WHY OR IF THAT WAS A GOOD THING TO DO
        controller: _tabController,
        children: const <Widget> [
          ChapterInfScroll(collectionToPull: "books"),
          BookListView(collectionToPull: "books"),
        ]
      ),
    );
  }
}