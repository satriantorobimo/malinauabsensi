import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  List<String> filter = ['Semua', 'Izin', 'Aktifitas', 'Absensi'];
  final List<String> items = [
    'Setting',
    'Logout',
  ];
  bool laporan = true;
  int selectedFilter = 0;
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
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.23,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              laporan ? 'Laporan' : 'Laporan Tunjangan Kinerja',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                laporan = !laporan;
                              });
                            },
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                      laporan
                                          ? 'Laporan Tunjangan Kinerja'
                                          : 'laporan',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: 45,
                                padding: const EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: const Color(0xFF9E9E9E)
                                            .withOpacity(0.6))),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('mm/dd/yy',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFBBBBBB),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              Container(
                                width: 45,
                                height: 45,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: const Center(
                                  child: Text('s/d',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.38,
                                height: 45,
                                padding: const EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: const Color(0xFF9E9E9E)
                                            .withOpacity(0.6))),
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('mm/dd/yy',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFBBBBBB),
                                          fontWeight: FontWeight.w500)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                  child: Text('Cari',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.045,
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(width: 8);
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: filter.length,
                          padding: const EdgeInsets.only(right: 8),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedFilter = index;
                                });
                              },
                              child: Container(
                                width: 75,
                                decoration: BoxDecoration(
                                  color: selectedFilter == index
                                      ? primaryColor
                                      : const Color(0xFFEEEDF7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(filter[index],
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: selectedFilter == index
                                              ? Colors.white
                                              : const Color(0xFF797979),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: SvgPicture.asset(
                        'assets/icons/filter.svg',
                        colorFilter: const ColorFilter.mode(
                            primaryColor, BlendMode.srcIn),
                        height: 32,
                        width: 32,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 16, bottom: 40, right: 16),
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(-6, 4), // Shadow position
                          ),
                        ],
                        border: Border.all(
                            color: const Color(0xFF9E9E9E).withOpacity(0.1))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Laporan Izin',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/pdf.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                  'assets/icons/sort-ascending.svg',
                                  height: 24,
                                  width: 24,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.08,
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: const Text('#',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF797979),
                                      fontWeight: FontWeight.w400)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: const Text('Name',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF797979),
                                      fontWeight: FontWeight.w400)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: const Text('Date',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF797979),
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: const Color(0xFFEAF1F8),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                            child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Text('0${index + 1}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF797979),
                                          fontWeight: FontWeight.w400)),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: const Text('I  Putu John Doe',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF797979),
                                          fontWeight: FontWeight.w400)),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: const Text('20/01/2024',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF797979),
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Container(
                                width: double.infinity,
                                height: 1,
                                color: const Color(0xFFEAF1F8),
                              ),
                            );
                          },
                          itemCount: 5,
                          shrinkWrap: true,
                        )),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text('View more',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    )),
                const SizedBox(height: 24),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(-6, 4), // Shadow position
                          ),
                        ],
                        border: Border.all(
                            color: const Color(0xFF9E9E9E).withOpacity(0.1))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Laporan Aktifitas',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/pdf.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 8),
                                SvgPicture.asset(
                                  'assets/icons/sort-ascending.svg',
                                  height: 24,
                                  width: 24,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 24),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(-6, 4), // Shadow position
                          ),
                        ],
                        border: Border.all(
                            color: const Color(0xFF9E9E9E).withOpacity(0.1))),
                    child: const Column()),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
