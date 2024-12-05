import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/login/domain/login_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shimmer/shimmer.dart';
import '../login/bloc/user_detail_bloc/bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<String> items = [
    'Setting',
    'Logout',
  ];
  UserDetailBloc userDetailBloc = UserDetailBloc(loginRepo: LoginRepo());
  String version = '';
  bool isLoadingData = true;
  late String name;
  late String role;

  @override
  void initState() {
    super.initState();
    _getVersion();
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

  void _getVersion() {
    // final package = AppInfo.of(context).package;
    // setState(() {
    //   version = '${package.version} - ${package.buildNumber}';
    // });
    userDetailBloc.add(UserDetailAttempt());
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
                    child: Text('Profile',
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
              padding: const EdgeInsets.only(
                  top: 40.0, left: 16, right: 16.0, bottom: 32.0),
              children: [
                BlocListener(
                    bloc: userDetailBloc,
                    listener: (_, UserDetailState state) async {
                      if (state is UserDetailLoading) {}
                      if (state is UserDetailLoaded) {}
                      if (state is UserDetailError) {
                        if (state.error! == 'Token is expired') {
                          _expDialog(context);
                        } else {
                          GeneralUtil()
                              .showSnackBarError(context, state.error!);
                        }
                      }
                      if (state is UserDetailException) {
                        GeneralUtil().showSnackBarError(context, state.error);
                      }
                    },
                    child: BlocBuilder(
                        bloc: userDetailBloc,
                        builder: (_, UserDetailState state) {
                          if (state is UserDetailLoaded) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
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
                                    Text('Nama Lengkap',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            state.userDetailResponseModel.data!
                                                .userName!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Email',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            state.userDetailResponseModel.data!
                                                .userEmail!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Tahun Kelahiran',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            state.userDetailResponseModel.data!
                                                .userBirthdate!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('NIK',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            state.userDetailResponseModel.data!
                                                .userNik!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('NIP',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            state.userDetailResponseModel.data!
                                                .userNip!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Role',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            state.userDetailResponseModel.data!
                                                .roleName!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Eselon',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                            state.userDetailResponseModel.data!
                                                .eselonName!,
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text('Versi Aplikasi',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
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
                                        child: Text('1.0.0',
                                            style: TextStyle(
                                                fontSize: GeneralUtil.fontSize(
                                                        context) *
                                                    0.35,
                                                color: const Color(0xFFBBBBBB),
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ]),
                            );
                          }
                          return const Center(
                            child: SizedBox(
                              width: 35,
                              height: 35,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        })),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
