import 'dart:developer';
import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:permission_handler/permission_handler.dart';

class AbsesnsiScreen extends StatefulWidget {
  const AbsesnsiScreen({super.key});

  @override
  State<AbsesnsiScreen> createState() => _AbsesnsiScreenState();
}

class _AbsesnsiScreenState extends State<AbsesnsiScreen> {
  final List<String> items = [
    'Setting',
    'Logout',
  ];
  bool isInternet = false;

  String date = '';
  String time = '';

  Future<void> _fingerPrintDialog(BuildContext context) async {
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
                const Text('2 Nov 2023',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF797979),
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 16),
                const Text(
                    'Mohon tempatkan jari anda di scanner sidik jari untuk absen masuk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/finger.svg',
                    height: 123,
                    width: 123,
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primaryColor)),
                    child: const Center(
                        child: Text('Balik',
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

  Future<bool?> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }

    return null;
  }

  Future<String?> checkDate() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE,d MMMM yyyy').format(now);

    return formattedDate;
  }

  Future<String?> checkTime() async {
    DateTime now = DateTime.now();

    String formattedTime = DateFormat('hh:mm a').format(now);

    return formattedTime;
  }

  @override
  void initState() {
    checkInternet().then((value) {
      setState(() {
        isInternet = value!;
      });
    });
    checkDate().then(
      (value) {
        setState(() {
          date = value!;
        });
      },
    );
    checkTime().then(
      (value) {
        setState(() {
          time = value!;
        });
      },
    );
    super.initState();
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
                    bottom: BorderSide(
                        width: 1, color: Colors.grey.withOpacity(0.1)),
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
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
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
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                        Text(date,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF797979),
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Text(time,
                            style: const TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 24),
                        const SizedBox(
                          width: 245,
                          child: Text('Pilih salah satu cara untuk absen masuk',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () async {
                            bool isCameraGranted =
                                await Permission.camera.request().isGranted;

                            if (!isCameraGranted) {
                              isCameraGranted =
                                  await Permission.camera.request() ==
                                      PermissionStatus.granted;
                            }
                            WidgetsFlutterBinding.ensureInitialized();
                            final cameras = await availableCameras();
                            final firstCamera = cameras.first;
                            if (context.mounted) {
                              // Navigator.pushNamed(context,
                              //     StringRouterUtil.faceScanScreenRoute);
                              Navigator.pushNamed(context,
                                  StringRouterUtil.faceRegisterScanScreenRoute,
                                  arguments: firstCamera);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            width: 245,
                            height: 65,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [primaryColor, Color(0xFF1F1E2C)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 3,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFFC2C2C2))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: SvgPicture.asset(
                                    'assets/icons/face-scan.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                    height: 41,
                                    width: 40,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Face Scan',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // InkWell(
                        //   onTap: () {
                        //     _fingerPrintDialog(context);
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(12.0),
                        //     width: 245,
                        //     height: 65,
                        //     decoration: BoxDecoration(
                        //         gradient: const LinearGradient(
                        //           colors: [primaryColor, Color(0xFF1F1E2C)],
                        //           begin: Alignment.topCenter,
                        //           end: Alignment.bottomCenter,
                        //         ),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.grey.withOpacity(0.1),
                        //             blurRadius: 3,
                        //             offset:
                        //                 const Offset(-6, 4), // Shadow position
                        //           ),
                        //         ],
                        //         borderRadius: BorderRadius.circular(8),
                        //         border:
                        //             Border.all(color: const Color(0xFFC2C2C2))),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         SizedBox(
                        //           width: 50,
                        //           child: SvgPicture.asset(
                        //             'assets/icons/finger-print.svg',
                        //             colorFilter: const ColorFilter.mode(
                        //                 Colors.white, BlendMode.srcIn),
                        //             height: 41,
                        //             width: 40,
                        //           ),
                        //         ),
                        //         const SizedBox(width: 8),
                        //         const Text('Fingerprint',
                        //             style: TextStyle(
                        //                 fontSize: 20,
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.w500)),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 24),
                        isInternet
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      StringRouterUtil.qrScanScreenRoute);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: 245,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          primaryColor,
                                          Color(0xFF1F1E2C)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          blurRadius: 3,
                                          offset: const Offset(
                                              -6, 4), // Shadow position
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFFC2C2C2))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/qr-scan.svg',
                                        colorFilter: const ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                        height: 41,
                                        width: 40,
                                      ),
                                      const SizedBox(width: 24),
                                      const Text('QR-Code',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/timer.svg',
                        colorFilter: const ColorFilter.mode(
                            primaryColor, BlendMode.srcIn),
                        height: 40,
                        width: 40,
                      ),
                      const Text('--:--',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const Text('Absen Datang',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/timer.svg',
                        colorFilter: const ColorFilter.mode(
                            primaryColor, BlendMode.srcIn),
                        height: 40,
                        width: 40,
                      ),
                      const Text('--:--',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const Text('Absen Pulang',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/timer.svg',
                        colorFilter: const ColorFilter.mode(
                            primaryColor, BlendMode.srcIn),
                        height: 40,
                        width: 40,
                      ),
                      const Text('--:--',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const Text('Jam Kerja',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
