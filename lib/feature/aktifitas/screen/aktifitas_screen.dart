import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AktifitasScreen extends StatefulWidget {
  const AktifitasScreen({super.key});

  @override
  State<AktifitasScreen> createState() => _AktifitasScreenState();
}

class _AktifitasScreenState extends State<AktifitasScreen> {
  List<String> filter = [
    'Semua',
    '7 hari terakhir',
    'Bulan ini',
    '3 Bulan Terakhir'
  ];

  final List<String> items = [
    'Setting',
    'Logout',
  ];

  int selectedFilter = 0;
  bool isLoading = true;
  String? userType;
  bool isDataAktifitas = true;

  @override
  void initState() {
    getUserType();
    super.initState();
  }

  Future<void> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String type = prefs.getString('user')!;
    userType = type;
    isLoading = false;
    setState(() {});
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
              padding: const EdgeInsets.only(
                  bottom: 16.0, top: 12.0, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Text(
                        !isDataAktifitas
                            ? 'Permohonan Aktiftas'
                            : 'Data Aktiftas',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ),
                  InkWell(
                    onTap: () {
                      if (isDataAktifitas) {
                        isDataAktifitas = false;
                      } else {
                        isDataAktifitas = true;
                      }
                      setState(() {});
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                          child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/sort.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                              isDataAktifitas
                                  ? 'Permohonan Aktiftas'
                                  : 'Data Aktiftas',
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      )),
                    ),
                  ),
                ],
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
            userType == 'staff' ? aktifitasStaff() : aktifitasKadiv()
          ],
        ),
      ),
    );
  }

  Widget aktifitasStaff() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context, StringRouterUtil.aktifitasDetailScreenRoute);
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
                      color: const Color(0xFFC2C2C2).withOpacity(0.1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 35,
                    decoration: const BoxDecoration(
                      color: yellowColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                    child: const Center(
                      child: Text('01',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.23,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Aktifitas',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF797979),
                                fontWeight: FontWeight.w400)),
                        Text('lorem itsum lorem istum lorm itsum',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text('10',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah Waktu',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text('300',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 60,
                      child: Text('Pending',
                          style: TextStyle(
                              fontSize: 13,
                              color: yellowColor,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
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
                    color: const Color(0xFFC2C2C2).withOpacity(0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 35,
                  decoration: const BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  child: const Center(
                    child: Text('02',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktifitas',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text('lorem itsum lorem istum lorm itsum',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('10',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Waktu',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('300',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 60,
                    child: Text('Approved',
                        style: TextStyle(
                            fontSize: 13,
                            color: greenColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
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
                    color: const Color(0xFFC2C2C2).withOpacity(0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 35,
                  decoration: const BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  child: const Center(
                    child: Text('03',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktifitas',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text('lorem itsum lorem istum lorm itsum',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('10',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Waktu',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('300',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 60,
                    child: Text('Not Approved',
                        style: TextStyle(
                            fontSize: 13,
                            color: redColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
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
                    color: const Color(0xFFC2C2C2).withOpacity(0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 35,
                  decoration: const BoxDecoration(
                    color: yellowColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  child: const Center(
                    child: Text('04',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktifitas',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text('lorem itsum lorem istum lorm itsum',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('10',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Waktu',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('300',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 60,
                    child: Text('Pending',
                        style: TextStyle(
                            fontSize: 13,
                            color: yellowColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
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
                    color: const Color(0xFFC2C2C2).withOpacity(0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 35,
                  decoration: const BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  child: const Center(
                    child: Text('05',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktifitas',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text('lorem itsum lorem istum lorm itsum',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('10',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Waktu',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('300',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 60,
                    child: Text('Approved',
                        style: TextStyle(
                            fontSize: 13,
                            color: greenColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
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
                    color: const Color(0xFFC2C2C2).withOpacity(0.1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 35,
                  decoration: const BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                  ),
                  child: const Center(
                    child: Text('06',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.23,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aktifitas',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text('lorem itsum lorem istum lorm itsum',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('10',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jumlah Waktu',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w400)),
                    Text('300',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 60,
                    child: Text('Not Approved',
                        style: TextStyle(
                            fontSize: 13,
                            color: redColor,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget aktifitasKadiv() {
    return Expanded(
      child: ListView.separated(
        itemCount: 9,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  isDataAktifitas
                      ? StringRouterUtil.aktifitasDetailScreenRoute
                      : StringRouterUtil.permohonanAktifitasDetailScreenRoute);
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
                      color: const Color(0xFFC2C2C2).withOpacity(0.1))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 35,
                    decoration: BoxDecoration(
                      color: !isDataAktifitas ? yellowColor : greenColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                    child: Center(
                      child: Text('0${index + 1}',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.28,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Aktifitas',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF797979),
                                fontWeight: FontWeight.w400)),
                        Text('lorem itsum lorem istum lorm itsum',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isDataAktifitas ? 'Jumlah Waktu' : 'Jumlah Staff',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF797979),
                              fontWeight: FontWeight.w400)),
                      Text(isDataAktifitas ? '300' : '20',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(!isDataAktifitas ? 'Pending' : 'Approved',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: !isDataAktifitas
                                      ? yellowColor
                                      : greenColor,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: 18),
                        InkWell(
                          onTap: () {},
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
      ),
    );
  }
}
