import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/bloc/detail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/kendala_absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/domain/kendala_absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class KendalaAbsenDetailScreen extends StatefulWidget {
  const KendalaAbsenDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<KendalaAbsenDetailScreen> createState() =>
      _KendalaAbsenDetailScreenState();
}

class _KendalaAbsenDetailScreenState extends State<KendalaAbsenDetailScreen> {
  final FocusNode _focus = FocusNode();
  bool isLoading = true;
  bool isEdit = false;
  bool isLoadingData = true;
  late String name;
  late String role;

  DetailBloc detailBloc = DetailBloc(kendalaAbsenRepo: KendalaAbsenRepo());

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    detailBloc.add(KendalaDetailAttempt(id: widget.id));
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

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
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
                    child: Text('Kendala Absensi Detail',
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
                bloc: detailBloc,
                listener: (_, DetailState state) async {
                  if (state is DetailLoading) {}
                  if (state is DetailLoaded) {}
                  if (state is DetailError) {
                    if (state.error! == 'Token is expired') {
                      _expDialog(context);
                    } else {
                      GeneralUtil().showSnackBarError(context, state.error!);
                    }
                  }
                  if (state is DetailException) {
                    GeneralUtil().showSnackBarError(context, state.error);
                  }
                },
                child: BlocBuilder(
                    bloc: detailBloc,
                    builder: (_, DetailState state) {
                      if (state is DetailLoaded) {
                        return mainContent(
                            state.kendalaAbsenDetailResponseModel);
                      }
                      return const Center(
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }

  Widget mainContent(KendalaAbsenDetailResponseModel data) {
    return Expanded(
        child: ListView(
      shrinkWrap: true,
      children: [
        Padding(
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
                  border: Border.all(
                      color: const Color(0xFFC2C2C2).withOpacity(0.1))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tanggal Izin',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Text(GeneralUtil.convertDate(data.data!.createdAt!),
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.45,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    Text('Keterangan',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Text(data.data!.description!,
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.45,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    Text('Bukti gambar',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        color: const Color(0xFF797979),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Status',
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.35,
                            color: const Color(0xFF797979),
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Text(data.status!,
                        style: TextStyle(
                            fontSize: GeneralUtil.fontSize(context) * 0.45,
                            color: data.status! == 'Disetujui'
                                ? greenColor
                                : data.status! == 'Ditolak'
                                    ? redColor
                                    : yellowColor,
                            fontWeight: FontWeight.w500)),
                  ]),
            )),
      ],
    ));
  }
}
