import 'dart:io';

import 'package:cambrio/pages/profile/personal_profile_page.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/models/user_preferences.dart';
import 'package:image_picker/image_picker.dart';

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

  final ImagePicker _picker = ImagePicker();
  XFile? image;
  bool isTaken = false;

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _handleController = TextEditingController(text: widget.handle);
    _bioController = TextEditingController(text: widget.bio);

    // report to analytics that the user went to this page
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'EditProfile');
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
              controller: _handleController,
              decoration: InputDecoration(
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
            SizedBox(height: 24),
            ShadowButton(
                color: Theme.of(context).primaryColor,
                text: "Save",
                onclick: () async {
                  bool success = await FirebaseService().editProfile(
                    context,
                    full_name: _nameController.text,
                    handle: _handleController.text,
                    bio: _bioController.text,
                    url_pic: image?.path ?? widget.profile.image_url,
                    image: image,
                    num_likes: widget.profile.num_likes,
                    num_subs: widget.profile.num_subs,
                  );

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
