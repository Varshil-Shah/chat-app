import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class InputImage extends StatefulWidget {
  File? pickedImage;

  InputImage({Key? key, this.pickedImage}) : super(key: key);

  @override
  _InputImageState createState() => _InputImageState();
}

enum ImageInputMethod {
  camera,
  gallery,
}

class _InputImageState extends State<InputImage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void takeImage(ImageInputMethod method) async {
      XFile? image;
      if (ImageInputMethod.camera == method) {
        image = await ImagePicker().pickImage(source: ImageSource.camera);
      } else {
        image = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      setState(() {
        widget.pickedImage = File(image!.path);
      });
    }

    void showImageInputOptions() {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(10.0),
          height: 200.0,
          child: Column(
            children: [
              ListTile(
                dense: true,
                title: const Text(
                  "Select option",
                  style: TextStyle(fontSize: 18.0),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Divider(
                color: Colors.grey.shade500,
              ),
              ListTile(
                dense: true,
                title: const Text(
                  "CAMERA",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () => takeImage(ImageInputMethod.camera),
                leading: const Icon(Icons.camera_alt_outlined),
              ),
              ListTile(
                dense: true,
                title: const Text(
                  "GALLERY",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () => takeImage(ImageInputMethod.gallery),
                leading: const Icon((Icons.photo_camera_back_outlined)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: widget.pickedImage != null
              ? FileImage(widget.pickedImage as File)
              : const AssetImage("assets/images/circular-avatar.png")
                  as ImageProvider,
          backgroundColor: Colors.grey,
        ),
        const SizedBox(height: 15.0),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          width: size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: mainColor,
          ),
          child: TextButton.icon(
            icon: const Icon(
              Icons.camera,
              color: Colors.white,
            ),
            onPressed: showImageInputOptions,
            label: const Text(
              "Select image",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
