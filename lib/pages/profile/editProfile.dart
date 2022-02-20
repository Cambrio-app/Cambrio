import 'dart:io';

import 'package:cambrio/pages/profile/personal_profile_page.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/models/user_preferences.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String handle;
  final String bio;

  const EditProfile({ 
    Key? key 
    , required this.name,
    required this.handle,
    required this.bio
    }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _bioController;
  
  final ImagePicker _picker = ImagePicker();
  XFile ? image;

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _handleController = TextEditingController(text: widget.handle);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black,),
          onPressed: () => Navigator.pop(
            context,
          ),
        ),
        backgroundColor: Colors.white60,
      ),
    body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        physics: const BouncingScrollPhysics(),
        children:
        [
          TextButton(
            onPressed: () async{
              filePicker();
            }, 
            child: const Text("Change Image", style: TextStyle(color: Color(0xFF778DFC), fontFamily: "Montserrat-Semibold"),),
          ),
                image == null ? GestureDetector(
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
                ) : 
          CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child:ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.file(
                      File(image!.path), fit: BoxFit.fitHeight,
                      width: 100,
                        height: 100,
                      ),
                    )
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle: TextStyle(
                fontFamily: "Montserrat-SemiBold",
                fontSize: 14,
                color: Colors.grey[600],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
                TextField(
                  controller: _handleController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      fontFamily: "Montserrat-SemiBold",
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    hintText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
              ),
                  ),
                ),

                const SizedBox(height: 24),
                TextField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(
                      fontFamily: "Montserrat-SemiBold",
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                MaterialButton(
                  minWidth: 200,
                  color: const Color(0xff778DFC),
                onPressed: () {
                    FirebaseService().editProfile(
                        full_name: _nameController.text,
                        handle: _handleController.text,
                        bio: _bioController.text,
                        url_pic: image?.path,
                    );
                    setState(() {
                      UserConstant.name = _nameController.text;
                      UserConstant.handle = _handleController.text;
                      UserConstant.bio = _bioController.text;
                      UserConstant.imagePath = image?.path;
                    });
                    Navigator.pop(
                    context,
                  );
                },  
                child: const Text('Save', style: TextStyle(color: Colors.white,
                fontFamily: "Montserrat-SemiBold",
                ),),
              )
        ]
      ),
    );
  }

  void filePicker() async {
    final XFile ? selectImage =  await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = selectImage;
    });
  }
}