import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/feature/beranda/beranda_screen.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:shimmer/shimmer.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as chart;

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  int selectedFilter = 0;

  final List<String> items = [
    'Setting',
    'Logout',
  ];
  bool isLoadingData = true;
  late String name;
  late String role;
  List<String> filter = ['7 hari terakhir', 'Bulan ini', '3 Bulan Terakhir'];

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
        id: 'Weekly',
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        fillColorFn: (OrdinalSales ordinalSales, _) =>
            chart.ColorUtil.fromDartColor(primaryColor),
      )
    ];
  }

  static List<chart.Series<OrdinalSales, String>> _createSampleData2() {
    final data = [
      OrdinalSales('Week 1', 75),
      OrdinalSales('Week 2', 30),
      OrdinalSales('Week 3', 100),
      OrdinalSales('Week 4', 100),
    ];

    return [
      chart.Series<OrdinalSales, String>(
        id: 'Monthly',
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        fillColorFn: (OrdinalSales ordinalSales, _) =>
            chart.ColorUtil.fromDartColor(primaryColor),
      )
    ];
  }

  static List<chart.Series<OrdinalSales, String>> _createSampleData3() {
    final data = [
      OrdinalSales('Oct', 80),
      OrdinalSales('Nov', 100),
      OrdinalSales('Dec', 5),
    ];

    return [
      chart.Series<OrdinalSales, String>(
        id: '3 Monthly',
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
        fillColorFn: (OrdinalSales ordinalSales, _) =>
            chart.ColorUtil.fromDartColor(primaryColor),
      )
    ];
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
                              height: 40,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              offset: const Offset(-140, -30),
                            ),
                            items: items
                                .map((String item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Center(
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ))
                                .toList(),
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
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text('Laporan',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                  ),
                  Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.055,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
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
                            // if (index == 0) {
                            //   acaraListBloc.add(const AcaraListAttempt(
                            //       start: '', end: ''));
                            // } else if (index == 1) {
                            //   Map<String, String> dateRange = GeneralUtil()
                            //       .getFormattedFirstAndLastDateOfLastSevenDays();
                            //   acaraListBloc.add(AcaraListAttempt(
                            //       start: dateRange['firstDate']!,
                            //       end: dateRange['lastDate']!));
                            // } else if (index == 2) {
                            //   Map<String, String> dateRange = GeneralUtil()
                            //       .getFormattedFirstAndLastDateOfCurrentMonth();
                            //   acaraListBloc.add(AcaraListAttempt(
                            //       start: dateRange['firstDate']!,
                            //       end: dateRange['lastDate']!));
                            // } else {
                            //   Map<String, String> dateRange = GeneralUtil()
                            //       .getFormattedFirstAndLastDateOfLastThreeMonths();
                            //   acaraListBloc.add(AcaraListAttempt(
                            //       start: dateRange['firstDate']!,
                            //       end: dateRange['lastDate']!));
                            // }
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rp 4.000.000',
                      style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: GeneralUtil.fontSize(context) * 0.7,
                          color: Colors.black,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: chart.BarChart(
                        selectedFilter == 0
                            ? _createSampleData()
                            : selectedFilter == 1
                                ? _createSampleData2()
                                : _createSampleData3(),
                        animate: false,
                        defaultInteractions: true,
                        defaultRenderer: chart.BarLaneRendererConfig(
                            cornerStrategy: const chart.ConstCornerStrategy(8)),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
