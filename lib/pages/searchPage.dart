import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({ Key? key }) : super(key: key);

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 60,),
                    FadeInDown(
                      child: Row(
                        children: [
                          Text("Discover \nYour Favorites 🔥", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.grey.shade800, height: 1.5),)
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    FadeInDown(
                      delay: Duration(milliseconds: 400),
                      duration: Duration(milliseconds: 800),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: TextField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.grey.shade700,),
                            border: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.grey.shade500)
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ];
        }, body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(""),
        ),
      ),
    );
  }
}