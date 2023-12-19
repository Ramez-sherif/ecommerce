import 'dart:io';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/item_details_page.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/services/product.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScanning extends StatefulWidget {
  const ProductScanning({Key? key}) : super(key: key);

  @override
  State<ProductScanning> createState() => _ProductScanningState();
}

class _ProductScanningState extends State<ProductScanning> {
  ProductService productService = ProductService();

  late InputImage _inputImage;
  File? _pickedImage;
  static final ImageLabelerOptions _options =
      ImageLabelerOptions(confidenceThreshold: 0.8);
  final imageLabeler = ImageLabeler(options: _options);
  final ImagePicker _imagePicker = ImagePicker();
  String text = "";

  Future<void> pickImageFromCamera(List<ProductModel> homeAllProducts) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    setState(() {
      _pickedImage = File(image.path);
    });
    _inputImage = InputImage.fromFilePath(image.path);
    identifyImage(_inputImage, homeAllProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Labeling"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_pickedImage != null && kIsWeb)
              Image.network(
                // For web, display using network image widget
                _pickedImage!.path,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else if (_pickedImage != null && !kIsWeb)
              Image.file(
                // For non-web platforms, display using file image widget
                _pickedImage!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 300,
                color: Colors.black,
                width: double.infinity,
              ),
            Expanded(
              child: Container(),
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(
                  "Pick Image",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  pickImageFromCamera(
                      context.read<HomeProvider>().homeAllProducts);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void identifyImage(
      InputImage inputImage, List<ProductModel> homeAllProducts) async {
    final List<ImageLabel> image = await imageLabeler.processImage(inputImage);
    if (image.isEmpty) {
      setState(() {
        text = "Can't identify image";
      });
      return;
    }

    for (ImageLabel img in image) {
      setState(() {
        text = "Label:${img.label}\nConfidence :${img.confidence}";

        for (ProductModel product in homeAllProducts) {
          if (img.label == product.name) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: ItemDetailsPage(
                    product: product,
                  ),
                ),
              ),
            );
          }
        }
      });
    }
    imageLabeler.close();
  }
}