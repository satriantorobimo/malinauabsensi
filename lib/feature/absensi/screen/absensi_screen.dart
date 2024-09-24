import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:malinau_absensi/util/string_util.dart';
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
                  const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: [
                        const Text('Monday, 8 November 2022',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF797979),
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Text('08:00',
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                            Text('pm',
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
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
                            if (context.mounted) {
                              Navigator.pushNamed(context,
                                  StringRouterUtil.faceScanScreenRoute);
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
                        InkWell(
                          onTap: () {},
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
                                    'assets/icons/finger-print.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                    height: 41,
                                    width: 40,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Fingerprint',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        InkWell(
                          onTap: () {},
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
