import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/components/overlay_camera.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
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
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Container(
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
                  bottom:
                      BorderSide(width: 1, color: Colors.grey.withOpacity(0.1)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            width: 160,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
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
                            padding: const EdgeInsets.only(left: 16, right: 16),
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
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: primaryColor,
                  size: 24,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Column(
                    children: [
                      Text('Face ID Scan',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF202020),
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 245,
                        child: Text('Mohon scan muka anda untuk absen masuk',
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
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Container(
              width: 351,
              height: 261,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    width: 351,
                    height: 261,
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final aspectRatio =
                                  _controller!.value.aspectRatio;
                              final containerRatio =
                                  constraints.maxWidth / constraints.maxHeight;

                              double width, height;
                              if (containerRatio > aspectRatio) {
                                width = constraints.maxWidth;
                                height = width / aspectRatio;
                              } else {
                                height = constraints.maxHeight;
                                width = height * aspectRatio;
                              }

                              return Center(
                                child: ClipRect(
                                  child: SizedBox(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width: width,
                                        height: height,
                                        child: Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(3.14159),
                                          child: CameraPreview(_controller!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  FaceOverlay()
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
            child: InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Text('Ambil Foto',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
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
                      '1. Posisikan kamera ke muka anda.\n2. Tekan tombol “Ambil Foto”\n3. dan selamat beraktifitas',
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
      ),
    ));
  }
}
