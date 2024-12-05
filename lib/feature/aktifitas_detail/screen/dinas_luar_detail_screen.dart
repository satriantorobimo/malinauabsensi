import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/feature/aktifitas/bloc/dinas_luar_detail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_detail_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/domain/aktifitas_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/maps_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class DinasLuarDetailScreen extends StatefulWidget {
  const DinasLuarDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<DinasLuarDetailScreen> createState() => _DinasLuarDetailScreenState();
}

class _DinasLuarDetailScreenState extends State<DinasLuarDetailScreen> {
  String? selectedValue;
  final List<String> items = [
    'Setting',
    'Logout',
  ];
  bool isLoading = true;
  DinasLuarDetailBloc dinasLuarDetailBloc =
      DinasLuarDetailBloc(aktifitasARepo: AktifitasARepo());
  Data data = Data();
  bool isLoadingData = true;
  late String name;
  late String role;

  @override
  void initState() {
    dinasLuarDetailBloc.add(DinasLuarDetailAttempt(id: widget.id));
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
                    child: Text('Detail Dinas Luar',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                  ),
                  Container()
                ],
              ),
            ),
            BlocListener(
                bloc: dinasLuarDetailBloc,
                listener: (_, DinasLuarDetailState state) async {
                  if (state is DinasLuarDetailLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  if (state is DinasLuarDetailLoaded) {
                    setState(() {
                      isLoading = false;
                      data = state.dinasLuarDetailResponseModel.data!;
                    });
                  }
                  if (state is DinasLuarDetailError) {
                    setState(() {
                      isLoading = false;
                    });
                    if (state.error! == 'Token is expired') {
                      _expDialog(context);
                    } else {
                      GeneralUtil().showSnackBarError(context, state.error!);
                    }
                  }
                  if (state is DinasLuarDetailException) {
                    setState(() {
                      isLoading = false;
                    });
                    GeneralUtil().showSnackBarError(context, state.error);
                  }
                },
                child: BlocBuilder(
                    bloc: dinasLuarDetailBloc,
                    builder: (_, DinasLuarDetailState state) {
                      return isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 45,
                                height: 45,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : content();
                    })),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Padding(
        padding: const EdgeInsets.only(
            top: 40.0, left: 16, right: 16.0, bottom: 32.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
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
              border:
                  Border.all(color: const Color(0xFFC2C2C2).withOpacity(0.1))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Judul',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.35,
                    color: const Color(0xFF797979),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(data.name!,
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.4,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Text('Deskripsi',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.35,
                    color: const Color(0xFF797979),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(data.description!,
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.4,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Text('Alamat',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.35,
                    color: const Color(0xFF797979),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(data.address!,
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.4,
                          color: Colors.black,
                          overflow: TextOverflow.fade,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    MapUtil.openMap(data.location!.lat!.toDouble(),
                        data.location!.long!.toDouble());
                  },
                  child: const Icon(
                    Icons.pin_drop_rounded,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text('Tanggal Mulai - Tanggal Akhir',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.35,
                    color: const Color(0xFF797979),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(
                '${GeneralUtil.dateConvert(data.startDate!)} - ${GeneralUtil.dateConvert(data.endDate!)}',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.4,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Text('File Penduking',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.35,
                    color: const Color(0xFF797979),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(data.fileName ?? '-',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.4,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Text('Status',
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.35,
                    color: const Color(0xFF797979),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(data.statusPengajuan!,
                style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.4,
                    color: data.statusPengajuan == 'Pending'
                        ? yellowColor
                        : greenColor,
                    fontWeight: FontWeight.w500)),
          ]),
        ));
  }
}
