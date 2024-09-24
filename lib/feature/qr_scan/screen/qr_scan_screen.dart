import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                      const Text('Masa berlaku',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF202020),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 245,
                        child: Text('00:$_start',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 28,
                                color: Color(0xFFFF4242),
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Container()
              ],
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(top: 32.0, left: 32, right: 32),
              child: SizedBox(
                height: 343,
                width: 343,
                child: Icon(
                  Icons.qr_code,
                  size: 343,
                ),
              )),
          const Padding(
            padding: EdgeInsets.only(top: 32.0, left: 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cara penggunaan Face ID Scan',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      '1. Posisikan QR-code ke alat scan\n2. Tunggu sampai alat scan mengvalidasi QR-code\n3. dan selamat beraktifitas',
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
