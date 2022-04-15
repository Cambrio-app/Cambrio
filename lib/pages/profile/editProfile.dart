import 'dart:io';

import 'package:cambrio/pages/profile/personal_profile_page.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/services/payments_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/models/user_preferences.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_profile.dart';
import '../../widgets/alert.dart';
import '../../widgets/shadow_button.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String handle;
  final String bio;
  final UserProfile profile;

  const EditProfile(
      {Key? key,
      required this.name,
      required this.handle,
      required this.bio,
      required this.profile})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _bioController;
  late TextEditingController _priceController;

  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isTaken = false;
  late UserProfile currentProfile = widget.profile;

  late final Future<int> _current_price;

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _handleController = TextEditingController(text: widget.handle);
    _bioController = TextEditingController(text: widget.bio);
    _priceController = TextEditingController();

    // report to analytics that the user went to this page
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'EditProfile');
    _current_price = PaymentsService.getPrice(price_lookup_key: FirebaseAuth.instance.currentUser!.uid, author_account_id: currentProfile.connected_account_id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseService().isHandleTaken(_handleController.text).then((bool value) {
    //   setState(() {
    //     isTaken = value;
    //   });
    // });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(
            context,
          ),
        ),
        backgroundColor: Colors.white60,
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 24),
            image == null
                ? GestureDetector(
                    onTap: () {
                      filePicker();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    )),
            TextButton(
              onPressed: () async {
                filePicker();
              },
              child: const Text(
                "Change Image",
                style: TextStyle(
                    color: Color(0xFF778DFC), fontFamily: "Montserrat"),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              keyboardType: const TextInputType.numberWithOptions(signed:false,decimal:true),
              controller: _handleController,
              decoration: InputDecoration(
                prefixText: '@',
                labelText: 'Username',
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                hintText: 'Username',
                // prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            if (isTaken)
              const Text('try a unique, creative handle.',
                  style: TextStyle(color: Colors.red)),
            const SizedBox(height: 24),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ShadowButton(
                color: Colors.green,
                text: "Manage Payments",
                onclick: () async {
                  String email = FirebaseAuth.instance.currentUser!.email!;
                  String link = await PaymentsService.addConnectedAccount(email: email);
                  // debugPrint(link);
                  if (!await launch(link)) throw 'Could not launch $link';
                }),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 300,
                child: FutureBuilder<int?>(
                  future: _current_price,
                  builder: (context, snapshot) {
                    int? price = snapshot.data ?? 0;
                    debugPrint('price: $price from ${FirebaseAuth.instance.currentUser!.uid}');
                    _priceController.text = price.toString();
                    return TextField(
                      controller: _priceController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]?')),
                      ],
                      decoration: InputDecoration(
                        prefixText: '\$',
                        filled: true,
                        labelText: 'Per Month Subscription Cost',
                        helperText: 'You can decide how much per month it costs for readers to access your premium content.',
                        helperMaxLines: 2,
                        labelStyle: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      maxLines: 1,
                    );
                  }
                ),
              ),
            ),
            const SizedBox(height: 48),
            ShadowButton(
                color: Theme.of(context).primaryColor,
                text: "Save",
                onclick: () async {
                  // make sure the profile is up-to-date
                  currentProfile = (await FirebaseService()
                      .getProfile(uid: FirebaseAuth.instance.currentUser!.uid))!;

                  // update the profile
                  bool success = await FirebaseService().editProfile(
                    context,
                    full_name: _nameController.text,
                    connected_account_id: currentProfile.connected_account_id,
                    handle: _handleController.text,
                    bio: _bioController.text,
                    url_pic: image?.path ?? widget.profile.image_url,
                    image: image,
                    num_likes: widget.profile.num_likes,
                    num_subs: widget.profile.num_subs,
                  );

                  // make sure that the price is filled, not zero, and new before creating it.
                  if (_priceController.text!='' && _priceController.text!='0' && int.parse(_priceController.text)!=(await _current_price) ){
                    String id = FirebaseAuth.instance.currentUser!.uid;
                    String subscription =
                        await PaymentsService.prepareSubscription(
                      author_account_id: currentProfile.connected_account_id!,
                      author_firebase_id: id,
                      interval: 'month',
                      price: int.parse(_priceController.text)*100, // adjust, since stripe uses cents
                    );
                    debugPrint(subscription.toString());
                  }
                  if (!success) {
                    setState(() {
                      isTaken = true;
                    });
                    Alert().error(context,
                        "sorry, there was a problem submitting your profile.");
                  }
                  // setState(() {
                  //   UserConstant.name = _nameController.text;
                  //   UserConstant.handle = _handleController.text;
                  //   UserConstant.bio = _bioController.text;
                  //   UserConstant.imagePath = image?.path;
                  // });
                  if (success) {
                    Navigator.pop(
                      context,
                    );
                  }
                }),

          ]),
    );
  }

  void filePicker() async {
    final XFile? selectImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = selectImage;
    });
  }
}
