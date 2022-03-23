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
      image_url: null,
      full_name: 'loading');

  @override
  Widget build(BuildContext context) {
    // UserProfile? profile = await FirebaseService().getProfile(uid: FirebaseAuth.instance.currentUser!.uid);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          // maxHeight: 300,
          // minHeight: 200,
            maxWidth: 1000,
            minWidth: 200
        ),
        child: FutureBuilder<UserProfile?>(
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
                  image_url: null,
                  full_name: 'loading');
            }
            return Scaffold(
              body: Column(
                mainAxisSize: MainAxisSize.max,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20,0,10,10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: ProfileWidget(
                                imagePath: profile.image_url,
                              ),
                            ),

                            Expanded(flex:2,child: Center(child: NumbersWidget(profile_id: profile.user_id,likes: profile.num_likes ?? -1, subs: profile.num_subs ?? 1,))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildName(profile.full_name ?? 'no full_name chosen',
                            profile.handle ?? "no handle minted"),
                        const SizedBox(
                          height: 10,
                        ),
                        buildBio(profile.bio ?? "tell them what you're about"),
                        const SizedBox(
                          height: 20,
                        ),
                        ShadowButton(
                            text: "Edit Profile",
                            onclick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                          name: profile.full_name!,
                                          bio: profile.bio!,
                                          handle: profile.handle!,
                                          profile: profile,
                                        )),
                              );
                            }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(child: TabBarToggle(profile: profile)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildName(String name, String handle) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.normal,
              fontFamily: "Unna",
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "@" + handle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
              fontFamily: "Montserrat-Semibold",
            ),
          ),
        ],
      );

  Widget buildBio(String bio) => Align(
    alignment: AlignmentDirectional.topStart,
    child: Text(
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
  );
}
