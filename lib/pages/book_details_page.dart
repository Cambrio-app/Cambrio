import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({ Key? key }) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              child: Image.asset(
                'assets/pictures/lake.png',
                fit: BoxFit.fitWidth,
              ),
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          buildName(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(child: ExpandableWidget(context)),
          ),
          buildDescription(),
        ],
      )
    );
  }


  Widget buildName() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Pride & Prejudice",
        style: const TextStyle(
          fontSize: 23,
          color: Colors.black,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          fontFamily: "Unna",
        ),
      ),
      SizedBox(
        height: 10 ,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, color: Colors.black, size: 14,),
          SizedBox(
            width: 5,
          ),
          Text(
            "Jane Austen",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontFamily: "Montserrat-Semibold",
            ),
          ),
        ],
      ),
    ],
  );

  Widget buildDescription() => 
  SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 4,
          ),
          Text(
            "Prides and Prejudice follows the turbulent relationship between Elizabeth Bennet, the daughter of a country gentleman, and Fitzwilliam Darcy, a rich aristocratic landowner. They must overcome the titular sins of pride and prejudice in order to fall in love and marry.",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              fontFamily: "Montserrat-Semibold",
            ),
            )
            ],
      ),
    ),
  );


  Widget TableOfContentDropDownButton() => Container( 
    color: Colors.black,
    height: 40,
    padding: const EdgeInsets.only(bottom: 2, right: 2),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width ,
        height: 40,
        onPressed: () {

        },
        color: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Table of Contents",style: TextStyle(
              fontWeight: FontWeight.w600, 
              fontSize: 14,
              fontFamily: "Montserrat-Semibold",
            ),
            ),
            Spacer(), 
            Icon(Icons.arrow_drop_down, color: Colors.black, size: 20,),
          ],
        ),
      ),
    );

    Widget ExpandableWidget(BuildContext context){
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Text(
              "Table of Content",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontFamily: "Montserrat-Semibold",
              ),
            ),
            expandedCrossAxisAlignment: 
            CrossAxisAlignment.center,
            initiallyExpanded: false,
            
            children: [
              ListTile(
                title: Text(
                  "Chapter 1",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: "Montserrat-Semibold",
                  ),
                ),
                onTap: () {
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Chapter 2",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: "Montserrat-Semibold",
                  ),
                ),
                onTap: () {
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Chapter 3",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: "Montserrat-Semibold",
                  ),
                ),
                onTap: () {
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Chapter 4",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontFamily: "Montserrat-Semibold",
                  ),
                ),
          ),
            ],
          ),
      );
    }

}