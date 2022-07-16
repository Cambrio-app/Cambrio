import 'package:cambrio/widgets/profile/NumbersWidget.dart';
import 'package:cambrio/widgets/profile/ProfileWidget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_profile.dart';
import '../../services/firebase_service.dart';
import '../../services/payments_service.dart';
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
    // report to analytics that the user went to this page
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'AuthorProfile');

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            // maxHeight: 300,
            // minHeight: 200,
            maxWidth: 1000,
            minWidth: 200),
        child: Scaffold(
          appBar: AppBar(),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              Center(
                child: ProfileWidget(
                  imagePath: widget.profile.image_url,
                ),
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
              NumbersWidget(
                  profile_id: widget.profile.user_id,
                  subs: widget.profile.num_subs ?? -1,
                  likes: widget.profile.num_likes ?? 0),
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
        ),
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
              fontFamily: "Montserrat",
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
              fontFamily: "Montserrat",
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
        return Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ShadowButton(
                text: (snapshot.data ?? false)
                    ? "Manage Subscription"
                    : "Subscribe",
                onclick: () {
                  // report to analytics that the user went to this page
                  FirebaseAnalytics.instance
                      .setCurrentScreen(screenName: 'Subscribe');
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: SubscribeButton(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 40, 20, 0),
                                    child: fullSubscribeButton(),
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
                }),
          ),
        );
      });

  Widget SubscribeButton() => FutureBuilder<bool>(
      future: FirebaseService().isSubscribed(widget.profile.user_id),
      builder: (context, snapshot) {
        return Center(
          child: ShadowButton(
              text: (snapshot.data ?? false)
                  ? "Unsubscribe from Free Content"
                  : "Subscribe to All Their Free Content",
              onclick: () {
                if (snapshot.data ?? false) {
                  // report to analytics that the user selected this content
                  FirebaseAnalytics.instance.logSelectContent(
                    contentType: 'unsub',
                    itemId: widget.profile.user_id,
                  );
                  FirebaseService()
                      .removeSubscription(author_id: widget.profile.user_id);
                } else {
                  // report to analytics that the user selected this content
                  FirebaseAnalytics.instance.logSelectContent(
                    contentType: 'sub',
                    itemId: widget.profile.user_id,
                  );
                  FirebaseService()
                      .editSubscription(author_id: widget.profile.user_id);
                }
                Navigator.of(context).pop();
              }),
        );
      });

  Widget fullSubscribeButton() => FutureBuilder<bool>(
      future: Future(() => false), //FirebaseService().isSubscribed(widget.profile.user_id),
      builder: (context, snapshot) {
        return Center(
          child: (snapshot.data ?? false)
              ? ShadowButton(
                  text: "Unsubscribe from Paid Content",
                  onclick: () {},
                )
              : FutureBuilder<int>(
                  //TODO: put in the future.
                  future: (PaymentsService.getPriceValue(
                      author_account_id:
                          widget.profile.connected_account_id ?? '',
                      price_lookup_key: widget.profile.user_id)),
                  builder: (context, snapshot) {
                    return ShadowButton(
                        text:
                            "Subscribe to All Their Paid Content for \$${snapshot.data ?? '(getting price)'} a month!",
                        onclick: () async {
                          if (snapshot.data == false) {
                            Subscribe();
                            // report to analytics that the user selected this content
                            // FirebaseAnalytics.instance
                            //     .logSelectContent(
                            //   contentType: 'paid_unsub',
                            //   itemId: widget.profile.user_id,
                            // );
                            // FirebaseService()
                            //     .removeSubscription(author_id: widget.profile.user_id);
                          } else {
                            // report to analytics that the user selected this content
                            // FirebaseAnalytics.instance
                            //     .logSelectContent(
                            //   contentType: 'paid_sub',
                            //   itemId: widget.profile.user_id,
                            // );
                            // FirebaseService()
                            //     .editSubscription(author_id: widget.profile.user_id);
                          }
                          // Navigator.of(context).pop();
                        });
                  }),
        );
      });
  Future<void> Subscribe() async {
    String price = (await PaymentsService.getPriceObject(
        author_account_id: widget.profile.connected_account_id ?? '',
        price_lookup_key: FirebaseService.instance.userId))['id'];
    int priceNum = (await PaymentsService.getPriceObject(
        author_account_id: widget.profile.connected_account_id ?? '',
        price_lookup_key: FirebaseService.instance.userId))['unit_amount'];
    debugPrint('price: $priceNum cents usd');
    String checkoutUrl = await PaymentsService.subscribe(
        author_account_id: widget.profile.connected_account_id ?? '',
        price: price,
        customer_id: FirebaseService.instance.userId);
    debugPrint('the checkout url: $checkoutUrl');
    if (!await launchUrl(Uri.parse(checkoutUrl)))
      throw 'Could not launch ${Uri.parse(checkoutUrl)}';
  }
}
