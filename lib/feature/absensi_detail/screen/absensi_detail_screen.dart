import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/bloc/detail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

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

  final TextEditingController _keteranganController = TextEditingController();

  DetailBloc detailBloc = DetailBloc(absenRepo: AbsenRepo());

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    detailBloc.add(DetailAttempt(id: widget.id));
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<String?>(
                              future: SharedPrefUtil.getSharedString(
                                  'nama'), // Key for retrieval
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  final username =
                                      snapshot.data ?? "No name found";
                                  return Text('Hi, $username',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500));
                                }
                              },
                            ),
                            const SizedBox(height: 2),
                            FutureBuilder<String?>(
                              future: SharedPrefUtil.getSharedString(
                                  'role'), // Key for retrieval
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  final role = snapshot.data ?? "No role found";
                                  return Text(role,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF797979),
                                          fontWeight: FontWeight.w400));
                                }
                              },
                            ),
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
                    });
                  }
                  if (state is DetailError) {
                    GeneralUtil().showSnackBarError(context, state.error!);
                    setState(() {
                      isLoading = false;
                    });
                  }
                  if (state is DetailException) {
                    GeneralUtil().showSnackBarError(context, state.error);
                    setState(() {
                      isLoading = false;
                    });
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
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: primaryColor,
                size: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(GeneralUtil.dateConvertDetail(data.createdAt!),
                    style: const TextStyle(
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
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  const Text('Absen Datang',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF797979),
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
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  const Text('Absen Pulang',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF797979),
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
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  const Text('Jam Kerja',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF797979),
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
                  const Text('Keterangan aktifitas hari ini',
                      style: TextStyle(
                          fontSize: 16,
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
                        child: isEdit
                            ? const Icon(Icons.check,
                                size: 12, color: Colors.white)
                            : SvgPicture.asset(
                                'assets/icons/edit.svg',
                                colorFilter: const ColorFilter.mode(
                                    primaryColor, BlendMode.srcIn),
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
                  maxLines: 8,
                  focusNode: _focus,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(
                      hintText: 'Tulis keterangan aktifitas anda disini',
                      isDense: true,
                      contentPadding: const EdgeInsets.all(16),
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
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
            ],
          ),
        )
      ],
    );
  }
}
