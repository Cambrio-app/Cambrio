import 'package:cambrio/models/user_profile.dart';
import 'package:cambrio/pages/profile/editProfile.dart';
import 'package:cambrio/models/user_preferences.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/profile/NumbersWidget.dart';
import 'package:cambrio/widgets/profile/ProfileEditWidget.dart';
import 'package:cambrio/widgets/profile/ProfileWidget.dart';
import 'package:cambrio/widgets/profile/TabBarView.dart';
import 'package:cambrio/widgets/shadow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../edit_book.dart';

class PersonalProfilePage extends StatefulWidget {
  const PersonalProfilePage({Key? key}) : super(key: key);

  @override
  _PersonalProfilePageState createState() => _PersonalProfilePageState();
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  UserProfile profile = const UserProfile(
      user_id: 'idk',
      bio: 'loading',
      handle: 'loading',
      imageURL: null,
      full_name: 'loading');

  @override
  Widget build(BuildContext context) {
    // UserProfile? profile = await FirebaseService().getProfile(uid: FirebaseAuth.instance.currentUser!.uid);
    return FutureBuilder<UserProfile?>(
      future: FirebaseService()
          .getProfile(uid: FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<UserProfile?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          profile = snapshot.data!;
        } else {
          profile = const UserProfile(
              user_id: 'idk',
              bio: 'loading',
              handle: 'loading',
              imageURL: null,
              full_name: 'loading');
        }
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(height: 20),
              ProfileWidget(
                imagePath: profile.imageURL,
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              buildName(profile.full_name ?? 'no full_name chosen',
                  profile.handle ?? "no handle minted"),
              // const SizedBox(
              //   height: 20,
              // ),
              buildBio(profile.bio ?? "tell them what you're about"),
              // const SizedBox(
              //   height: 20,
              // ),
              NumbersWidget(),
              // const SizedBox(
              //   height: 20,
              // ),
              ShadowButton(
                  text: "Edit",
                  onclick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfile(
                                name: profile.full_name!,
                                bio: profile.bio!,
                                handle: profile.handle!,
                              )),
                    );
                  }),
              // const SizedBox(
              //   height: 20,
              // ),
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

  Widget buildBio(String bio) => Text(
    bio,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat-Semibold",
    ),
    maxLines: 4,
    softWrap: true,
    overflow: TextOverflow.fade,
  );
}
