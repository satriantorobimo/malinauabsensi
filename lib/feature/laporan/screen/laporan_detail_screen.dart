import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/laporan/bloc/tunjangan_kerja_detail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_detail_response_model.dart.dart';
import 'package:malinau_absensi/feature/laporan/domain/tunjangan_kinerja_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class LaporanDetailScreen extends StatefulWidget {
  const LaporanDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<LaporanDetailScreen> createState() => _LaporanDetailScreenState();
}

class _LaporanDetailScreenState extends State<LaporanDetailScreen> {
  bool isLoadingData = true;
  late String name;
  late String role;
  TunjanganKerjaDetailBloc tunjanganKerjaDetailBloc =
      TunjanganKerjaDetailBloc(tunjanganKinerjaRepo: TunjanganKinerjaRepo());

  @override
  void initState() {
    super.initState();
    tunjanganKerjaDetailBloc.add(TunjanganKerjaDetailAttempt(id: widget.id));
    GeneralUtil().getDataUser().then(
      (value) {
        setState(() {
          name = value['name']!;
          role = value['role']!;
          isLoadingData = false;
        });
      },
    );
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

  Future<void> _showBottomAttachment(
      BuildContext context, ListPotongan listPotongan) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 24.0, left: 16, right: 16),
                  child: Text(
                    'Detail List Potongan',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tipe Potongan',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.35,
                              color: const Color(0xFF797979),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(listPotongan.tipePotongan!,
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text('Tipe Potongan (%)',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.35,
                              color: const Color(0xFF797979),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('${listPotongan.tipePotonganPersen}%',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text('Potongan',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.35,
                              color: const Color(0xFF797979),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(GeneralUtil.convertToIdr(listPotongan.potonganRp, 0),
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text('Potongan (%)',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.35,
                              color: const Color(0xFF797979),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text('${listPotongan.potonganPersen}%',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text('Reason',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.35,
                              color: const Color(0xFF797979),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(listPotongan.reason!,
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
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
                              } else if (a.text == 'LaporanDetail') {
                                Navigator.pushNamed(context,
                                    StringRouterUtil.settingScreenRoute);
                              } else if (a.text == 'Profile') {
                                Navigator.pushNamed(context,
                                    StringRouterUtil.profileScreenRoute);
                              } else if (a.text == 'Ubah Password') {
                                Navigator.pushNamed(context,
                                    StringRouterUtil.ubahPasswordScreenRoute);
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
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, right: 16),
                    child: Column(
                      children: [
                        Text('Tunjangan Kinerja',
                            style: TextStyle(
                                fontSize: GeneralUtil.fontSize(context) * 0.35,
                                color: const Color(0xFF797979),
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 245,
                          child: Text('Detail',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize:
                                      GeneralUtil.fontSize(context) * 0.35,
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
            BlocListener(
              bloc: tunjanganKerjaDetailBloc,
              listener: (_, TunjanganKerjaDetailState state) async {
                if (state is TunjanganKerjaDetailLoading) {}
                if (state is TunjanganKerjaDetailLoaded) {}
                if (state is TunjanganKerjaDetailError) {
                  if (state.error! == 'Token is expired') {
                    _expDialog(context);
                  } else {
                    GeneralUtil().showSnackBarError(context, state.error!);
                  }
                }
                if (state is TunjanganKerjaDetailException) {
                  GeneralUtil().showSnackBarError(context, state.error);
                }
              },
              child: BlocBuilder(
                  bloc: tunjanganKerjaDetailBloc,
                  builder: (_, TunjanganKerjaDetailState state) {
                    if (state is TunjanganKerjaDetailLoaded) {
                      return Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 40.0,
                                  left: 16,
                                  right: 16.0,
                                  bottom: 32.0),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 3,
                                        offset: const Offset(
                                            -6, 4), // Shadow position
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xFFC2C2C2)
                                            .withOpacity(0.1))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Nama',
                                                      style: TextStyle(
                                                          fontSize:
                                                              GeneralUtil.fontSize(
                                                                      context) *
                                                                  0.35,
                                                          color: const Color(
                                                              0xFF797979),
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                      state
                                                          .tunjanganKinerjaDetailResponseModel
                                                          .pegawaiNama!,
                                                      style: TextStyle(
                                                          fontSize: GeneralUtil
                                                                  .fontSize(
                                                                      context) *
                                                              0.4,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.41,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Tunjangan Pokok',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.35,
                                                            color: const Color(
                                                                0xFF797979),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                        GeneralUtil.convertToIdr(
                                                            state
                                                                .tunjanganKinerjaDetailResponseModel
                                                                .tunjanganPokok!,
                                                            0),
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.4,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Periode',
                                                      style: TextStyle(
                                                          fontSize:
                                                              GeneralUtil.fontSize(
                                                                      context) *
                                                                  0.35,
                                                          color: const Color(
                                                              0xFF797979),
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                      state
                                                          .tunjanganKinerjaDetailResponseModel
                                                          .periode!,
                                                      style: TextStyle(
                                                          fontSize: GeneralUtil
                                                                  .fontSize(
                                                                      context) *
                                                              0.4,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.41,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Total Tunjangan',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.35,
                                                            color: const Color(
                                                                0xFF797979),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                        '${GeneralUtil.convertToIdr(state.tunjanganKinerjaDetailResponseModel.totalTunjangan!, 0)} (${(state.tunjanganKinerjaDetailResponseModel.tunjanganPokok! / state.tunjanganKinerjaDetailResponseModel.totalTunjangan!) * 100}%)',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.4,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Aktifitas',
                                                      style: TextStyle(
                                                          fontSize:
                                                              GeneralUtil.fontSize(
                                                                      context) *
                                                                  0.35,
                                                          color: const Color(
                                                              0xFF797979),
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                      state.tunjanganKinerjaDetailResponseModel
                                                                  .aktifitas! ==
                                                              ''
                                                          ? '-'
                                                          : state
                                                              .tunjanganKinerjaDetailResponseModel
                                                              .aktifitas!,
                                                      style: TextStyle(
                                                          fontSize: GeneralUtil
                                                                  .fontSize(
                                                                      context) *
                                                              0.4,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.41,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Total Potongan',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.35,
                                                            color: const Color(
                                                                0xFF797979),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                        GeneralUtil.convertToIdr(
                                                            state
                                                                .tunjanganKinerjaDetailResponseModel
                                                                .totalPotongan!,
                                                            0),
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.4,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Text('Predikat Performa',
                                              style: TextStyle(
                                                  fontSize:
                                                      GeneralUtil.fontSize(
                                                              context) *
                                                          0.35,
                                                  color:
                                                      const Color(0xFF797979),
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 8),
                                          Text(
                                              state.tunjanganKinerjaDetailResponseModel
                                                          .predikat! ==
                                                      ''
                                                  ? '-'
                                                  : state
                                                      .tunjanganKinerjaDetailResponseModel
                                                      .predikat!,
                                              style: TextStyle(
                                                  fontSize:
                                                      GeneralUtil.fontSize(
                                                              context) *
                                                          0.4,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 16),
                                          Text('List Potongan Tunjangan',
                                              style: TextStyle(
                                                  fontSize:
                                                      GeneralUtil.fontSize(
                                                              context) *
                                                          0.38,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 8),
                                          state.tunjanganKinerjaDetailResponseModel
                                                  .tipePotongan!.isEmpty
                                              ? Container()
                                              : ListView.separated(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        _showBottomAttachment(
                                                            context,
                                                            state
                                                                .tunjanganKinerjaDetailResponseModel
                                                                .tipePotongan![
                                                                    index]
                                                                .listPotongan![0]);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.1),
                                                                    blurRadius:
                                                                        3,
                                                                    offset: const Offset(
                                                                        -6,
                                                                        4), // Shadow position
                                                                  ),
                                                                ],
                                                                border: Border.all(
                                                                    color: const Color(
                                                                            0xFFC2C2C2)
                                                                        .withOpacity(
                                                                            0.1))),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Tipe Potongan',
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.25,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                Text(
                                                                    state
                                                                        .tunjanganKinerjaDetailResponseModel
                                                                        .tipePotongan![
                                                                            index]
                                                                        .tipePotongan!,
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.3,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Tipe Potongan Persen',
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.25,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                Text(
                                                                    '${state.tunjanganKinerjaDetailResponseModel.tipePotongan![index].tipePotonganPersen!.toString()}%',
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.3,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text('Potongan',
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.25,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                Text(
                                                                    GeneralUtil.convertToIdr(
                                                                        state
                                                                            .tunjanganKinerjaDetailResponseModel
                                                                            .tipePotongan![
                                                                                index]
                                                                            .totalPotonganRp!,
                                                                        0),
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.3,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    'Potongan Persen',
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.25,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                                Text(
                                                                    '${state.tunjanganKinerjaDetailResponseModel.tipePotongan![index].totalPotonganPersen!.toString()}%',
                                                                    style: TextStyle(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .white,
                                                                        fontSize:
                                                                            GeneralUtil.fontSize(context) *
                                                                                0.3,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w700)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox(
                                                        height: 10);
                                                  },
                                                  itemCount: state
                                                      .tunjanganKinerjaDetailResponseModel
                                                      .tipePotongan!
                                                      .length)
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
