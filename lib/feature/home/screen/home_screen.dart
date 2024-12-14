import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/bloc/avail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/bloc/list_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_list_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/update_absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/user_availability_response_model.dart'
    as user;
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../absensi/bloc/update_bloc/bloc.dart';

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
  ListBloc listBloc = ListBloc(absenRepo: AbsenRepo());
  UpdateBloc updateBloc = UpdateBloc(absenRepo: AbsenRepo());
  AvailBloc availBloc = AvailBloc(absenRepo: AbsenRepo());
  List<Data> data = [];
  List<Data> tempData = [];
  late user.Data dataUser;
  bool isLoading = true;
  bool isLoadingData = true;
  late String name;
  late String role;
  bool isReserved = false;

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

  Future<void> _displayTextInputDialog(BuildContext context, String id) async {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('2 Nov 2023',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                    Text('Isi Keterangan Aktifitas',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.4,
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
                          fontSize: GeneralUtil.fontSize(context) * 0.35,
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
              BlocListener(
                  bloc: updateBloc,
                  listener: (_, UpdateState state) async {
                    if (state is UpdateLoading) {}
                    if (state is UpdateLoaded) {
                      Navigator.pop(context);
                      GeneralUtil().showSnackBarSuccess(
                          context, 'Keterangan berhasil disimpan');
                    }
                    if (state is UpdateError) {
                      if (state.error! == 'Token is expired') {
                        _expDialog(context);
                      } else {
                        GeneralUtil().showSnackBarError(context, state.error!);
                      }
                    }
                    if (state is UpdateException) {
                      GeneralUtil().showSnackBarError(context, state.error);
                    }
                  },
                  child: BlocBuilder(
                      bloc: updateBloc,
                      builder: (_, UpdateState state) {
                        if (state is UpdateLoading) {
                          return const Center(
                            child: SizedBox(
                              width: 45,
                              height: 45,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state is UpdateLoaded) {
                          return InkWell(
                            onTap: () {
                              DateTime now = DateTime.now();
                              String formatedDate =
                                  DateFormat('dd-MM-yyyy').format(now);
                              updateBloc.add(UpdateAttempt(
                                  updateAbsenRequestModel:
                                      UpdateAbsenRequestModel(
                                          requestDate: formatedDate,
                                          keterangan:
                                              _keteranganController.text,
                                          userID: id)));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                  child: Text('Simpan',
                                      style: TextStyle(
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.37,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600))),
                            ),
                          );
                        }

                        return InkWell(
                          onTap: () {
                            DateTime now = DateTime.now();
                            String formatedDate =
                                DateFormat('dd-MM-yyyy').format(now);
                            updateBloc.add(UpdateAttempt(
                                updateAbsenRequestModel:
                                    UpdateAbsenRequestModel(
                                        requestDate: formatedDate,
                                        keterangan: _keteranganController.text,
                                        userID: id)));
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                                child: Text('Simpan',
                                    style: TextStyle(
                                        fontSize:
                                            GeneralUtil.fontSize(context) *
                                                0.37,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))),
                          ),
                        );
                      })),
            ],
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

  @override
  void initState() {
    listBloc.add(const ListAttempt(start: '', end: ''));
    GeneralUtil().getDataUser().then(
      (value) {
        setState(() {
          name = value['name']!;
          role = value['role']!;
          isLoadingData = false;
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
                              } else if (a.text == 'Setting') {
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
              padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Daftar Absensi',
                              style: TextStyle(
                                  fontSize: GeneralUtil.fontSize(context) * 0.6,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          isLoading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade300,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    if (dataUser.userStatus! == 'INACTIVE') {
                                      bool isCameraGranted = await Permission
                                          .camera
                                          .request()
                                          .isGranted;

                                      if (!isCameraGranted) {
                                        isCameraGranted =
                                            await Permission.camera.request() ==
                                                PermissionStatus.granted;
                                      }
                                      WidgetsFlutterBinding.ensureInitialized();
                                      final cameras = await availableCameras();
                                      final firstCamera = cameras.first;
                                      if (context.mounted) {
                                        Navigator.pushNamed(
                                            context,
                                            StringRouterUtil
                                                .faceRegisterScanScreenRoute,
                                            arguments: firstCamera);
                                      }
                                    } else {
                                      if (dataUser.isAvailableToCheckIn!) {
                                        if (GeneralUtil().isWithinCheckInTime(
                                            dataUser.checkInRangeTime!
                                                .startTime!)) {
                                          Navigator.pushNamed(context,
                                              StringRouterUtil.absenScreenRoute,
                                              arguments: dataUser);
                                        } else {
                                          GeneralUtil().showSnackBarError(
                                              context,
                                              'Absen masuk start dari pukul ${dataUser.checkOutRangeTime!.startTime!}');
                                        }
                                      } else {
                                        if (GeneralUtil().isWithinCheckInTime(
                                            dataUser.checkOutRangeTime!
                                                .startTime!)) {
                                          Navigator.pushNamed(
                                              context,
                                              StringRouterUtil
                                                  .absenKeluarScreenRoute,
                                              arguments: dataUser);
                                        } else {
                                          GeneralUtil().showSnackBarError(
                                              context,
                                              'Absen keluar start dari pukul ${dataUser.checkOutRangeTime!.startTime!}');
                                        }
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Center(
                                        child: Text(
                                            dataUser.userStatus! == 'INACTIVE'
                                                ? 'Registrasi Wajah'
                                                : dataUser.isAvailableToCheckIn!
                                                    ? 'Absen Masuk'
                                                    : 'Absen Keluar',
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                ),
                        ],
                      ),
                      // const SizedBox(height: 16),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       width: 110,
                      //       height: 95,
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(8),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.grey.withOpacity(0.1),
                      //               blurRadius: 3,
                      //               offset:
                      //                   const Offset(-6, 4), // Shadow position
                      //             ),
                      //           ],
                      //           border: Border.all(
                      //               color: const Color(0xFFC2C2C2)
                      //                   .withOpacity(0.2))),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Container(
                      //             width: 50,
                      //             height: 6,
                      //             decoration: BoxDecoration(
                      //               color: greenColor,
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           const Text('Tepat waktu',
                      //               style: TextStyle(
                      //                   fontSize: 14,
                      //                   color: Color(0xFF797979),
                      //                   fontWeight: FontWeight.w400)),
                      //           const SizedBox(height: 12),
                      //           const Text('20 hari',
                      //               style: TextStyle(
                      //                   fontSize: 16,
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w600)),
                      //         ],
                      //       ),
                      //     ),
                      //     Container(
                      //       width: 110,
                      //       height: 95,
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(8),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.grey.withOpacity(0.1),
                      //               blurRadius: 3,
                      //               offset:
                      //                   const Offset(-6, 4), // Shadow position
                      //             ),
                      //           ],
                      //           border: Border.all(
                      //               color: const Color(0xFFC2C2C2)
                      //                   .withOpacity(0.2))),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Container(
                      //             width: 50,
                      //             height: 6,
                      //             decoration: BoxDecoration(
                      //               color: redColor,
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           const Text('Telat',
                      //               style: TextStyle(
                      //                   fontSize: 14,
                      //                   color: Color(0xFF797979),
                      //                   fontWeight: FontWeight.w400)),
                      //           const SizedBox(height: 12),
                      //           const Text('2 hari',
                      //               style: TextStyle(
                      //                   fontSize: 16,
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w600)),
                      //         ],
                      //       ),
                      //     ),
                      //     Container(
                      //       width: 110,
                      //       height: 95,
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(8),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.grey.withOpacity(0.1),
                      //               blurRadius: 3,
                      //               offset:
                      //                   const Offset(-6, 4), // Shadow position
                      //             ),
                      //           ],
                      //           border: Border.all(
                      //               color: const Color(0xFFC2C2C2)
                      //                   .withOpacity(0.2))),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Container(
                      //             width: 50,
                      //             height: 6,
                      //             decoration: BoxDecoration(
                      //               color: primaryColor,
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           const Text('Jam kerja',
                      //               style: TextStyle(
                      //                   fontSize: 14,
                      //                   color: Color(0xFF797979),
                      //                   fontWeight: FontWeight.w400)),
                      //           const SizedBox(height: 12),
                      //           const Text('20 jam',
                      //               style: TextStyle(
                      //                   fontSize: 16,
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w600)),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.055,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.055,
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
                                if (index == 0) {
                                  listBloc.add(
                                      const ListAttempt(start: '', end: ''));
                                } else if (index == 1) {
                                  Map<String, String> dateRange = GeneralUtil()
                                      .getFormattedFirstAndLastDateOfLastSevenDays();
                                  listBloc.add(ListAttempt(
                                      start: dateRange['firstDate']!,
                                      end: dateRange['lastDate']!));
                                } else if (index == 2) {
                                  Map<String, String> dateRange = GeneralUtil()
                                      .getFormattedFirstAndLastDateOfCurrentMonth();
                                  listBloc.add(ListAttempt(
                                      start: dateRange['firstDate']!,
                                      end: dateRange['lastDate']!));
                                } else {
                                  Map<String, String> dateRange = GeneralUtil()
                                      .getFormattedFirstAndLastDateOfLastThreeMonths();
                                  listBloc.add(ListAttempt(
                                      start: dateRange['firstDate']!,
                                      end: dateRange['lastDate']!));
                                }
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
                                  child: AutoSizeText(filter[index],
                                      style: TextStyle(
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.4,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isReserved) {
                              isReserved = false;
                              data = tempData;
                            } else {
                              isReserved = true;
                              data = tempData.reversed.toList();
                            }
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/icons/filter.svg',
                          colorFilter: const ColorFilter.mode(
                              primaryColor, BlendMode.srcIn),
                          height: 32,
                          width: 32,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            MultiBlocListener(
              listeners: [
                BlocListener(
                  bloc: listBloc,
                  listener: (_, ListState state) async {
                    if (state is ListLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    if (state is ListLoaded) {
                      availBloc.add(AvailAttempt());
                      setState(() {
                        data.addAll(state.absenListResponseModel.data!);
                        tempData = data;
                      });
                    }
                    if (state is ListError) {
                      setState(() {
                        isLoading = false;
                      });
                      if (state.error! == 'Token is expired') {
                        _expDialog(context);
                      } else {
                        GeneralUtil().showSnackBarError(context, state.error!);
                      }
                    }
                    if (state is ListException) {
                      setState(() {
                        isLoading = false;
                      });
                      GeneralUtil().showSnackBarError(context, state.error);
                    }
                  },
                ),
                BlocListener(
                  bloc: availBloc,
                  listener: (_, AvailState state) async {
                    if (state is AvailLoading) {}
                    if (state is AvailLoaded) {
                      setState(() {
                        isLoading = false;

                        dataUser = state.userAvailabilityResponseModel.data!;
                      });
                    }
                    if (state is AvailError) {
                      setState(() {
                        isLoading = false;
                      });
                      if (state.error! == 'Token is expired') {
                        _expDialog(context);
                      } else {
                        GeneralUtil().showSnackBarError(context, state.error!);
                      }
                    }
                    if (state is AvailException) {
                      setState(() {
                        isLoading = false;
                      });
                      GeneralUtil().showSnackBarError(context, state.error);
                    }
                  },
                ),
              ],
              child: isLoading
                  ? Expanded(
                      child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: GeneralUtil().loading3Data(10),
                    ))
                  : data.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Center(
                            child: Text('Data absensi belum tersedia',
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.45,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      : mainContent(),
            )
          ],
        ),
      ),
    );
  }

  Widget mainContent() {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, StringRouterUtil.absenDetailScreenRoute,
                    arguments: data[index].id);
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
                    Row(
                      children: [
                        Container(
                          width: 16,
                          decoration: BoxDecoration(
                            color: data[index].status! == 'Tepat Waktu'
                                ? greenColor
                                : redColor,
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
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                  GeneralUtil.monthCheck2(
                                      data[index].createdAt!),
                                  style: TextStyle(
                                      fontSize:
                                          GeneralUtil.fontSize(context) * 0.35,
                                      color: const Color(0xFF797979),
                                      fontWeight: FontWeight.w400)),
                            ),
                            Text(
                                GeneralUtil.dateDayCheck(
                                    data[index].createdAt!),
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.35,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        const SizedBox(width: 18),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(GeneralUtil.dayCheck(data[index].createdAt!),
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.35,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            Text(data[index].status!,
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.3,
                                    color: data[index].status! == 'Tepat Waktu'
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
                              '${GeneralUtil.timeConvert(data[index].checkInTime!.string!)} - ${GeneralUtil.timeConvert(data[index].checkOutTime!.string! == "" ? '00:00:00' : data[index].checkOutTime!.string!)}',
                              style: TextStyle(
                                  fontSize:
                                      GeneralUtil.fontSize(context) * 0.35,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 18),
                          InkWell(
                            onTap: () {
                              _displayTextInputDialog(context, data[index].id!);
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
          itemCount: data.length),
    );
  }
}
