
import 'package:cambrio/services/user_preferences.dart';
import 'package:cambrio/widgets/NumbersWidget.dart';
import 'package:cambrio/widgets/ProfileWidget.dart';
import 'package:flutter/material.dart';

class AuthorProfilePage extends StatefulWidget {
  const AuthorProfilePage({ Key? key }) : super(key: key);
  @override
  _AuthorProfilePageState createState() => _AuthorProfilePageState();
}
class _AuthorProfilePageState extends State<AuthorProfilePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          ProfileWidget(
            imagePath: UserConstant.imagePath,
          ),
          const SizedBox(
            height: 20,
          ),
          buildName(UserConstant.name),
          const SizedBox(
            height: 20,
          ),
          buildBio(UserConstant.bio),
          const SizedBox(
            height: 20,
          ),
          NumbersWidget(),
           const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: EditButton(),
          ),
          Container(
            width: double.infinity,
            color: Colors.grey[200],
          ),
        ],
      ),
    );
  }

  Widget buildName(String name) => Column(
    children: [
      Text(
        UserConstant.name,
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.normal,
          fontFamily: "Unna",
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        "@"+ UserConstant.handle,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.grey,
          fontFamily: "Montserrat-Semibold",
        ),
      ),
    ],
  );

  Widget buildBio(String bio) => Column(
    children: [
      Text(
        UserConstant.bio,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: "Montserrat-Semibold",
        ),
        maxLines: 4,
        softWrap: true,
        overflow: TextOverflow.fade,
      ),
    ],
  );

  // ignore: non_constant_identifier_names
  Widget EditButton() => Container( 
    color: Colors.black,
    height: 60,
    padding: const EdgeInsets.only(bottom: 4, right: 5),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width ,
        height: 40,
        onPressed: () {
                showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
              return Container(
                color: const Color(0xFF737373),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Column(children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Fill Up Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff778DFC)),),
                    ),
                  ],),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              );
            });
      });
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
        child: const Text("Subscribe", style: TextStyle(
          fontWeight: FontWeight.w600, 
          fontSize: 18,
          fontFamily: "Montserrat-Semibold",
        ),),
      ),
    );
}