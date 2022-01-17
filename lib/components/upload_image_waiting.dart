import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heke_support/constants/color_constants.dart';

class UploadImageWaiting extends StatelessWidget {
  // final File? imageFile;

  const UploadImageWaiting({Key? key,
    // this.imageFile,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10,),
          child: TextButton(
            child: Material(
              child:Container(
                decoration: BoxDecoration(
                  color: ColorConstants.greyColor2,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  // image: DecorationImage(
                  //   image: FileImage(imageFile!),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                width: 200,
                height: 200,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.themeColor,
                  ),
                ),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              clipBehavior: Clip.hardEdge,
            ),
            onPressed: () {

            },
            style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0))),
          ),
          margin: const EdgeInsets.only(left: 10),
        ),
      ],
    );
  }
}
