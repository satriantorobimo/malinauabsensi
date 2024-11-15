import 'dart:convert';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  bool isPresent = false;
  bool isWebcamReady = false;
  bool _isCapturing = false;
  InBloc inBloc = InBloc(absenRepo: AbsenRepo());
  OutBloc outBloc = OutBloc(absenRepo: AbsenRepo());

  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  @override
  void dispose() {
    channel?.sink.close();
    _controller?.dispose();
    super.dispose();
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
              absenRequestModel:
                  AbsenRequestModel(qrContent: cvrt, requestType: 'in')));
        } else {
          outBloc.add(OutAttempt(
              absenRequestModel:
                  AbsenRequestModel(qrContent: cvrt, requestType: 'out')));
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
                                GeneralUtil()
                                    .showSnackBarError(context, state.error!);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              if (state is InException) {
                                GeneralUtil()
                                    .showSnackBarError(context, state.error);
                                setState(() {
                                  isLoading = false;
                                });
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
                                GeneralUtil()
                                    .showSnackBarError(context, state.error!);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                              if (state is OutException) {
                                GeneralUtil()
                                    .showSnackBarError(context, state.error);
                                setState(() {
                                  isLoading = false;
                                });
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
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
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
