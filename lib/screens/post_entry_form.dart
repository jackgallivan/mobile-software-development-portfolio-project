import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/posts_list.dart';
import '../widgets/posts_scaffold.dart';
import '../widgets/large_button.dart';
import '../models/post_entry.dart';
import '../db/post_entry_dao.dart';

class PostEntryForm extends StatefulWidget {
  static const routeName = 'new_post';
  final String title = 'New Post';

  const PostEntryForm({Key? key}) : super(key: key);

  @override
  State<PostEntryForm> createState() => _PostEntryFormState();
}

class _PostEntryFormState extends State<PostEntryForm> {
  final formKey = GlobalKey<FormState>();

  final locationService = Location();

  final picker = ImagePicker();
  Future<XFile?>? pickedFile;
  File? image;

  final postsRef = PostEntryDAO.postsRef;
  final postEntryValues = PostEntry();

  /* INIT STATE */
  @override
  void initState() {
    super.initState();
    retrieveLocation();
    getImage();
  }

  void retrieveLocation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData? locationData;
      _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          debugPrint('Failed to enable service. Returning.');
          return;
        }
      }

      _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          debugPrint('Location service permission not granted. Returning.');
          return;
        }
      }

      locationData = await locationService.getLocation();
      postEntryValues.location = GeoPoint(
        locationData.latitude!,
        locationData.longitude!,
      );
    } on PlatformException catch (e) {
      debugPrint('Error: ${e.toString()}, code: ${e.code}');
    }
  }

  void getImage() {
    pickedFile = picker.pickImage(source: ImageSource.gallery);
  }

  /* BUILD */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pickedFile,
      builder: (BuildContext context, AsyncSnapshot<XFile?> snapshot) {
        Widget child;
        Widget? bottomButton;
        if (snapshot.hasData) {
          image = File(snapshot.data!.path);
          child = ListView(
            shrinkWrap: true,
            children: [
              Image.file(
                image!,
                semanticLabel: 'Your selected image',
              ),
              const SizedBox(height: 10),
              quantityTextField(),
            ],
          );
          bottomButton = uploadButton(context);
        } else if (snapshot.hasError) {
          child = const Center(child: Icon(Icons.insert_photo));
        } else {
          child = const Center(child: CircularProgressIndicator());
        }
        return PostsScaffold(
          title: widget.title,
          body: Form(key: formKey, child: child),
          bottomWidget: bottomButton,
        );
      },
    );
  }

  Widget quantityTextField() {
    return Semantics(
      child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Number of Wasted Items'),
        style: Theme.of(context).textTheme.headline4,
        onSaved: (value) {
          postEntryValues.quantity = int.parse(value!);
        },
        validator: (value) {
          if (value == null || int.tryParse(value) == null) {
            return 'Please enter a whole number';
          }
          return null;
        },
      ),
      textField: true,
      label: 'Text field for number of wasted items',
      onTapHint: 'Enter the number of wasted items as a whole number',
    );
  }

  Widget uploadButton(BuildContext context) {
    return Semantics(
      child: LargeButton(
        onPressed: () => uploadPost(context),
        child: const Icon(Icons.cloud_upload),
      ),
      button: true,
      enabled: true,
      label: 'Button to upload your post',
      onTapHint: 'Upload your post',
    );
  }

  void uploadPost(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      formKey.currentState!.save();
      await uploadImage();
      await postsRef.add(postEntryValues);
      Navigator.of(context).popUntil(
          (route) => route.settings.name == PostsListScreen.routeName);
    }
  }

  Future<void> uploadImage() async {
    postEntryValues.date = DateTime.now();
    if (image != null) {
      String fileName = postEntryValues.date!.toString() + '.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image!);
      await uploadTask;
      postEntryValues.imageURL = await storageReference.getDownloadURL();
    } else {
      postEntryValues.imageURL = 'null';
    }
  }
}
