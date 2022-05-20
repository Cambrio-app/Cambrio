import 'package:cambrio/pages/library_page.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/widgets/chapter_infinite_scroll.dart';


class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({ Key? key }) : super(key: key);
  @override
  State<MyTabbedPage> createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage> {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'LIBRARY'),
    Tab(text: 'FEED'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          shape: const Border.fromBorderSide(BorderSide.none),
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.03),
          toolbarHeight: 0,
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight:FontWeight.w400, fontFamily: 'Montserrat', letterSpacing: 0,),
            indicatorColor: Color(0xff000000),
            indicatorPadding: EdgeInsets.only(left:30,right:30),
            indicatorWeight: 2,
            labelStyle: TextStyle(fontSize: 16, fontWeight:FontWeight.w700, fontFamily: 'Montserrat', letterSpacing: 0.5),
            tabs: myTabs,
          ),
        ),
        body: const TabBarView( //IT TOLD ME TO MAKE IT CONST, I DON'T KNOW WHY OR IF THAT WAS A GOOD THING TO DO
          children: <Widget> [
            LibraryPage(),
            ChapterInfScroll(collectionToPull: "books"),
          ]
        ),
      ),
    );
  }
}