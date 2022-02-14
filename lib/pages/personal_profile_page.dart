import 'package:cambrio/models/user.dart';
import 'package:cambrio/pages/editProfile.dart';
import 'package:cambrio/services/user_preferences.dart';
import 'package:cambrio/widgets/NumbersWidget.dart';
import 'package:cambrio/widgets/ProfileEditWidget.dart';
import 'package:cambrio/widgets/ProfileWidget.dart';
import 'package:cambrio/widgets/TabBarView.dart';
import 'package:flutter/material.dart';

import 'add_book.dart';

class PersonalProfilePage extends StatefulWidget {
  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 20),
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
            padding: EdgeInsets.fromLTRB(75, 0, 75, 0),
            child: EditButton(),
          ),
          const SizedBox(
            height: 20,
          ),
          TabBarToggle(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddBook()),
        ),
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
            "@" + UserConstant.handle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
              fontFamily: "Montserrat-Semibold",
            ),
          ),
        ],
      );

  Widget buildBio(String name) => Column(
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

  Widget EditButton() => Container(
        //color: Colors.black,
        height: 30,
        padding: EdgeInsets.only(bottom: 3, right: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(
                3, // Move to right 3  horizontally
                3, // Move to bottom 3 Vertically
              ),
            )
          ],
        ),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          height: 40,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfile(
                        name: UserConstant.name,
                        bio: UserConstant.bio,
                        handle: UserConstant.handle,
                      )),
            );
          },
          color: Colors.white,
          elevation: 0,
          child: const Text(
            "Edit",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      );
}
