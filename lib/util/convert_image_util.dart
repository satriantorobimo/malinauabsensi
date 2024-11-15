import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

Uint8List convertCameraImageToUint8List(CameraImage image) {
  final int width = image.width;
  final int height = image.height;

  // Create an empty RGB image
  final img.Image yuvImage = img.Image(width: width, height: height);

  final int uvRowStride = image.planes[1].bytesPerRow.toInt();
  final int uvPixelStride = image.planes[1].bytesPerPixel!.toInt();

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int uvIndex = uvPixelStride * (x ~/ 2) + uvRowStride * (y ~/ 2);
      final int yIndex = (y * image.planes[0].bytesPerRow.toInt() + x);
      final int u = image.planes[1].bytes[uvIndex] - 128;
      final int v = image.planes[2].bytes[uvIndex] - 128;
      final int yValue = image.planes[0].bytes[yIndex];

      // Apply the color conversion from YUV to RGB
      final int r = (yValue + (1.370705 * v)).clamp(0, 255).toInt();
      final int g =
          (yValue - (0.337633 * u) - (0.698001 * v)).clamp(0, 255).toInt();
      final int b = (yValue + (1.732446 * u)).clamp(0, 255).toInt();

      yuvImage.setPixel(x, y, img.ColorUint8.rgb(r, g, b));
    }
  }

  return Uint8List.fromList(img.encodePng(yuvImage));
}
