import 'package:cambrio/models/user_profile.dart';
import 'package:cambrio/pages/editProfile.dart';
import 'package:cambrio/models/user_preferences.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/NumbersWidget.dart';
import 'package:cambrio/widgets/ProfileEditWidget.dart';
import 'package:cambrio/widgets/ProfileWidget.dart';
import 'package:cambrio/widgets/TabBarView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_book.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({Key? key}) : super(key: key);

  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  @override
  Widget build(BuildContext context) {
    // UserProfile? profile = await FirebaseService().getProfile(uid: FirebaseAuth.instance.currentUser!.uid);
    return FutureBuilder<UserProfile?>(
      future: FirebaseService().getProfile(uid: FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
        UserProfile profile = const UserProfile(bio: 'loading', handle: 'loading', imageURL: null, full_name: 'loading');
        if (snapshot.hasData && snapshot.data != null) {
          profile = snapshot.data!;
        }
        else {
          profile = const UserProfile(bio: 'loading', handle: 'loading', imageURL: null, full_name: 'loading');
        }
        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 20),
              ProfileWidget(
                imagePath: profile.imageURL,
              ),
              const SizedBox(
                height: 20,
              ),
              buildName(profile.full_name ?? 'no full_name chosen', profile.handle ?? "no handle minted"),
              const SizedBox(
                height: 20,
              ),
              buildBio(profile.bio ?? "tell them what you're about"),
              const SizedBox(
                height: 20,
              ),
              NumbersWidget(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(75, 0, 75, 0),
                child: EditButton(),
              ),
              const SizedBox(
                height: 20,
              ),
              TabBarToggle(profile: profile),
            ],
          ),
        );
      },
    );
  }

  Widget buildName(String name, String handle) => Column(
        children: [
          Text(
            name,
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
            "@" + handle,
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
            bio,
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
