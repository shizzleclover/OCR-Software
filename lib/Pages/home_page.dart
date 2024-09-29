import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_app/Widgets/picker_option_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //!.......................................................................
 /// Variable that will store the text extracted from the image
  String _extractedText = '';

  /// Pick a image from a source
  /// Requires a [source]
  Future<File?> _pickerImage({required ImageSource source}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Allow crop a image file
  /// Requires a [imageFile]
  Future<CroppedFile?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedfile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );

    if (croppedfile != null) {
      return croppedfile;
    }

    return null;
  }

  /// Create a instance from [TextRecognizer] and try extract text from a image
  /// Requires a [imgPath]
  Future<String> _recognizeTextFromImage({required String imgPath}) async {
    /// Create an instance of TextRecognizer
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    /// Process image
    final image = InputImage.fromFile(File(imgPath));
    final recognized = await textRecognizer.processImage(image);

    return recognized.text;
  }

  /// Allows you to select an image from a source
  /// Crop the selected image
  /// Processes the image and extracts found text information
  /// Requires a [imageSource]
  Future<void> _processImageExtractText({
    required ImageSource imageSource,
  }) async {
    final imageFile = await _pickerImage(source: imageSource);

    if (imageFile == null) return;

    final croppedImage = await _cropImage(
      imageFile: imageFile,
    );

    if (croppedImage == null) return;

    final recognizedText = await _recognizeTextFromImage(
      imgPath: croppedImage.path,
    );

    setState(() => _extractedText = recognizedText);
  }

  /// Copy the content from [_extractedText] to clip board and show a snackbar alert
  void _copyToClipBoard() {
    Clipboard.setData(ClipboardData(text: _extractedText));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to Clipboard'),
      ),
    );
  }
//! .........................................................................................................
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Ocr App'),),
      body: Column(
        children: [
          const Text(
            'Seleect an Option',
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 10.0,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PickerOptionWidget(
                  color: Colors.blueAccent, 
                  icon: Icons.image_outlined, 
                  label: 'From Gallery',
                  onTap: ()  => _processImageExtractText
                  (imageSource: ImageSource.gallery,
                  ),
                  ),
                  const SizedBox(width: 10.0,),
                  PickerOptionWidget(
                    color: Colors.redAccent,
                     icon: Icons.camera_alt_outlined,
                      label: 'From Camera',
                      onTap: () => _processImageExtractText
                      (imageSource: ImageSource.camera)
                      ),
              ],
            ),
            ),
            if(_extractedText.isNotEmpty) ... {
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Previously Read',
                      style: TextStyle(fontSize: 22.0),
                    ),
                    IconButton(
                      onPressed: _copyToClipBoard,
                       icon: const Icon(Icons.copy),
                       )
                  ],
                ),
                ), 

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: Text(_extractedText),
                      ),
                    ),
                  )
                )
            }
           
        ],
      ),
    );
  }
}