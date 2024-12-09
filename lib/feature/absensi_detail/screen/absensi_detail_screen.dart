import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/bloc/detail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/bloc/update_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/update_absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';

class AbsesnsiDetailScreen extends StatefulWidget {
  const AbsesnsiDetailScreen({super.key, required this.id});
  final String id;

  @override
  State<AbsesnsiDetailScreen> createState() => _AbsesnsiDetailScreenState();
}

class _AbsesnsiDetailScreenState extends State<AbsesnsiDetailScreen> {
  final FocusNode _focus = FocusNode();
  bool isLoading = true;
  final List<String> items = [
    'Setting',
    'Logout',
  ];
  bool isEdit = false;
  Data data = Data();
  bool isLoadingData = true;
  late String name;
  late String role;

  final TextEditingController _keteranganController = TextEditingController();

  DetailBloc detailBloc = DetailBloc(absenRepo: AbsenRepo());
  UpdateBloc updateBloc = UpdateBloc(absenRepo: AbsenRepo());

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    detailBloc.add(DetailAttempt(id: widget.id));
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
        body: SingleChildScrollView(
          child: Column(
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
                                          borderRadius:
                                              BorderRadius.circular(2),
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
                                          borderRadius:
                                              BorderRadius.circular(2),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
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
              BlocListener(
                  bloc: detailBloc,
                  listener: (_, DetailState state) async {
                    if (state is DetailLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                    if (state is DetailLoaded) {
                      setState(() {
                        isLoading = false;
                        data = state.absenDetailResponseModel.data!;
                        _keteranganController.text = data.activity!;
                        isEdit = false;
                      });
                    }
                    if (state is DetailError) {
                      setState(() {
                        isLoading = false;
                      });
                      if (state.error! == 'Token is expired') {
                        _expDialog(context);
                      } else {
                        GeneralUtil().showSnackBarError(context, state.error!);
                      }
                    }
                    if (state is DetailException) {
                      setState(() {
                        isLoading = false;
                      });
                      GeneralUtil().showSnackBarError(context, state.error);
                    }
                  },
                  child: BlocBuilder(
                      bloc: detailBloc,
                      builder: (_, DetailState state) {
                        return isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : mainContent();
                      })),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainContent() {
    return Column(
      children: [
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
                child: Text(GeneralUtil.dateConvertDetail(data.createdAt!),
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
          padding: const EdgeInsets.only(
              top: 40.0, left: 16, right: 16.0, bottom: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/timer.svg',
                    colorFilter:
                        const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    height: 40,
                    width: 40,
                  ),
                  Text(data.checkInTimestamp!,
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  Text('Absen Datang',
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.35,
                          color: const Color(0xFF797979),
                          fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/timer.svg',
                    colorFilter:
                        const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    height: 40,
                    width: 40,
                  ),
                  Text(data.checkOutTimestamp!,
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  Text('Absen Pulang',
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.35,
                          color: const Color(0xFF797979),
                          fontWeight: FontWeight.w400)),
                ],
              ),
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/icons/timer.svg',
                    colorFilter:
                        const ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    height: 40,
                    width: 40,
                  ),
                  Text(data.workingHourCount.toString(),
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  Text('Jam Kerja',
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.35,
                          color: const Color(0xFF797979),
                          fontWeight: FontWeight.w400)),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Keterangan aktifitas hari ini',
                      style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.4,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isEdit = !isEdit;
                        if (!isEdit) {
                          _focus.unfocus();
                        } else {
                          _focus.requestFocus();
                        }
                      });
                    },
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/edit.svg',
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          height: 12,
                          width: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        width: 1.0,
                        color:
                            isEdit ? const Color(0xFF9E9E9E) : Colors.white)),
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _keteranganController,
                  maxLines: 5,
                  focusNode: _focus,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: GeneralUtil.fontSize(context) * 0.45,
                  ),
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
              const SizedBox(height: 16),
              BlocListener(
                  bloc: updateBloc,
                  listener: (_, UpdateState state) async {
                    if (state is UpdateLoading) {}
                    if (state is UpdateLoaded) {
                      setState(() {
                        isEdit = !isEdit;
                        GeneralUtil().showSnackBarSuccess(
                            context, 'Keterangan berhasil disimpan');
                      });
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
                                          userID: widget.id)));
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
                          onTap: !isEdit
                              ? null
                              : () {
                                  DateTime now = DateTime.now();
                                  String formatedDate =
                                      DateFormat('dd-MM-yyyy').format(now);
                                  updateBloc.add(UpdateAttempt(
                                      updateAbsenRequestModel:
                                          UpdateAbsenRequestModel(
                                              requestDate: formatedDate,
                                              keterangan:
                                                  _keteranganController.text,
                                              userID: widget.id)));
                                },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: isEdit ? primaryColor : Colors.grey,
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
          ),
        )
      ],
    );
  }
}
