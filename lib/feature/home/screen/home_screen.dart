import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

class Menu {
  int id;
  String name;

  Menu(this.id, this.name);

  static List<Menu> getCompanies() {
    return <Menu>[
      Menu(1, 'Setting'),
      Menu(2, 'Logout'),
    ];
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _keteranganController = TextEditingController();
  List<String> filter = [
    'Semua',
    '7 hari terakhir',
    'Bulan ini',
    '3 Bulan Terakhir'
  ];

  List<String> date = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat'
  ];
  final List<String> items = [
    'Setting',
    'Logout',
  ];

  int selectedFilter = 0;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            insetPadding: const EdgeInsets.all(24.0),
            contentPadding: const EdgeInsets.all(16.0),
            titlePadding:
                const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            actionsPadding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('2 Nov 2023',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                    Text('Isi Keterangan Aktifitas',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                )
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side:
                        const BorderSide(width: 1.0, color: Color(0xFF9E9E9E))),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _keteranganController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: 'Tulis keterangan aktifitas anda disini',
                      isDense: true,
                      contentPadding: const EdgeInsets.all(16),
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      )),
                ),
              ),
            ),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                      child: Text('Simpan',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600))),
                ),
              ),
            ],
          );
        });
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
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.21,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Daftar Absensi',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context,
                                  StringRouterUtil.absenKeluarScreenRoute);
                            },
                            child: Container(
                              width: 115,
                              height: 45,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                  child: Text('Absen Keluar',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 110,
                            height: 95,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 3,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                                border: Border.all(
                                    color: const Color(0xFFC2C2C2)
                                        .withOpacity(0.2))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: greenColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('Tepat waktu',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF797979),
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 12),
                                const Text('20 hari',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 95,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 3,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                                border: Border.all(
                                    color: const Color(0xFFC2C2C2)
                                        .withOpacity(0.2))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: redColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('Telat',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF797979),
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 12),
                                const Text('2 hari',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 95,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 3,
                                    offset:
                                        const Offset(-6, 4), // Shadow position
                                  ),
                                ],
                                border: Border.all(
                                    color: const Color(0xFFC2C2C2)
                                        .withOpacity(0.2))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 50,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('Jam kerja',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF797979),
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 12),
                                const Text('20 jam',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                              ],
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
                                decoration: BoxDecoration(
                                  color: selectedFilter == index
                                      ? primaryColor
                                      : const Color(0xFF9E9E9E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(filter[index],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
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
              child: ListView.separated(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 40),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, StringRouterUtil.absenDetailScreenRoute);
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                            border: Border.all(
                                color:
                                    const Color(0xFFC2C2C2).withOpacity(0.1))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color:
                                        index % 2 == 0 ? greenColor : redColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Nov',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF797979),
                                            fontWeight: FontWeight.w400)),
                                    Text('${index + 1}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                const SizedBox(width: 18),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(index == 0 ? 'Hari ini' : date[index],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        index % 2 == 0
                                            ? 'Tepat waktu'
                                            : 'Telat',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: index % 2 == 0
                                                ? greenColor
                                                : redColor,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                      index == 0
                                          ? '08:00 - --:--'
                                          : '08:00 - 18:00',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 18),
                                  InkWell(
                                    onTap: () {
                                      _displayTextInputDialog(context);
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/edit.svg',
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                          height: 16,
                                          width: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemCount: date.length),
            )
          ],
        ),
      ),
    );
  }
}
