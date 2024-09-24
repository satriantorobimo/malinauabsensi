import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

class SuccessScanScreen extends StatefulWidget {
  const SuccessScanScreen({super.key});

  @override
  State<SuccessScanScreen> createState() => _SuccessScanScreenState();
}

class _SuccessScanScreenState extends State<SuccessScanScreen> {
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
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imgs/success.png',
                    width: 95,
                    height: 95,
                  ),
                  const SizedBox(height: 16),
                  const Text('Verifikasi Sukses',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                        'Anda berhasil absen masuk. Selamat mengerjakan aktifitas anda hari ini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, StringRouterUtil.tabScreenRoute, (route) => false);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Text('Kembali',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
