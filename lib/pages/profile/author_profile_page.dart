import 'package:cambrio/models/user_preferences.dart';
import 'package:cambrio/widgets/profile/NumbersWidget.dart';
import 'package:cambrio/widgets/profile/ProfileWidget.dart';
import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../../services/firebase_service.dart';
import '../../widgets/shadow_button.dart';

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
      appBar: AppBar(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          ProfileWidget(
            imagePath: widget.profile.image_url,
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
          NumbersWidget(subs: widget.profile.num_subs ?? -1, likes: widget.profile.num_likes ?? 0),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
  Widget EditButton() => FutureBuilder<bool>(
      future: FirebaseService().isSubscribed(widget.profile.user_id),
      builder: (context, snapshot) {
        return ShadowButton(
            text:
                (snapshot.data ?? false) ? "Manage Subscription" : "Subscribe",
            onclick: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (BuildContext context,
                        StateSetter setState /*You can rename this!*/) {
                      return Container(
                        color: const Color(0xFF737373),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                child: SubscribeButton(),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                                child: Text("Coming Soon: More ways to financially support your favorite author!"),
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
                  }).then((_) => setState(() {}));
            });
      });

  Widget SubscribeButton() => FutureBuilder<bool>(
      future: FirebaseService().isSubscribed(widget.profile.user_id),
      builder: (context, snapshot) {
        return Center(
          child: ShadowButton(
              text: (snapshot.data ?? false)
                  ? "Unsubscribe"
                  : "Subscribe to All Their Books",
              onclick: () {
                if (snapshot.data ?? false) {
                  FirebaseService()
                      .removeSubscription(author_id: widget.profile.user_id);
                } else {
                  FirebaseService()
                      .editSubscription(author_id: widget.profile.user_id);
                }
                Navigator.of(context).pop();
              }),
        );
      });
}
