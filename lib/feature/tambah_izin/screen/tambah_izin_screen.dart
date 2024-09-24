import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';

class TambahIzinScreen extends StatefulWidget {
  const TambahIzinScreen({super.key});

  @override
  State<TambahIzinScreen> createState() => _TambahIzinScreenState();
}

class _TambahIzinScreenState extends State<TambahIzinScreen> {
  String? selectedValue;
  final List<String> items = [
    'Setting',
    'Logout',
  ];

  final List<String> itemIzin = [
    'Cuti',
    'Sakit',
  ];
  bool isEdit = false;

  final TextEditingController _keteranganController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _hapusDialog(BuildContext context) async {
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
                    'assets/imgs/delete.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Yakin ingin menghapus data ini?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.26,
                        height: 41,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryColor)),
                        child: const Center(
                            child: Text('Kembali',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.26,
                        height: 41,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                            child: Text('Hapus',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                  ],
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
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text('Tambah Permohonan Izin',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                  ),
                  Container()
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 40.0, left: 16, right: 16.0, bottom: 32.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(-6, 4), // Shadow position
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFC2C2C2).withOpacity(0.1))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tanggal Izin',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 45,
                              padding: const EdgeInsets.only(left: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: const Color(0xFF9E9E9E))),
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
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 45,
                              padding: const EdgeInsets.only(left: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: const Color(0xFF9E9E9E))),
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
                        const SizedBox(height: 16),
                        const Text('Jenis Izin',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border:
                                  Border.all(color: const Color(0xFF9E9E9E))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: primaryColor,
                                ),
                              ),
                              hint: const Text(
                                'Pilih jenis izin',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFBBBBBB),
                                ),
                              ),
                              items: itemIzin
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Keterangan',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFF9E9E9E))),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            controller: _keteranganController,
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: 'Tulis keterangan izin anda...',
                                isDense: true,
                                contentPadding: const EdgeInsets.all(16),
                                hintStyle: const TextStyle(
                                    color: Color(0xFFBBBBBB),
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
                        const SizedBox(height: 16),
                        const Text('Upload File',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.61,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                  border: Border.all(
                                      color: const Color(0xFF9E9E9E))),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.225,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                  border: Border.all(color: primaryColor)),
                              child: const Center(
                                child: Text('File',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          ],
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
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            _hapusDialog(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: primaryColor)),
                            child: const Center(
                                child: Text('Hapus',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ]),
                )),
          ],
        ),
      ),
    );
  }
}
