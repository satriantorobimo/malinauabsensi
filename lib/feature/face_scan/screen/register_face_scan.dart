import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/util/convert_image_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

class RegisterFaceScan extends StatefulWidget {
  final CameraDescription camera;

  const RegisterFaceScan({super.key, required this.camera});

  @override
  State<RegisterFaceScan> createState() => _RegisterFaceScanState();
}

class _RegisterFaceScanState extends State<RegisterFaceScan> {
  CameraController? _controller;
  final FaceDetector _faceDetector = GoogleVision.instance.faceDetector(
    const FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
      enableLandmarks: true,
    ),
  );
  int _currentStep = 1; // Step 1: Front, Step 2: Right, Step 3: Left
  String _facePosition = 'No face detected';
  bool _isDetecting = false;
  XFile? image;
  bool isBusy = false;
  Map<String, Uint8List> _capturedImages = {};

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );
    await _controller!.initialize();

    _controller!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _detectFaces(image);
      }
    });
  }

  Future<void> _detectFaces(CameraImage image) async {
    if (_isDetecting || image.planes.isEmpty) return;
    setState(() {
      _isDetecting = true;
    });

    try {
      final visionImage = _convertCameraImage(image);
      final List<Face> faces = await _faceDetector.processImage(visionImage);

      if (faces.isNotEmpty) {
        final Face face = faces[0];
        final leftEye = face.getLandmark(FaceLandmarkType.leftEye);
        final rightEye = face.getLandmark(FaceLandmarkType.rightEye);

        // Check if headEulerAngleY and headEulerAngleX are available and use them if possible
        double? headYaw = face.headEulerAngleY; // Y-axis rotation (left/right)
        double? headPitch = face.headEulerAngleZ; // X-axis rotation (up/down)

        if (headYaw != null && headPitch != null) {
          log('Head yaw angle: $headYaw, Head pitch angle: $headPitch');

          setState(() {
            // Check front, right, and left positions based on headYaw (Y-axis rotation)
            if (headYaw.abs() < 20) {
              _facePosition = 'Hadapkan muka ke depan';
              log('Front Face Detected');
            } else if (headYaw > 40) {
              _facePosition = 'Hadapkan muka ke samping kanan';
              log('Right Face Detected');
            } else if (headYaw < -20) {
              _facePosition = 'Hadapkan muka ke samping kiri';
              log('Left Face Detected');
            }

            // Check top and bottom positions based on headPitch (X-axis rotation)
            if (headPitch > 20) {
              _facePosition = 'Hadapkan muka ke bawah';
              log('Bottom Face Detected');
            } else if (headPitch < -20) {
              _facePosition = 'Hadapkan muka ke atas';
              log('Top Face Detected');
            }

            _checkStep(
                image); // Verify if the current step matches the required face position
          });
        } else if (leftEye != null && rightEye != null) {
          // Fallback to eye position difference if head yaw is unavailable
          final double difference = leftEye.position.dx - rightEye.position.dx;
          log('Difference between left and right eye positions: $difference');

          setState(() {
            // Adjust these thresholds based on observed difference values
            if (difference.abs() < 30) {
              _facePosition = 'Hadapkan muka ke depan';
              log('Front Face Detected 2');
            } else if (difference >= 30) {
              _facePosition = 'Hadapkan muka ke samping kanan';
              log('Left Face Detected 2');
            } else if (difference <= -30) {
              _facePosition = 'Hadapkan muka ke samping kiri';
              log('Right Face Detected 2');
            }

            _checkStep(image);
          });
        } else {
          log("One or both eye landmarks not detected.");
          setState(() {
            _facePosition = 'Face detected but landmarks missing';
          });
        }
      } else {
        setState(() {
          _facePosition = 'No face detected';
        });
      }
    } catch (e) {
      log('Error detecting face: $e');
    } finally {
      setState(() {
        _isDetecting = false;
      });
    }
  }

  GoogleVisionImage _convertCameraImage(CameraImage image) {
    // Concatenate all bytes from planes
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return GoogleVisionImage.fromBytes(
      bytes,
      GoogleVisionImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: getRotation(),
        rawFormat: image.format.raw,
        planeData: image.planes.map((Plane plane) {
          return GoogleVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        }).toList(),
      ),
    );
  }

  ImageRotation getRotation() {
    switch (_controller!.description.sensorOrientation) {
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      case 270:
        return ImageRotation.rotation270;
      default:
        return ImageRotation.rotation0;
    }
  }

  void _checkStep(CameraImage image) {
    switch (_currentStep) {
      case 1: // Step 1: Front Face
        if (_facePosition == 'Hadapkan muka ke depan') {
          setState(() {
            _currentStep = 2;
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            _capturedImages['Front Face'] = capturedImage;
            _facePosition = 'Hadapkan muka ke samping kanan';
          });
        }
        break;
      case 2: // Step 2: Right Face
        if (_facePosition == 'Hadapkan muka ke samping kanan') {
          setState(() {
            _currentStep = 3;
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            _capturedImages['Right Face'] = capturedImage;
            _facePosition = 'Hadapkan muka ke samping kiri';
          });
        }
        break;
      case 3: // Step 3: Left Face
        if (_facePosition == 'Hadapkan muka ke samping kiri') {
          setState(() {
            _currentStep = 4;
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            _capturedImages['Left Face'] = capturedImage;
            _facePosition = 'Hadapkan muka ke atas';
          });
        }
        break;
      case 4: // Step 4: Top Face
        if (_facePosition == 'Hadapkan muka ke atas') {
          setState(() {
            _currentStep = 5;
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            _capturedImages['Top Face'] = capturedImage;
            _facePosition = 'Hadapkan muka ke bawah';
          });
        }
        break;
      case 5: // Step 5: Bottom Face
        if (_facePosition == 'Hadapkan muka ke bawah') {
          setState(() {
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            _capturedImages['Bottom Face'] = capturedImage;
          });
          _facePosition = 'Mohon menunggu sebentar';
          _navigateToNextPage();
        }
        break;
      default:
        break;
    }
  }

  void _navigateToNextPage() {
    _successDialog(context);
  }

  @override
  void dispose() {
    _controller!.dispose();
    _faceDetector.close;
    super.dispose();
  }

  Future<void> _successDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'assets/imgs/success.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Registrasi muka sukses',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text(
                    'Anda sudah bisa melakukan absensi melalui scan muka.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () async {
                    _controller!.stopImageStream();

                    WidgetsFlutterBinding.ensureInitialized();
                    final cameras = await availableCameras();
                    final firstCamera = cameras.first;
                    if (context.mounted) {
                      Navigator.pushNamed(
                          context, StringRouterUtil.faceScanScreenRoute,
                          arguments: ArgumentAbsenModel(
                              camera: firstCamera, isIn: true));
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 41,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                        child: Text('Absen Masuk',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(_facePosition,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 32.0, left: 32.0, right: 32.0),
                    //   child: InkWell(
                    //     onTap: () async {
                    //       // if (_controller!.value.isInitialized) {
                    //       //   _controller!.setFlashMode(FlashMode.off);
                    //       //   image = await _controller!.takePicture();
                    //       //   setState(() {
                    //       //     // showLoaderDialog(context);
                    //       //     final inputImage =
                    //       //         InputImage.fromFilePath(image!.path);
                    //       //     Platform.isAndroid
                    //       //         ? processImage(inputImage)
                    //       //         : Navigator.pushNamed(context,
                    //       //             StringRouterUtil.successScanScreenRoute);
                    //       //   });
                    //       // }
                    //       setState(() {
                    //         _controller!.pausePreview();
                    //       });
                    //       await Navigator.pushNamed(
                    //               context,
                    //               StringRouterUtil
                    //                   .faceRegisterRightScanScreenRoute,
                    //               arguments: widget.camera)
                    //           .then((value) {
                    //         setState(() {
                    //           _controller!.resumePreview();
                    //         });
                    //       });
                    //     },
                    //     child: Container(
                    //       width: double.infinity,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         color: primaryColor,
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       child: const Center(
                    //           child: Text('Ambil Foto',
                    //               style: TextStyle(
                    //                   fontSize: 15,
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.w600))),
                    //     ),
                    //   ),
                    // ),
                  ],
                )),
            body: Stack(
              children: [
                _controller == null || !_controller!.value.isInitialized
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          Center(
                              child: AspectRatio(
                                  aspectRatio: 4.0 / 7.0,
                                  child: CameraPreview(_controller!))),
                          CustomPaint(
                            painter: OverlayPainter(
                                screenHeight:
                                    MediaQuery.of(context).size.height,
                                screenWidth: MediaQuery.of(context).size.width),
                          ),
                        ],
                      ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                            border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.1)),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/imgs/logo.png', width: 40),
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.person_2_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Hi, John',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(height: 2),
                                      Text('Udayana, S.IP, M,M',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF797979),
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 2),
                                      Text('Staff',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF797979),
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      customButton: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: primaryColor,
                                      ),
                                      isExpanded: true,
                                      buttonStyleData: ButtonStyleData(
                                        // This is necessary for the ink response to match our customButton radius.
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        width: 160,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(40, -30),
                                      ),
                                      menuItemStyleData: MenuItemStyleData(
                                        customHeights: [
                                          ...List<double>.filled(
                                              MenuItems.firstItems.length, 48),
                                          8,
                                          ...List<double>.filled(
                                              MenuItems.secondItems.length, 48),
                                        ],
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                      ),
                                      items: [
                                        ...MenuItems.firstItems.map(
                                          (item) => DropdownMenuItem<MenuItem>(
                                            value: item,
                                            child: MenuItems.buildItem(item),
                                          ),
                                        ),
                                        const DropdownMenuItem<Divider>(
                                            enabled: false, child: Divider()),
                                        ...MenuItems.secondItems.map(
                                          (item) => DropdownMenuItem<MenuItem>(
                                            value: item,
                                            child: MenuItems.buildItem(item),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        var a = value as MenuItem;
                                        if (a.text == 'Logout') {
                                          SharedPrefUtil.clearSharedPref();
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              StringRouterUtil.loginScreenRoute,
                                              (route) => false);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24, bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: primaryColor,
                                  size: 24,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 4.0, right: 16),
                                child: Column(
                                  children: [
                                    Text('Registrasi Muka',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF202020),
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 8),
                                    SizedBox(
                                      width: 245,
                                      child: Text(
                                          'Mohon ikuti perintah dibawah untuk menyelesaikan registrasi muka',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                              ),
                              Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}

class OverlayPainter extends CustomPainter {
  final double screenWidth;
  final double screenHeight;

  OverlayPainter({required this.screenWidth, required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = screenWidth * 0.35;
    const strokeWidth = 2.0;
    final circlePath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(screenWidth / 2, screenHeight / 2.3),
        radius: radius,
      ));

    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
    final overlayPath =
        Path.combine(PathOperation.difference, outerPath, circlePath);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawPath(overlayPath, paint);
    canvas.drawCircle(
      Offset(screenWidth / 2, screenHeight / 2.3),
      radius,
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
