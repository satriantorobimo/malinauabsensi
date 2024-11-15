import 'dart:math' as mth;

import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'dart:developer';

class RegisterFaceScanV2 extends StatefulWidget {
  final CameraDescription camera;

  const RegisterFaceScanV2({super.key, required this.camera});

  @override
  State<RegisterFaceScanV2> createState() => _RegisterFaceScanV2State();
}

class _RegisterFaceScanV2State extends State<RegisterFaceScanV2>
    with TickerProviderStateMixin {
  CameraController? _controller;
  final List<AnimationController> _controllers = [];
  bool noFace = false;
  String feedback = "";
  WebSocketChannel? channel;
  bool isCamReady = false;

  // Initialize each direction's active state and animation controller
  List<bool> activeDirections = [
    false,
    false,
    false,
    false
  ]; // [Up, Right, Down, Left]

  Map<String, bool> acceptedAngle = {
    "up": false,
    "left": false,
    "right": false,
    "down": false,
    "straight": false,
  };

  final Map<String, int> _controllersIndex = {
    "up": 0,
    "right": 1,
    "down": 2,
    "left": 3,
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();

    // Create animation controllers for each direction
    for (int i = 0; i < 4; i++) {
      _controllers.add(AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
      ));
    }
  }

  void setupWebSocket() async {
    log("Connecting to WebSocket...");
    try {
      final String? userid = await SharedPrefUtil.getSharedString('userid');
      channel = WebSocketChannel.connect(Uri.parse(
          "wss://api-dev.anydev.online/wsv1/user/$userid/register_face"));

      // Log successful connection attempt
      log("WebSocket connection opened.");
      // send initial image
      captureAndSendFrame();
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

    if (message['message']?.contains('Error:') ?? false) {
      noFace = true;
      captureAndSendFrame();
    } else if (message['currentAngle'] != null) {
      if (message['currentAngle'] != "") {
        toggleSegmentStyle(message['currentAngle']);
      }
      captureAndSendFrame();
    } else if (message['success'] == true) {
      setState(() {
        feedback = "All angles captured successfully!";
      });
      _controller?.pausePreview();
      channel?.sink.close(1000);
      if (mounted) {
        _successDialog(context);
      }
    }
  }

  void captureAndSendFrame() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        !isCamReady) {
      log("Camera is not ready or not initialized");
      return;
    }

    final picture = await _controller?.takePicture();
    if (picture != null && channel != null) {
      final image = await picture.readAsBytes();
      log("Sending frame to WebSocket...");
      channel!.sink.add(image);
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
      );
      await _controller!.initialize();
      setState(() {
        isCamReady = true;
      });
      setupWebSocket();
      if (mounted) {
        setState(() {}); // Rebuilds to show the camera preview
      }
    }
  }

  void toggleSegmentStyle(String side) {
    log("Toggling segment style for side: $side");
    setState(() {
      acceptedAngle[side] = !acceptedAngle[side]!;
    });

    if (side != "straight") {
      final index = _controllersIndex[side] ?? 0;

      setState(() {
        activeDirections[index] = !activeDirections[index];
      });

      if (acceptedAngle[side] == true) {
        _controllers[index]
            .forward(from: 0); // Restart the specific direction's animation
      } else {
        _controllers[index].reset();
      }
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
  void dispose() {
    log("Disposing resources...");
    for (var controller in _controllers) {
      controller.dispose();
    }
    channel?.sink.close();
    _controller?.dispose();
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
            body: Stack(
              children: [
                _controller == null || !_controller!.value.isInitialized
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                for (int i = 0; i < 4; i++)
                                  AnimatedBuilder(
                                    animation: _controllers[i],
                                    builder: (context, child) {
                                      return CustomPaint(
                                        painter: FaceIdBorderPainter(
                                          progress: _controllers[i].value,
                                          activeDirectionIndex: i,
                                          isActive: activeDirections[i],
                                        ),
                                        child: const SizedBox(
                                            width: 260,
                                            height: 260), // Outer circle
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          // Camera Preview or Placeholder
                          Center(
                            child: ClipOval(
                              child: SizedBox(
                                width: 250, // Larger camera preview size
                                height: 250,
                                child: _controller != null &&
                                        _controller!.value.isInitialized
                                    ? CameraPreview(_controller!)
                                    : Container(
                                        color: Colors
                                            .black), // Placeholder until camera initializes
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 30,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    if (feedback.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        decoration: BoxDecoration(
                                          color:
                                              Colors.redAccent.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          feedback,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                  ]))
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

class FaceIdBorderPainter extends CustomPainter {
  final double progress;
  final int activeDirectionIndex;
  final bool isActive;

  FaceIdBorderPainter({
    required this.progress,
    required this.activeDirectionIndex,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width / 2) + 5;
    const segmentCount = 40;
    const defaultSegmentLength = 20.0;
    final activeSegmentLength = defaultSegmentLength + progress * 10;

    Paint defaultPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Paint activePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    double angleStep = (2 * mth.pi) / segmentCount;

    for (int i = 0; i < segmentCount; i++) {
      double angle = i * angleStep;
      double dx = radius * mth.cos(angle);
      double dy = radius * mth.sin(angle);

      Offset start = Offset(size.width / 2 + dx, size.height / 2 + dy);
      Offset end = Offset(
        size.width / 2 +
            (radius +
                    (isSegmentInActiveDirection(i)
                        ? activeSegmentLength
                        : defaultSegmentLength)) *
                mth.cos(angle),
        size.height / 2 +
            (radius +
                    (isSegmentInActiveDirection(i)
                        ? activeSegmentLength
                        : defaultSegmentLength)) *
                mth.sin(angle),
      );

      // Log the segment's state
      // developer.log(
      //   'Segment $i: '
      //   'Angle ${angle.toStringAsFixed(2)}, '
      //   'Active Direction: $activeDirectionIndex, '
      //   'Is Active: ${isSegmentInActiveDirection(i)}, '
      //   'Using Color: ${isSegmentInActiveDirection(i) ? 'Green' : 'Grey'}',
      // );

      // Ensure active segments turn completely green
      canvas.drawLine(
        start,
        end,
        isSegmentInActiveDirection(i) ? activePaint : defaultPaint,
      );
    }
  }

  bool isSegmentInActiveDirection(int index) {
    // Map direction to specific segments: Up, Right, Down, Left
    if (!isActive) return false;
    switch (activeDirectionIndex) {
      case 0: // Up
        return index >= 25 && index < 35;
      case 1: // Right
        return index >= 35 || index < 5;
      case 2: // Down
        return index >= 5 && index < 15;
      case 3: // Left
        return index >= 15 && index < 25;
      default:
        return false;
    }
  }

  @override
  bool shouldRepaint(covariant FaceIdBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeDirectionIndex != activeDirectionIndex ||
        oldDelegate.isActive != isActive;
  }
}
