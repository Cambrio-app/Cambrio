import 'dart:ui';

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
import 'package:provider/provider.dart';

import '../../models/tutorials_state.dart';
import '../../util/get_positions.dart';
import '../edit_book.dart';
import '../settings.dart';

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

  bool tutorial = true;

  @override
  Widget build(BuildContext context) {
    // UserProfile? profile = await FirebaseService().getProfile(uid: FirebaseAuth.instance.currentUser!.uid);

    // whether the tutorial should be shown.
    tutorial = TutorialsState.instance.showAddBooksTutorial;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            // maxHeight: 300,
            // minHeight: 200,
            maxWidth: 1000,
            minWidth: 200),
        child: Consumer<TutorialsState>(
          child: buildProfilePage(),
          builder: (context, tutorialsState, child) {
            return Stack(
              children: [
                if (child!=null) child,
                if (tutorialsState.showAddBooksTutorial) buildTutorial(),
                // the tutorial
                // Consumer<TutorialsState>(
                //     builder: (context, tutorialsState, child) {
                //       return (tutorialsState.showAddBooksTutorial) ? buildTutorial() : null;
                //     }
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildProfilePage() {
    return FutureBuilder<UserProfile?>(
      future: FirebaseService()
          .getProfile(uid: FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context,
          AsyncSnapshot<UserProfile?> snapshot) {
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
                padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ProfileWidget(
                            imagePath: profile.image_url,
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Center(
                                child: NumbersWidget(
                                  profile_id: profile.user_id,
                                  likes: profile.num_likes ?? -1,
                                  subs: profile.num_subs ?? 1,
                                ))),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildName(
                        profile.full_name ?? 'no full_name chosen',
                        profile.handle ?? "no handle minted"),
                    const SizedBox(
                      height: 10,
                    ),
                    buildBio(profile.bio ??
                        "tell them what you're about"),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,20,0),
                      child: ShadowButton(
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
                    ),
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
    );
  }


  Widget buildName(String name, String handle) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.65*MediaQuery.of(context).size.width),
            child: Text(
              name
                  .characters
                  .replaceAll(Characters(''), Characters('\u{200B}'))
                  .toString(), // this makes it al kinda one string so it's elisised properly
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.normal,
                fontFamily: "Unna",
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "@" + handle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              fontFamily: "Montserrat",
            ),
          ),
        ],
      );

  Widget buildBio(String bio) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Text(
          bio,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            fontFamily: "Montserrat",
          ),
          maxLines: 4,
          softWrap: true,
          overflow: TextOverflow.fade,
        ),
      );

  Widget buildTutorial() {
    return Material(
      type: MaterialType.transparency,
      // child: Positioned(
      // top: getPositions(_keyBell).dy,
      // left: getPositions(_keyBell).dx,
      child: GestureDetector(
        onTap: () => TutorialsState.instance.setSawTutorial(),
        child: ClipPath(
          clipper: InvertedClipper(),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              constraints: BoxConstraints.expand(),
              padding: const EdgeInsets.fromLTRB(150, 400, 20, 130),
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Click on the Add button to start a new book, or click on a book to add or edit a chapter!',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}

class InvertedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
          const Rect.fromLTWH(5, 300, 125, 200), const Radius.circular(10)))
      ..addOval(Rect.fromCircle(
          center: Offset(size.width - 48, size.height - 48), radius: 60))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
