import 'dart:typed_data';
import 'package:flutter/material.dart';

class CapturedImagesScreen extends StatelessWidget {
  final Map<String, Uint8List> capturedImages;

  const CapturedImagesScreen({super.key, required this.capturedImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Images'),
      ),
      body: capturedImages.isNotEmpty
          ? ListView.builder(
              itemCount: capturedImages.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String key = capturedImages.keys.elementAt(index);
                Uint8List imageData = capturedImages[key]!;

                return Image.memory(
                  imageData,
                  fit: BoxFit.cover,
                  height: 200, // You can adjust the height based on your needs
                );
              },
            )
          : const Center(
              child: Text('No images captured'),
            ),
    );
  }
}
