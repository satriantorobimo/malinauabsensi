import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_out_request_model.dart'
    as out;
import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:geolocator/geolocator.dart';

import '../../absensi/bloc/in_bloc/bloc.dart';
import '../../absensi/bloc/out_bloc/bloc.dart';

class FaceScanV2Screen extends StatefulWidget {
  final ArgumentAbsenModel argumentAbsenModel;

  const FaceScanV2Screen({super.key, required this.argumentAbsenModel});

  @override
  State<FaceScanV2Screen> createState() => _FaceScanV2ScreenState();
}

class _FaceScanV2ScreenState extends State<FaceScanV2Screen> {
  CameraController? _controller;
  bool isLoading = false;
  bool isScan = false;
  WebSocketChannel? channel;
  String feedback = "";
  double lat = 0.0;
  double long = 0.0;
  bool isPresent = false;
  bool isWebcamReady = false;
  bool _isCapturing = false;
  InBloc inBloc = InBloc(absenRepo: AbsenRepo());
  OutBloc outBloc = OutBloc(absenRepo: AbsenRepo());
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

    determinePosition().then(
      (value) {
        setState(() {
          lat = value.latitude;
          long = value.longitude;
        });
        _initializeCamera();
      },
    );
  }

  @override
  void dispose() {
    channel?.sink.close();
    _controller?.dispose();
    super.dispose();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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
    );
    await _controller!.initialize();

    if (mounted) {
      setState(() {
        isWebcamReady = true;
      });
    }
    setupWebSocket();
  }

  void setupWebSocket() async {
    log("Connecting to WebSocket...");
    try {
      final String? userid = await SharedPrefUtil.getSharedString('userid');
      channel = WebSocketChannel.connect(Uri.parse(
          "wss://api-dev.anydev.online/wsv1/user/$userid/recognize_face"));

      // Log successful connection attempt
      log("WebSocket connection opened.");
      // send initial image

      if (isWebcamReady) {
        captureAndSendFrame();
      }

      channel!.stream.listen((event) async {
        log("Message received from WebSocket: $event");
        final serverMessage = parseMessage(event);
        if (serverMessage != null) {
          handleMessage(serverMessage);
        } else {
          setState(() {
            feedback = "Received an unexpected response from the server.";
          });
        }
      }, onDone: () {
        log("WebSocket connection closed by the server.");
      }, onError: (error) {
        log("WebSocket connection error: $error");
      });
    } catch (e) {
      log("Error connecting to WebSocket: $e");
    }
  }

  void handleMessage(Map<String, dynamic> message) async {
    setState(() {
      feedback = message['message'] ?? "";
    });

    log("Handling message: ${jsonEncode(message)}");

    if (message['success'] == true &&
        message['message'] == "Pengguna terkonfirmasi") {
      setState(() {
        feedback = message['message'];
        isPresent = true;
      });

      _controller?.pausePreview();
      channel?.sink.close(1000);

      Future.delayed(const Duration(milliseconds: 700), () async {
        final String? userid = await SharedPrefUtil.getSharedString('userid');
        final Map mapData = {};
        mapData['user_id'] = userid;
        mapData['time_stamp'] = DateTime.now().millisecondsSinceEpoch;
        final json = jsonEncode(mapData);

        String cvrt = base64Encode(utf8.encode(json));
        if (widget.argumentAbsenModel.isIn) {
          inBloc.add(InAttempt(
              absenRequestModel: AbsenRequestModel(
                  qrContent: cvrt,
                  requestType: 'in',
                  location: Location(lat: lat, long: long))));
        } else {
          outBloc.add(OutAttempt(
              absenOutRequestModel: out.AbsenOutRequestModel(
                  qrContent: cvrt,
                  requestType: 'out',
                  location: out.Location(lat: lat, long: long))));
        }
      });
    } else {
      setState(() {
        feedback = message['message'];
      });
      captureAndSendFrame();
    }
  }

  void captureAndSendFrame() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        !isWebcamReady ||
        _isCapturing) {
      log("Camera is not ready, not initialized, or capture is in progress.");
      return;
    }

    try {
      _isCapturing = true; // Mark capture as in progress
      final picture = await _controller?.takePicture();
      if (picture != null && channel != null) {
        log("Sending frame to WebSocket...");
        channel!.sink.add(await picture.readAsBytes());
      }
    } catch (e) {
      log("Error capturing frame: $e");
    } finally {
      _isCapturing = false; // Mark capture as complete
    }
  }

  Map<String, dynamic>? parseMessage(String event) {
    try {
      return Map<String, dynamic>.from(jsonDecode(event));
    } catch (_) {
      log("Failed to parse WebSocket message.");
      return null;
    }
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
            bottomNavigationBar: SizedBox(
                height: MediaQuery.of(context).size.height * 0.22,
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
                          : Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              decoration: BoxDecoration(
                                color: isPresent
                                    ? Colors.greenAccent.withOpacity(0.8)
                                    : Colors.redAccent.withOpacity(0.8),
                              ),
                              child: Text(
                                feedback,
                                textAlign: TextAlign
                                    .center, // Center-align text horizontally
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      GeneralUtil.fontSize(context) * 0.35,
                                ),
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 32),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Text('Cara penggunaan Face ID Scan',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.4,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                                '1. Posisikan kamera ke muka anda.\n2. Tekan tombol “Scan”\n3. dan selamat beraktifitas',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.35,
                                    color: const Color(0xFF000000),
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
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  children: [
                                    Text('Face ID Scan',
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
                                          widget.argumentAbsenModel.isIn
                                              ? 'Mohon scan muka anda untuk absen masuk'
                                              : 'Mohon scan muka anda untuk absen pulang',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.4,
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
    final radius = screenWidth * 0.34;
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
