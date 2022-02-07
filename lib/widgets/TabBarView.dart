import 'package:flutter/material.dart';

int _selectedIndex = 0;
class TabBarToggle extends StatefulWidget {
  const TabBarToggle({ Key? key }) : super(key: key);

  @override
  _TabBarToggleState createState() => _TabBarToggleState();
}

class _TabBarToggleState extends State<TabBarToggle> with TickerProviderStateMixin {
  
  @override
  Widget build(BuildContext context) {
    
    TabController _tabController = TabController(length: 2, vsync: this);

    return Center(
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
            labelStyle: TextStyle(fontSize: 16, fontFamily: "Montserrat-Semibold"),
            tabs: [
              Tab(
                text: "Subscriptions",
              ),
              Tab(text: "Your Books"),
            ]
          )
        ),
        Container(
          height: 200,
          width: double.infinity,
          child: TabBarView(
            controller: _tabController,
            children: [
              Center(child: Text("Subscriptions Page",style: TextStyle(fontSize: 16, fontFamily: "Montserrat-Semibold"),)),
              Center(child: Text("Your Books",style: TextStyle(fontSize: 16, fontFamily: "Montserrat-Semibold"),)),
            ]
          )
          ),
      ],
        ),
    );
  }
}