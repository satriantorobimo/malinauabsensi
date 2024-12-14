import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/bloc/summary_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/feature/aktifitas/data/acara_list_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/domain/aktifitas_repo.dart';
import 'package:malinau_absensi/feature/beranda/widget_tunjangan_kerja.dart';
import 'package:malinau_absensi/feature/kendala_absensi/domain/kendala_absen_repo.dart';
import 'package:malinau_absensi/feature/laporan/bloc/tunjangan_kerja_detail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/laporan/domain/tunjangan_kinerja_repo.dart';
import 'package:malinau_absensi/feature/tab/provider/tab_provider.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as chart;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../absensi/bloc/list_bloc/bloc.dart';
import '../aktifitas/bloc/acara_list_bloc/bloc.dart';
import '../aktifitas/bloc/dinas_luar_list_bloc/bloc.dart';
import 'package:malinau_absensi/feature/kendala_absensi/bloc/list_bloc/bloc.dart'
    as kendala;

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  late List<chart.Series> seriesList;
  late bool animate;

  final List<String> items = [
    'Profile',
    'Setting',
    'Logout',
  ];
  bool isLoading = true;

  bool isLoadingData = true;
  bool isTunjanganExist = false;
  late String name;
  late String role;
  int telat = 0;
  int tepatWaktu = 0;
  int total = 0;
  ListBloc listBloc = ListBloc(absenRepo: AbsenRepo());
  DinasLuarListBloc dinasLuarListBloc =
      DinasLuarListBloc(aktifitasARepo: AktifitasARepo());
  AcaraListBloc acaraListBloc = AcaraListBloc(aktifitasARepo: AktifitasARepo());
  SummaryBloc summaryBloc = SummaryBloc(absenRepo: AbsenRepo());
  kendala.ListBloc listKendalaBloc =
      kendala.ListBloc(kendalaAbsenRepo: KendalaAbsenRepo());

  int selectedFilter = 0;

  TunjanganKerjaDetailBloc tunjanganKerjaDetailBloc =
      TunjanganKerjaDetailBloc(tunjanganKinerjaRepo: TunjanganKinerjaRepo());

  static List<chart.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      OrdinalSales('Mon', 5),
      OrdinalSales('Tue', 25),
      OrdinalSales('Wed', 25),
      OrdinalSales('Thu', 100),
      OrdinalSales('Fri', 75),
    ];

    return [
      chart.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        fillColorFn: (OrdinalSales ordinalSales, _) =>
            chart.ColorUtil.fromDartColor(primaryColor),
      )
    ];
  }

  Color? color = primaryColor;

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
    GeneralUtil().getDataUser().then(
      (value) {
        setState(() {
          name = value['name']!;
          role = value['role']!;
          isLoadingData = false;
        });
      },
    );
    Map<String, String> dateRange =
        GeneralUtil().getFormattedFirstAndLastDateOfLast3Days();

    summaryBloc.add(SummaryAttempt());
    listBloc.add(ListAttempt(
        end: dateRange['firstDate']!, start: dateRange['lastDate']!));
    acaraListBloc.add(AcaraListAttempt(
        end: dateRange['firstDate']!, start: dateRange['lastDate']!));
    dinasLuarListBloc.add(DinasLuarListAttempt(
        end: dateRange['firstDate']!, start: dateRange['lastDate']!));
    listKendalaBloc.add(kendala.KendalaListAttempt(
        end: dateRange['firstDate']!, start: dateRange['lastDate']!));

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
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    bottom: 100.0, top: 16, left: 16, right: 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Ringkasan Absensi',
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  BlocListener(
                      bloc: summaryBloc,
                      listener: (_, SummaryState state) async {
                        if (state is SummaryLoading) {}
                        if (state is SummaryLoaded) {
                          if (state.absenSummaryResponseModel.data!.summary!
                              .isNotEmpty) {
                            for (int i = 0;
                                i <
                                    state.absenSummaryResponseModel.data!
                                        .summary!.length;
                                i++) {
                              if (state.absenSummaryResponseModel.data!
                                      .summary![i].status ==
                                  'Terlambat') {
                                setState(() {
                                  telat = state.absenSummaryResponseModel.data!
                                          .summary![i].count ??
                                      0;
                                  total++;
                                });
                              }
                              if (state.absenSummaryResponseModel.data!
                                      .summary![i].status ==
                                  'Tepat Waktu') {
                                setState(() {
                                  tepatWaktu = state.absenSummaryResponseModel
                                          .data!.summary![i].count ??
                                      0;
                                  total++;
                                });
                              }
                            }
                          }
                        }
                        if (state is SummaryError) {
                          if (state.error! == 'Token is expired') {
                            _expDialog(context);
                          } else {
                            GeneralUtil()
                                .showSnackBarError(context, state.error!);
                          }
                        }
                        if (state is SummaryException) {
                          GeneralUtil().showSnackBarError(context, state.error);
                        }
                      },
                      child: BlocBuilder(
                          bloc: summaryBloc,
                          builder: (_, SummaryState state) {
                            if (state is SummaryLoaded) {
                              return GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3, // number of items in each row
                                  mainAxisSpacing: 16.0, // spacing between rows
                                  crossAxisSpacing:
                                      16.0, // spacing between columns
                                ),
                                padding: const EdgeInsets.all(
                                    8.0), // padding around the grid
                                itemCount: state.absenSummaryResponseModel.data!
                                    .summary!.length, // total number of items
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 3,
                                            offset: const Offset(
                                                -6, 4), // Shadow position
                                          ),
                                        ],
                                        border: Border.all(
                                            color: const Color(0xFFC2C2C2)
                                                .withOpacity(0.2))),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: state
                                                        .absenSummaryResponseModel
                                                        .data!
                                                        .summary![index]
                                                        .status! ==
                                                    'Tepat Waktu'
                                                ? greenColor
                                                : state
                                                            .absenSummaryResponseModel
                                                            .data!
                                                            .summary![index]
                                                            .status! ==
                                                        'Terlambat'
                                                    ? redColor
                                                    : yellowColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                            state.absenSummaryResponseModel
                                                .data!.summary![index].status!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFF797979),
                                                fontWeight: FontWeight.w400)),
                                        const SizedBox(height: 12),
                                        Text(
                                            '${state.absenSummaryResponseModel.data!.summary![index].count!} hari',
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.4,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    3, // number of items in each row
                                mainAxisSpacing: 16.0, // spacing between rows
                                crossAxisSpacing:
                                    16.0, // spacing between columns
                              ),
                              padding: const EdgeInsets.all(
                                  8.0), // padding around the grid
                              itemCount: 6, // total number of items
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                );
                              },
                            );
                          })),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Absensi 3 hari Terakhir',
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      InkWell(
                        onTap: () {
                          var bottomBarProvider =
                              Provider.of<TabProvider>(context, listen: false);
                          bottomBarProvider.setPage(2);
                          bottomBarProvider.setTab(2);
                        },
                        child: Text('Selengkapnya',
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: GeneralUtil.fontSize(context) * 0.35,
                                color: primaryColor,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocListener(
                      bloc: listBloc,
                      listener: (_, ListState state) async {
                        if (state is ListLoading) {}
                        if (state is ListLoaded) {}
                        if (state is ListError) {}
                        if (state is ListException) {
                          GeneralUtil().showSnackBarError(context, state.error);
                        }
                      },
                      child: BlocBuilder(
                          bloc: listBloc,
                          builder: (_, ListState state) {
                            if (state is ListLoaded) {
                              return state.absenListResponseModel.data!.isEmpty
                                  ? Center(
                                      child: Text(
                                          'Data absen 3 hari terakhir belum tersedia',
                                          style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.35,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  : ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .absenDetailScreenRoute,
                                                arguments: state
                                                    .absenListResponseModel
                                                    .data![index]
                                                    .id);
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
                                                    color:
                                                        const Color(0xFFC2C2C2)
                                                            .withOpacity(0.1))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      decoration: BoxDecoration(
                                                        color: state
                                                                    .absenListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .status! ==
                                                                'Tepat Waktu'
                                                            ? greenColor
                                                            : redColor,
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
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                              GeneralUtil.monthCheck2(state
                                                                  .absenListResponseModel
                                                                  .data![index]
                                                                  .createdAt!),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.35,
                                                                  color: const Color(
                                                                      0xFF797979),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ),
                                                        Text(
                                                            GeneralUtil
                                                                .dateDayCheck(state
                                                                    .absenListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .createdAt!),
                                                            style: TextStyle(
                                                                fontSize: GeneralUtil
                                                                        .fontSize(
                                                                            context) *
                                                                    0.35,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 18),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            GeneralUtil.dayCheck(state
                                                                .absenListResponseModel
                                                                .data![index]
                                                                .createdAt!),
                                                            style: TextStyle(
                                                                fontSize: GeneralUtil
                                                                        .fontSize(
                                                                            context) *
                                                                    0.35,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        Text(
                                                            state
                                                                .absenListResponseModel
                                                                .data![index]
                                                                .status!,
                                                            style: TextStyle(
                                                                fontSize: GeneralUtil
                                                                        .fontSize(
                                                                            context) *
                                                                    0.3,
                                                                color: state
                                                                            .absenListResponseModel
                                                                            .data![
                                                                                index]
                                                                            .status! ==
                                                                        'Tepat Waktu'
                                                                    ? greenColor
                                                                    : redColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          '${GeneralUtil.timeConvert(state.absenListResponseModel.data![index].checkInTime!.string!)} - ${GeneralUtil.timeConvert(state.absenListResponseModel.data![index].checkOutTime!.string! == "" ? '00:00:00' : state.absenListResponseModel.data![index].checkOutTime!.string!)}',
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.35,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      const SizedBox(width: 18),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: const Center(
                                                              child: Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            color: Colors.white,
                                                            size: 16,
                                                          )),
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
                                      itemCount: state
                                          .absenListResponseModel.data!.length);
                            }
                            return GeneralUtil().loading3Data(3);
                          })),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Kendala Absensi',
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                              StringRouterUtil.kendalaAbsenScreenRoute);
                        },
                        child: Text('Selengkapnya',
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: GeneralUtil.fontSize(context) * 0.35,
                                color: primaryColor,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocListener(
                      bloc: listKendalaBloc,
                      listener: (_, kendala.ListState state) async {
                        if (state is kendala.ListLoading) {}
                        if (state is kendala.ListLoaded) {}
                        if (state is kendala.ListError) {}
                        if (state is kendala.ListException) {
                          GeneralUtil().showSnackBarError(context, state.error);
                        }
                      },
                      child: BlocBuilder(
                          bloc: listKendalaBloc,
                          builder: (_, kendala.ListState state) {
                            if (state is kendala.ListLoaded) {
                              return state.kendalaAbsenListResponseModel.data!
                                      .isEmpty
                                  ? Center(
                                      child: Text(
                                          'Data absen 3 hari terakhir belum tersedia',
                                          style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.35,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  : ListView.separated(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .kendalaAbsenDetailScreenRoute,
                                                arguments: state
                                                    .kendalaAbsenListResponseModel
                                                    .data![index]
                                                    .id);
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
                                                    color:
                                                        const Color(0xFFC2C2C2)
                                                            .withOpacity(0.1))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 16,
                                                      decoration: BoxDecoration(
                                                        color: state
                                                                    .kendalaAbsenListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .status! ==
                                                                'Disetujui'
                                                            ? greenColor
                                                            : state
                                                                        .kendalaAbsenListResponseModel
                                                                        .data![
                                                                            index]
                                                                        .status! ==
                                                                    'Ditolak'
                                                                ? redColor
                                                                : yellowColor,
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
                                                    ),
                                                    const SizedBox(width: 10),
                                                    SizedBox(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          FittedBox(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            child: Text(
                                                                GeneralUtil.monthCheck2(state
                                                                    .kendalaAbsenListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .createdAt!),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        GeneralUtil.fontSize(context) *
                                                                            0.35,
                                                                    color: const Color(
                                                                        0xFF797979),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                          ),
                                                          Text(
                                                              GeneralUtil.dateDayCheck(state
                                                                  .kendalaAbsenListResponseModel
                                                                  .data![index]
                                                                  .createdAt!),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.35,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 18),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              GeneralUtil.dayCheck(state
                                                                  .kendalaAbsenListResponseModel
                                                                  .data![index]
                                                                  .createdAt!),
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
                                                          Text(
                                                              state
                                                                  .kendalaAbsenListResponseModel
                                                                  .data![index]
                                                                  .description!,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      GeneralUtil.fontSize(
                                                                              context) *
                                                                          0.3,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.23,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('Status',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        GeneralUtil.fontSize(context) *
                                                                            0.35,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            Text(
                                                                state
                                                                    .kendalaAbsenListResponseModel
                                                                    .data![
                                                                        index]
                                                                    .status!,
                                                                style: TextStyle(
                                                                    fontSize: GeneralUtil.fontSize(context) * 0.3,
                                                                    color: state.kendalaAbsenListResponseModel.data![index].status! == 'Disetujui'
                                                                        ? greenColor
                                                                        : state.kendalaAbsenListResponseModel.data![index].status! == 'Ditolak'
                                                                            ? redColor
                                                                            : yellowColor,
                                                                    fontWeight: FontWeight.w400)),
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                            width: 24,
                                                            height: 24,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: const Center(
                                                                child: Icon(
                                                              Icons
                                                                  .remove_red_eye_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                      itemCount: state
                                                  .kendalaAbsenListResponseModel
                                                  .data!
                                                  .length <
                                              3
                                          ? state.kendalaAbsenListResponseModel
                                              .data!.length
                                          : 3);
                            }
                            return GeneralUtil().loading3Data(3);
                          })),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Acara Terdekat',
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      InkWell(
                        onTap: () {
                          var bottomBarProvider =
                              Provider.of<TabProvider>(context, listen: false);
                          bottomBarProvider.setPage(4);
                          bottomBarProvider.setTab(4);
                        },
                        child: Text('Selengkapnya',
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: GeneralUtil.fontSize(context) * 0.35,
                                color: primaryColor,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocListener(
                      bloc: acaraListBloc,
                      listener: (_, AcaraListState state) async {
                        if (state is AcaraListLoading) {}
                        if (state is AcaraListLoaded) {}
                        if (state is AcaraListError) {}
                        if (state is AcaraListException) {
                          GeneralUtil().showSnackBarError(context, state.error);
                        }
                      },
                      child: BlocBuilder(
                          bloc: acaraListBloc,
                          builder: (_, AcaraListState state) {
                            if (state is AcaraListLoaded) {
                              List<Data> listAcara =
                                  state.acaraListResponseModel.data!
                                      .where(
                                        (element) => element.status == true,
                                      )
                                      .toList();
                              return state.acaraListResponseModel.data!.isEmpty
                                  ? Center(
                                      child: Text(
                                          'Acara terdekat belum tersedia',
                                          style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.35,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  : ListView.separated(
                                      itemCount: listAcara.length,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10);
                                      },
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .aktifitasDetailScreenRoute,
                                                arguments: listAcara[index].id);
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
                                                    color:
                                                        const Color(0xFFC2C2C2)
                                                            .withOpacity(0.1))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                    color: listAcara[index]
                                                                .status ==
                                                            false
                                                        ? yellowColor
                                                        : greenColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text('0${index + 1}',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.35,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          listAcara[index]
                                                              .name!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.3,
                                                              color: const Color(
                                                                  0xFF797979),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      Text(
                                                          listAcara[index]
                                                              .address!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.3,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        GeneralUtil.dayConv(
                                                            listAcara[index]
                                                                .day!
                                                                .toString()),
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.3,
                                                            color: const Color(
                                                                0xFF797979),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    Text(
                                                        '${GeneralUtil.timeConvert(listAcara[index].startTime! == "" ? "00:00:00" : listAcara[index].startTime!)} - ${GeneralUtil.timeConvert(listAcara[index].endTime! == "" ? "00:00:00" : listAcara[index].endTime!)}',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.3,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ],
                                                ),
                                                Text(listAcara[index].kind!,
                                                    style: TextStyle(
                                                        fontSize:
                                                            GeneralUtil.fontSize(
                                                                    context) *
                                                                0.3,
                                                        color: const Color(
                                                            0xFF797979),
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16),
                                                  child: Text(
                                                      listAcara[index].status ==
                                                              false
                                                          ? 'Tidak Aktif'
                                                          : 'Aktif',
                                                      style: TextStyle(
                                                          fontSize: GeneralUtil
                                                                  .fontSize(
                                                                      context) *
                                                              0.35,
                                                          color: listAcara[
                                                                          index]
                                                                      .status ==
                                                                  false
                                                              ? yellowColor
                                                              : greenColor,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                            }
                            return GeneralUtil().loading3Data(3);
                          })),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Dinas Luar Terdekat',
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: GeneralUtil.fontSize(context) * 0.4,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      InkWell(
                        onTap: () {
                          var bottomBarProvider =
                              Provider.of<TabProvider>(context, listen: false);
                          bottomBarProvider.setPage(3);
                          bottomBarProvider.setTab(3);
                        },
                        child: Text('Selengkapnya',
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: GeneralUtil.fontSize(context) * 0.35,
                                color: primaryColor,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocListener(
                      bloc: dinasLuarListBloc,
                      listener: (_, DinasLuarListState state) async {
                        if (state is DinasLuarListLoading) {}
                        if (state is DinasLuarListLoaded) {}
                        if (state is DinasLuarListError) {}
                        if (state is DinasLuarListException) {
                          GeneralUtil().showSnackBarError(context, state.error);
                        }
                      },
                      child: BlocBuilder(
                          bloc: dinasLuarListBloc,
                          builder: (_, DinasLuarListState state) {
                            if (state is DinasLuarListLoaded) {
                              return state
                                      .dinasLuarListResponseModel.data!.isEmpty
                                  ? Center(
                                      child: Text(
                                          'Data dinas luar terdekat belum tersedia',
                                          style: TextStyle(
                                              backgroundColor: Colors.white,
                                              fontSize: GeneralUtil.fontSize(
                                                      context) *
                                                  0.35,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500)),
                                    )
                                  : ListView.separated(
                                      itemCount: state
                                          .dinasLuarListResponseModel
                                          .data!
                                          .length,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(height: 10);
                                      },
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context,
                                                StringRouterUtil
                                                    .dinasLuarDetailScreenRoute,
                                                arguments: state
                                                    .dinasLuarListResponseModel
                                                    .data![index]
                                                    .id);
                                          },
                                          child: Container(
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
                                                    color:
                                                        const Color(0xFFC2C2C2)
                                                            .withOpacity(0.1))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 35,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: state
                                                                .dinasLuarListResponseModel
                                                                .data![index]
                                                                .statusPengajuan ==
                                                            'Pending'
                                                        ? yellowColor
                                                        : greenColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      bottomLeft:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text('0${index + 1}',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.35,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.58,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          state
                                                              .dinasLuarListResponseModel
                                                              .data![index]
                                                              .name!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.35,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Text(
                                                          state
                                                              .dinasLuarListResponseModel
                                                              .data![index]
                                                              .address!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.3,
                                                              color: const Color(
                                                                  0xFF797979),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      Text(
                                                          '${GeneralUtil.dateConvert(state.dinasLuarListResponseModel.data![index].startDate!)} - ${GeneralUtil.dateConvert(state.dinasLuarListResponseModel.data![index].endDate!)}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.3,
                                                              color: const Color(
                                                                  0xFF797979),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          state
                                                              .dinasLuarListResponseModel
                                                              .data![index]
                                                              .statusPengajuan!,
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.3,
                                                              color: state
                                                                          .dinasLuarListResponseModel
                                                                          .data![
                                                                              index]
                                                                          .statusPengajuan ==
                                                                      'Pending'
                                                                  ? yellowColor
                                                                  : greenColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      const SizedBox(width: 8),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                            }
                            return GeneralUtil().loading3Data(3);
                          })),
                  const SizedBox(height: 24),
                  const WidgetTunjanganKerja()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
