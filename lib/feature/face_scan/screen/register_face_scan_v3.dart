import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/bloc/register_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/feature/face_scan/screen/cek_image_screen.dart';
import 'package:malinau_absensi/util/convert_image_util.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class RegisterFaceScanV3 extends StatefulWidget {
  final CameraDescription camera;

  const RegisterFaceScanV3({super.key, required this.camera});

  @override
  State<RegisterFaceScanV3> createState() => _RegisterFaceScanV3State();
}

class _RegisterFaceScanV3State extends State<RegisterFaceScanV3> {
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
  bool _isBuffering = false;
  bool front = false;
  bool left = false;
  bool right = false;
  bool top = false;
  bool bot = false;
  bool isError = false;
  RegisterBloc registerBloc = RegisterBloc(absenRepo: AbsenRepo());
  bool isLoadingData = true;
  late String name;
  late String role;

  @override
  void initState() {
    super.initState();
    GeneralUtil().getDataUser().then(
      (value) {
        setState(() {
          name = value['name']!;
          role = value['role']!;
          isLoadingData = false;
        });
      },
    );
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
      ResolutionPreset.medium,
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
    if (_isDetecting || _isBuffering || image.planes.isEmpty) return;
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
        final noseBase = face.getLandmark(FaceLandmarkType.noseBase);
        final mouthBottom = face.getLandmark(FaceLandmarkType.bottomMouth);

        if (noseBase != null &&
            leftEye != null &&
            rightEye != null &&
            mouthBottom != null) {
          // Check for top and bottom faces based on relative positions
          final double avgEyeY =
              (leftEye.position.dy + rightEye.position.dy) / 2;
          final double noseToEyeY = avgEyeY - noseBase.position.dy;
          final double noseToMouthY =
              noseBase.position.dy - mouthBottom.position.dy;
          setState(() {
            if (noseToEyeY > 15 && noseToMouthY < 10 && !top) {
              // Adjust threshold based on testing
              _facePosition = 'Hadapkan muka ke atas';
              log('Top Face Detected');
            } else if (noseToEyeY < 5 && noseToMouthY > 20 && !bot) {
              // Adjust threshold based on testing
              _facePosition = 'Hadapkan muka ke bawah';
              log('Bottom Face Detected');
            } else {
              final double? headYaw = face.headEulerAngleY;

              if (headYaw!.abs() < 20 && !front) {
                _facePosition = 'Hadapkan muka ke depan';
                log('Front Face Detected');
              } else if (headYaw > 20 && !right) {
                _facePosition = 'Hadapkan muka ke samping kanan';
                log('Right Face Detected');
              } else if (headYaw < -20 && !left) {
                _facePosition = 'Hadapkan muka ke samping kiri';
                log('Left Face Detected');
              }
            }
          });

          _checkStep(
              image); // Verify if the current step matches the required face position
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
        _applyBuffer();
      });
    }
  }

  void _applyBuffer() {
    _isBuffering = true;
    Timer(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        _isBuffering = false;
      });
    });
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
            front = true;
            _capturedImages['staright'] = capturedImage;
            _facePosition = 'Hadapkan muka ke samping kanan';
          });
        }
        break;
      case 2: // Step 2: Right Face
        if (_facePosition == 'Hadapkan muka ke samping kanan') {
          setState(() {
            _currentStep = 3;
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            right = true;
            _capturedImages['right'] = capturedImage;
            _facePosition = 'Hadapkan muka ke samping kiri';
          });
        }
        break;
      case 3: // Step 3: Left Face
        if (_facePosition == 'Hadapkan muka ke samping kiri') {
          setState(() {
            _currentStep = 4;
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            left = true;
            _capturedImages['left'] = capturedImage;
            _facePosition = 'Hadapkan muka ke atas';
          });
        }
        break;
      case 4: // Step 4: Top Face
        if (_facePosition == 'Hadapkan muka ke atas') {
          setState(() {
            _currentStep = 5;
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            top = true;
            _capturedImages['up'] = capturedImage;
            _facePosition = 'Hadapkan muka ke bawah';
          });
        }
        break;
      case 5: // Step 5: Bottom Face
        if (_facePosition == 'Hadapkan muka ke bawah') {
          setState(() {
            Uint8List capturedImage = convertCameraImageToUint8List(image);
            bot = true;
            _capturedImages['down'] = capturedImage;
          });
          _facePosition = 'Mohon menunggu sebentar';
          _navigateToNextPage();
        }
        break;
      default:
        break;
    }
  }

  void _navigateToNextPage() async {
    if (front && right && left && top && bot) {
      const double angle = 3 * 3.141592653589793 / 2; // 270 degrees
      Map<String, Uint8List> rotatedImages =
          await rotateImages(_capturedImages, angle);
      _controller!.stopImageStream();
      registerBloc.add(RegisterAttempt(capturedImages: rotatedImages));
    } else {
      log('Belum semua');
    }
  }

  Future<Map<String, Uint8List>> rotateImages(
      Map<String, Uint8List> images, double angle) async {
    Map<String, Uint8List> rotatedImages = {};

    for (var entry in images.entries) {
      Uint8List rotatedImage = await _rotateImage(entry.value, angle);
      rotatedImages[entry.key] = rotatedImage;
    }

    return rotatedImages;
  }

  Future<Uint8List> _rotateImage(Uint8List imageData, double angle) async {
    final codec = await ui.instantiateImageCodec(imageData);
    final frame = await codec.getNextFrame();
    final ui.Image image = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Set the rotation
    final double centerX = image.width / 2;
    final double centerY = image.height / 2;
    canvas.translate(centerX, centerY);
    canvas.rotate(angle);
    canvas.translate(-centerX, -centerY);

    // Draw the image onto the canvas
    final paint = Paint();
    canvas.drawImage(image, Offset.zero, paint);

    final picture = recorder.endRecording();
    final rotatedImage = await picture.toImage(image.width, image.height);
    final byteData =
        await rotatedImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
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
        builder: (buildContext) {
          return StatefulBuilder(builder: (buildContext, setStates) {
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
                  Text('Registrasi muka sukses',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.6,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Anda sudah bisa melakukan absensi melalui scan muka.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.4,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () async {
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
                      child: Center(
                          child: Text('Absen Masuk',
                              style: TextStyle(
                                  fontSize:
                                      GeneralUtil.fontSize(context) * 0.45,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  Future<void> _expDialog(BuildContext context) async {
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
                const Center(
                  child: Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.yellow,
                    weight: 80,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sesi Anda Telah Berakhir',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    SharedPrefUtil.clearSharedPref();
                    Navigator.pushNamedAndRemoveUntil(context,
                        StringRouterUtil.loginScreenRoute, (route) => false);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.56,
                    height: 41,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primaryColor)),
                    child: const Center(
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 15,
                                color: primaryColor,
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
                height: MediaQuery.of(context).size.height * 0.2,
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
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            BlocListener(
                                bloc: registerBloc,
                                listener: (_, RegisterState state) async {
                                  if (state is RegisterLoading) {
                                    setState(() {
                                      isError = false;
                                    });
                                  }
                                  if (state is RegisterLoaded) {
                                    SharedPrefUtil.saveSharedString(
                                        'userstatus', 'ACTIVE');
                                    _successDialog(context);
                                  }
                                  if (state is RegisterError) {
                                    setState(() {
                                      isError = true;
                                    });
                                    GeneralUtil().showSnackBarError(
                                        context, state.error!);
                                  }
                                  if (state is RegisterException) {
                                    setState(() {
                                      isError = true;
                                    });
                                    _expDialog(context);
                                  }
                                },
                                child: BlocBuilder(
                                    bloc: registerBloc,
                                    builder: (_, RegisterState state) {
                                      return isError
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 32.0, right: 32.0),
                                              child: InkWell(
                                                onTap: () async {
                                                  const double angle = 3 *
                                                      3.141592653589793 /
                                                      2; // 270 degrees
                                                  Map<String, Uint8List>
                                                      rotatedImages =
                                                      await rotateImages(
                                                          _capturedImages,
                                                          angle);

                                                  registerBloc.add(
                                                      RegisterAttempt(
                                                          capturedImages:
                                                              rotatedImages));
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Center(
                                                      child: Text('Ulangi',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))),
                                                ),
                                              ),
                                            )
                                          : Text(_facePosition,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500));
                                    })),
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
                    : Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Stack(
                          children: [
                            Center(child: CameraPreview(_controller!)),
                            CustomPaint(
                              painter: OverlayPainter(
                                  screenHeight:
                                      MediaQuery.of(context).size.height,
                                  screenWidth:
                                      MediaQuery.of(context).size.width),
                            ),
                          ],
                        ),
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
                                  isLoadingData
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Colors.grey.shade300,
                                                ),
                                                width: 80,
                                                height: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: Colors.grey.shade300,
                                                ),
                                                width: 80,
                                                height: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Hi, $name',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(height: 2),
                                            Text(role,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF797979),
                                                    fontWeight:
                                                        FontWeight.w400))
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
                              left: 24, right: 24, top: 24, bottom: 8),
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4.0, right: 16),
                                child: Column(
                                  children: [
                                    Text('Registrasi Muka',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.6,
                                            color: const Color(0xFF202020),
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 245,
                                      child: Text(
                                          'Mohon ikuti perintah dibawah untuk menyelesaikan registrasi muka',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.35,
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
