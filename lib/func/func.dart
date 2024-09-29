// /// Variable that will store the text extracted from the image
//   String _extractedText = '';

//   /// Pick a image from a source
//   /// Requires a [source]
//   Future<File?> _pickerImage({required ImageSource source}) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       return File(image.path);
//     }
//     return null;
//   }

//   /// Allow crop a image file
//   /// Requires a [imageFile]
//   Future<CroppedFile?> _cropImage({required File imageFile}) async {
//     CroppedFile? croppedfile = await ImageCropper().cropImage(
//       sourcePath: imageFile.path,
//       uiSettings: [
//         AndroidUiSettings(
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ],
//         ),
//         IOSUiSettings(
//           minimumAspectRatio: 1.0,
//         ),
//       ],
//     );

//     if (croppedfile != null) {
//       return croppedfile;
//     }

//     return null;
//   }

//   /// Create a instance from [TextRecognizer] and try extract text from a image
//   /// Requires a [imgPath]
//   Future<String> _recognizeTextFromImage({required String imgPath}) async {
//     /// Create an instance of TextRecognizer
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//     /// Process image
//     final image = InputImage.fromFile(File(imgPath));
//     final recognized = await textRecognizer.processImage(image);

//     return recognized.text;
//   }

//   /// Allows you to select an image from a source
//   /// Crop the selected image
//   /// Processes the image and extracts found text information
//   /// Requires a [imageSource]
//   Future<void> _processImageExtractText({
//     required ImageSource imageSource,
//   }) async {
//     final imageFile = await _pickerImage(source: imageSource);

//     if (imageFile == null) return;

//     final croppedImage = await _cropImage(
//       imageFile: imageFile,
//     );

//     if (croppedImage == null) return;

//     final recognizedText = await _recognizeTextFromImage(
//       imgPath: croppedImage.path,
//     );

//     setState(() => _extractedText = recognizedText);
//   }

//   /// Copy the content from [_extractedText] to clip board and show a snackbar alert
//   void _copyToClipBoard() {
//     Clipboard.setData(ClipboardData(text: _extractedText));

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Copied to Clipboard'),
//       ),
//     );
//   }
