import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/izin/bloc/tambah_izin_bloc/bloc.dart';
import 'package:malinau_absensi/feature/izin/data/izin_list_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/tambah_izin_request_model.dart';
import 'package:malinau_absensi/feature/izin/domain/izin_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class EditIzinScreen extends StatefulWidget {
  const EditIzinScreen({super.key, required this.data});
  final Data data;

  @override
  State<EditIzinScreen> createState() => _EditIzinScreenState();
}

class _EditIzinScreenState extends State<EditIzinScreen> {
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
  bool isLoading = false;
  bool isLoadingData = true;
  late String name;
  late String role;

  String fromDate = '';
  String toDate = '';
  String fromDateSend = '';
  String toDateSend = '';
  int dateOb = 0;
  final TextEditingController _keteranganController = TextEditingController();
  TambahIzinBloc tambahIzinBloc = TambahIzinBloc(izinRepo: IzinRepo());

  @override
  void initState() {
    GeneralUtil().getDataUser().then(
      (value) {
        setState(() {
          name = value['name']!;
          role = value['role']!;
          isLoadingData = false;
        });
      },
    );
    _getData();
    super.initState();
  }

  void _getData() {
    setState(() {
      fromDate = GeneralUtil.convertDate(widget.data.fromDate!);
      fromDateSend = GeneralUtil.convertDateSend(widget.data.fromDate!);
      toDate = GeneralUtil.convertDate(widget.data.toDate!);
      toDateSend = GeneralUtil.convertDateSend(widget.data.toDate!);
      selectedValue = widget.data.type;
      _keteranganController.text = widget.data.remarks!;
    });
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

  Future<void> _expDialog(BuildContext context) async {
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
                const Center(
                  child: Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.yellow,
                    weight: 80,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sesi Anda Telah Berakhir',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    SharedPrefUtil.clearSharedPref();
                    Navigator.pushNamedAndRemoveUntil(context,
                        StringRouterUtil.loginScreenRoute, (route) => false);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.56,
                    height: 41,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primaryColor)),
                    child: const Center(
                        child: Text('Login',
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

  void _startDatePicker() {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(widget.data.fromDate!);
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: parseDate,
            lastDate: DateTime.now().add(const Duration(days: 15000)),
            firstDate: parseDate)
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        setState(() {
          fromDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          fromDateSend = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
      });
    });
  }

  void _endDatePicker() {
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(widget.data.toDate!);
    showDatePicker(
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            initialDate: parseDate,
            lastDate: DateTime.now().add(const Duration(days: 15000)),
            firstDate: parseDate)
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        setState(() {
          toDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          toDateSend = DateFormat('yyyy-MM-dd').format(pickedDate);
        });
      });
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
                        isLoadingData
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Colors.grey.shade300,
                                      ),
                                      width: 80,
                                      height: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        color: Colors.grey.shade300,
                                      ),
                                      width: 80,
                                      height: 16,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hi, $name',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 2),
                                  Text(role,
                                      style: const TextStyle(
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text('Edit Permohonan Izin',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                  ),
                  Container()
                ],
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
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
                                color:
                                    const Color(0xFFC2C2C2).withOpacity(0.1))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tanggal Izin',
                                  style: TextStyle(
                                      fontSize:
                                          GeneralUtil.fontSize(context) * 0.35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: _startDatePicker,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height: 45,
                                      padding: const EdgeInsets.only(left: 8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: const Color(0xFF9E9E9E))),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            fromDate == ''
                                                ? 'mm/dd/yy'
                                                : fromDate,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: fromDate == ''
                                                    ? const Color(0xFFBBBBBB)
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor,
                                    ),
                                    child: Center(
                                      child: Text('s/d',
                                          style: TextStyle(
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.45,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _endDatePicker,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height: 45,
                                      padding: const EdgeInsets.only(left: 8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: const Color(0xFF9E9E9E))),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            toDate == '' ? 'mm/dd/yy' : toDate,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: toDate == ''
                                                    ? const Color(0xFFBBBBBB)
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text('Jenis Izin',
                                  style: TextStyle(
                                      fontSize:
                                          GeneralUtil.fontSize(context) * 0.35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: const Color(0xFF9E9E9E))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: primaryColor,
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                    hint: Text(
                                      'Pilih jenis izin',
                                      style: TextStyle(
                                        fontSize:
                                            GeneralUtil.fontSize(context) *
                                                0.35,
                                        color: const Color(0xFFBBBBBB),
                                      ),
                                    ),
                                    items: itemIzin
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize:
                                                      GeneralUtil.fontSize(
                                                              context) *
                                                          0.35,
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
                              Text('Keterangan',
                                  style: TextStyle(
                                      fontSize:
                                          GeneralUtil.fontSize(context) * 0.35,
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
                                  style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.35,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: 'Tulis keterangan izin anda...',
                                      isDense: true,
                                      contentPadding: const EdgeInsets.all(16),
                                      hintStyle: TextStyle(
                                          color: const Color(0xFFBBBBBB),
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.35,
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
                              Text('Upload File',
                                  style: TextStyle(
                                      fontSize:
                                          GeneralUtil.fontSize(context) * 0.35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    width: MediaQuery.of(context).size.width *
                                        0.61,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          bottomLeft: Radius.circular(4),
                                        ),
                                        border: Border.all(
                                            color: const Color(0xFF9E9E9E))),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Pilih file',
                                          style: TextStyle(
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.35,
                                              color: const Color(0xFFBBBBBB),
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                        border:
                                            Border.all(color: primaryColor)),
                                    child: Center(
                                      child: Text('File',
                                          style: TextStyle(
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.35,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              MultiBlocListener(
                                listeners: [
                                  BlocListener(
                                    bloc: tambahIzinBloc,
                                    listener: (_, TambahIzinState state) async {
                                      if (state is TambahIzinLoading) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                      }
                                      if (state is EditIzinLoaded) {
                                        GeneralUtil().showSnackBarSuccess(
                                            context,
                                            state
                                                .generalResponseModel.message!);
                                        Future.delayed(
                                            const Duration(milliseconds: 700),
                                            () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          if (context.mounted) {
                                            Navigator.pop(context, true);
                                          }
                                        });
                                      }
                                      if (state is TambahIzinError) {
                                        GeneralUtil().showSnackBarError(
                                            context, state.error!);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                      if (state is TambahIzinException) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        _expDialog(context);
                                      }
                                    },
                                  )
                                ],
                                child: isLoading
                                    ? const Center(
                                        child: SizedBox(
                                          width: 45,
                                          height: 45,
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          tambahIzinBloc.add(EditIzinAttempt(
                                              tambahIzinRequestModel:
                                                  TambahIzinRequestModel(
                                                      fromDate: fromDateSend,
                                                      toDate: toDateSend,
                                                      remarks:
                                                          _keteranganController
                                                              .text,
                                                      type: selectedValue,
                                                      id: widget.data.id)));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                              child: Text('Simpan',
                                                  style: TextStyle(
                                                      fontSize:
                                                          GeneralUtil.fontSize(
                                                                  context) *
                                                              0.4,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: primaryColor)),
                                  child: Center(
                                      child: Text('Hapus',
                                          style: TextStyle(
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.4,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600))),
                                ),
                              ),
                            ]),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
