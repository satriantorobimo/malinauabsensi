import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/izin/bloc/izin_list_bloc/bloc.dart';
import 'package:malinau_absensi/feature/izin/data/izin_list_response_model.dart';
import 'package:malinau_absensi/feature/izin/domain/izin_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class IzinScreen extends StatefulWidget {
  const IzinScreen({super.key});

  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> {
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
  bool isDataIzin = true;
  bool isLoadingData = true;
  late String name;
  late String role;
  IzinListBloc izinListBloc = IzinListBloc(izinRepo: IzinRepo());
  List<Data> dataList = [];
  List<Data> dataListTemp = [];
  bool isReserved = false;

  @override
  void initState() {
    getUserType();
    GeneralUtil().getDataUser().then(
      (value) {
        setState(() {
          name = value['name']!;
          role = value['role']!;
          isLoadingData = false;
        });
      },
    );
    izinListBloc.add(const IzinListAttempt(start: '', end: ''));
    super.initState();
  }

  Future<void> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String type = prefs.getString('user')!;
    userType = type;
    isLoading = false;
    setState(() {});
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
            staffWidget()
          ],
        ),
      ),
    );
  }

  Widget staffWidget() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daftar Izin',
                          style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.6,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                                  StringRouterUtil.tambahIzinScreenRoute)
                              .then(
                            (value) {
                              if (value.toString() == 'true') {
                                izinListBloc.add(
                                    const IzinListAttempt(start: '', end: ''));
                              }
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/plus.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 18,
                                width: 18,
                              ),
                              Text('Tambah',
                                  style: TextStyle(
                                      fontSize:
                                          GeneralUtil.fontSize(context) * 0.35,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                                izinListBloc.add(
                                    const IzinListAttempt(start: '', end: ''));
                              } else if (index == 1) {
                                Map<String, String> dateRange = GeneralUtil()
                                    .getFormattedFirstAndLastDateOfLastSevenDays();
                                izinListBloc.add(IzinListAttempt(
                                    start: dateRange['firstDate']!,
                                    end: dateRange['lastDate']!));
                              } else if (index == 2) {
                                Map<String, String> dateRange = GeneralUtil()
                                    .getFormattedFirstAndLastDateOfCurrentMonth();
                                izinListBloc.add(IzinListAttempt(
                                    start: dateRange['firstDate']!,
                                    end: dateRange['lastDate']!));
                              } else {
                                Map<String, String> dateRange = GeneralUtil()
                                    .getFormattedFirstAndLastDateOfLastThreeMonths();
                                izinListBloc.add(IzinListAttempt(
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
                                child: Text(filter[index],
                                    style: TextStyle(
                                        fontSize:
                                            GeneralUtil.fontSize(context) * 0.4,
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
                            dataList = dataListTemp;
                          } else {
                            isReserved = true;
                            dataList = dataListTemp.reversed.toList();
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
          BlocListener(
              bloc: izinListBloc,
              listener: (_, IzinListState state) async {
                if (state is IzinListLoading) {
                  setState(() {
                    isLoading = true;
                  });
                }
                if (state is IzinListLoaded) {
                  setState(() {
                    isLoading = false;
                    dataList = state.izinListResponseModel.data!;
                    dataListTemp = dataList;
                  });
                }
                if (state is IzinListError) {
                  GeneralUtil().showSnackBarError(context, state.error!);
                  setState(() {
                    isLoading = false;
                  });
                }
                if (state is IzinListException) {
                  setState(() {
                    isLoading = false;
                  });
                  _expDialog(context);
                }
              },
              child: BlocBuilder(
                  bloc: izinListBloc,
                  builder: (_, IzinListState state) {
                    return isLoading
                        ? Expanded(
                            child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: GeneralUtil().loading3Data(10),
                          ))
                        : dataList.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Center(
                                  child: Text('Data izin belum tersedia',
                                      style: TextStyle(
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.45,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                ),
                              )
                            : Expanded(
                                child: ListView.separated(
                                    itemCount: dataList.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 40),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  StringRouterUtil
                                                      .izinDetailScreenRoute,
                                                  arguments: dataList[index]);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      blurRadius: 3,
                                                      offset: const Offset(-6,
                                                          4), // Shadow position
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                      color: const Color(
                                                              0xFFC2C2C2)
                                                          .withOpacity(0.1))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: dataList[index]
                                                                      .status ==
                                                                  'Pending'
                                                              ? yellowColor
                                                              : dataList[index]
                                                                          .status ==
                                                                      'Reject'
                                                                  ? redColor
                                                                  : greenColor,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    6),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    6),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                              '0${index + 1}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.45,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Tanggal',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.3,
                                                                  color: const Color(
                                                                      0xFF797979),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          Text(
                                                              '${GeneralUtil.convertDate(dataList[index].fromDate!)} - ${GeneralUtil.convertDate(dataList[index].toDate!)}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.35,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 32),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Izin',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.3,
                                                                  color: const Color(
                                                                      0xFF797979),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          Text(
                                                              dataList[index]
                                                                  .type!,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.35,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 52.0),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 60,
                                                          child: Text(
                                                              dataList[index]
                                                                  .status!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.35,
                                                                  color: dataList[index]
                                                                              .status ==
                                                                          'Pending'
                                                                      ? yellowColor
                                                                      : dataList[index].status ==
                                                                              'Reject'
                                                                          ? redColor
                                                                          : greenColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 12,
                                            right: 16,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                        context,
                                                        StringRouterUtil
                                                            .editDetailScreenRoute,
                                                        arguments:
                                                            dataList[index])
                                                    .then(
                                                  (value) {
                                                    if (value.toString() ==
                                                        'true') {
                                                      izinListBloc.add(
                                                          const IzinListAttempt(
                                                              start: '',
                                                              end: ''));
                                                    }
                                                  },
                                                );
                                              },
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    'assets/icons/edit.svg',
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            Colors.white,
                                                            BlendMode.srcIn),
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              );
                  })),
        ],
      ),
    );
  }
}
