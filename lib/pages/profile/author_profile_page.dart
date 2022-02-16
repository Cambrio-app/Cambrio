import 'package:cambrio/models/user_preferences.dart';
import 'package:cambrio/widgets/NumbersWidget.dart';
import 'package:cambrio/widgets/ProfileWidget.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/firebase_service.dart';

class AuthorProfilePage extends StatefulWidget {
  final UserProfile profile;

  const AuthorProfilePage({Key? key, required this.profile}) : super(key: key);
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
            imagePath: widget.profile.imageURL,
          ),
          const SizedBox(
            height: 20,
          ),
          buildName(widget.profile.full_name ?? 'anonymous',
              widget.profile.handle ?? 'user'),
          const SizedBox(
            height: 20,
          ),
          buildBio(widget.profile.bio ??
              "we don't even know if this author is human"),
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

  // ignore: non_constant_identifier_names
  Widget EditButton() => Container(
        color: Colors.black,
        height: 60,
        padding: const EdgeInsets.only(bottom: 4, right: 5),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          height: 40,
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (BuildContext context,
                      StateSetter setState /*You can rename this!*/) {
                    return Container(
                      color: const Color(0xFF737373),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SubscribeButton(),
                            ),
                          ],
                        ),
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
          child: const Text(
            "Subscribe",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: "Montserrat-Semibold",
            ),
          ),
        ),
      );

  Widget SubscribeButton() => Center(
        child: Container(
          //color: Colors.black,
          margin: const EdgeInsets.all(30),
          height: 50,
          padding: const EdgeInsets.only(top: 5, bottom: 3, right: 4),
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
              FirebaseService()
                  .editSubscription(author_id: widget.profile.user_id);
            },
            color: Colors.white,
            elevation: 0,
            child: const Text(
              "Subscribe to all of their books",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
}
