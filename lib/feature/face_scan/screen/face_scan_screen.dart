import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/bloc/in_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_out_request_model.dart'
    as out;
import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

import '../../absensi/bloc/out_bloc/bloc.dart';

class FaceScanScreen extends StatefulWidget {
  final ArgumentAbsenModel argumentAbsenModel;

  const FaceScanScreen({super.key, required this.argumentAbsenModel});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  CameraController? _controller;
  InBloc inBloc = InBloc(absenRepo: AbsenRepo());
  OutBloc outBloc = OutBloc(absenRepo: AbsenRepo());
  bool isLoading = false;
  bool isScan = false;

  bool _isDetecting = false;
  String _facePosition = 'No face detected';
  final FaceDetector _faceDetector = GoogleVision.instance.faceDetector(
    const FaceDetectorOptions(
      mode: FaceDetectorMode.accurate,
      enableLandmarks: true,
    ),
  );
  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close;
    super.dispose();
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

    if (mounted) {
      setState(() {});
    }
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
        setState(() {
          _facePosition = 'Mohon menunggu sebentar';
        });
        log("Process Image");
        setState(() {
          _isDetecting = true;
        });
        final String? userid = await SharedPrefUtil.getSharedString('userid');
        if (widget.argumentAbsenModel.isIn) {
          final Map mapData = {};
          mapData['user_id'] = userid;
          mapData['time_stamp'] = DateTime.now().millisecondsSinceEpoch;
          final json = jsonEncode(mapData);

          String cvrt = base64Encode(utf8.encode(json));
          inBloc.add(InAttempt(
              absenRequestModel: AbsenRequestModel(
                  qrContent: cvrt,
                  requestType: 'in',
                  location: Location(lat: 0.0, long: 0.0))));
        } else {
          final Map mapData = {};
          mapData['user_id'] = userid;
          mapData['time_stamp'] = DateTime.now().millisecondsSinceEpoch;
          final json = jsonEncode(mapData);

          String cvrt = base64Encode(utf8.encode(json));
          outBloc.add(OutAttempt(
              absenOutRequestModel: out.AbsenOutRequestModel(
                  qrContent: cvrt,
                  requestType: 'out',
                  location: out.Location(lat: 0.0, long: 0.0))));
        }
      } else {
        setState(() {
          _facePosition = 'No face detected';
        });
      }
    } catch (e) {
      log('Error detecting face: $e');
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

  Future<void> scanFace() async {
    _controller!.startImageStream((CameraImage image) {
      if (!_isDetecting) {
        _detectFaces(image);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  children: [
                    MultiBlocListener(
                      listeners: [
                        BlocListener(
                            bloc: inBloc,
                            listener: (_, InState state) async {
                              if (state is InLoading) {
                                setState(() {
                                  isLoading = true;
                                });
                              }
                              if (state is InLoaded) {
                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    StringRouterUtil.successScanScreenRoute,
                                    arguments: true,
                                    (route) => false);
                              }
                              if (state is InError) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (state.error! == 'Token is expired') {
                                  _expDialog(context);
                                } else {
                                  GeneralUtil()
                                      .showSnackBarError(context, state.error!);
                                }
                              }
                              if (state is InException) {
                                setState(() {
                                  isLoading = false;
                                });
                                GeneralUtil()
                                    .showSnackBarError(context, state.error);
                              }
                            }),
                        BlocListener(
                            bloc: outBloc,
                            listener: (_, OutState state) async {
                              if (state is OutLoading) {
                                setState(() {
                                  isLoading = true;
                                });
                              }
                              if (state is OutLoaded) {
                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    StringRouterUtil.successScanScreenRoute,
                                    arguments: false,
                                    (route) => false);
                              }
                              if (state is OutError) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (state.error! == 'Token is expired') {
                                  _expDialog(context);
                                } else {
                                  GeneralUtil()
                                      .showSnackBarError(context, state.error!);
                                }
                              }
                              if (state is OutException) {
                                setState(() {
                                  isLoading = false;
                                });
                                GeneralUtil()
                                    .showSnackBarError(context, state.error);
                              }
                            }),
                      ],
                      child: isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : isScan
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 32.0, left: 32.0, right: 32.0),
                                  child: Text(_facePosition,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 32.0, left: 32.0, right: 32.0),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        isScan = true;
                                      });
                                      scanFace();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                          child: Text('Scan',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ),
                                  ),
                                ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 32.0, left: 32),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text('Cara penggunaan Face ID Scan',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                                '1. Posisikan kamera ke muka anda.\n2. Tekan tombol “Scan”\n3. dan selamat beraktifitas',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    )
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<String?>(
                                        future: SharedPrefUtil.getSharedString(
                                            'nama'), // Key for retrieval
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                "Error: ${snapshot.error}");
                                          } else {
                                            final username = snapshot.data ??
                                                "No name found";
                                            return Text('Hi, $username',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500));
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 2),
                                      FutureBuilder<String?>(
                                        future: SharedPrefUtil.getSharedString(
                                            'role'), // Key for retrieval
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Container();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                "Error: ${snapshot.error}");
                                          } else {
                                            final role = snapshot.data ??
                                                "No role found";
                                            return Text(role,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF797979),
                                                    fontWeight:
                                                        FontWeight.w400));
                                          }
                                        },
                                      ),
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
                                        } else if (a.text == 'Setting') {
                                          Navigator.pushNamed(
                                              context,
                                              StringRouterUtil
                                                  .settingScreenRoute);
                                        } else if (a.text == 'Profile') {
                                          Navigator.pushNamed(
                                              context,
                                              StringRouterUtil
                                                  .profileScreenRoute);
                                        } else if (a.text == 'Ubah Password') {
                                          Navigator.pushNamed(
                                              context,
                                              StringRouterUtil
                                                  .ubahPasswordScreenRoute);
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
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  children: [
                                    const Text('Face ID Scan',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xFF202020),
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: 245,
                                      child: Text(
                                          widget.argumentAbsenModel.isIn
                                              ? 'Mohon scan muka anda untuk absen masuk'
                                              : 'Mohon scan muka anda untuk absen pulang',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
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
