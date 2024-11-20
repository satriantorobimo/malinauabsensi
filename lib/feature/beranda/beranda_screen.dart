import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/menu_item.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

import '../absensi/bloc/list_bloc/bloc.dart';
import '../absensi/data/absen_list_response_model.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  final List<String> items = [
    'Setting',
    'Logout',
  ];
  bool isLoading = true;
  ListBloc listBloc = ListBloc(absenRepo: AbsenRepo());
  List<Data> data = [];
  int selectedFilter = 0;

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
    Map<String, String> dateRange =
        GeneralUtil().getFormattedFirstAndLastDateOfLast3Days();
    listBloc.add(ListAttempt(
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
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    bottom: 100.0, top: 16, left: 16, right: 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Beranda',
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: GeneralUtil.fontSize(context) * 0.5,
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                            border: Border.all(
                                color:
                                    const Color(0xFFC2C2C2).withOpacity(0.2))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 6,
                              decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Tepat waktu',
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.35,
                                    color: const Color(0xFF797979),
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 12),
                            Text('20 hari',
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.4,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                            border: Border.all(
                                color:
                                    const Color(0xFFC2C2C2).withOpacity(0.2))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 6,
                              decoration: BoxDecoration(
                                color: redColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Telat',
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.35,
                                    color: const Color(0xFF797979),
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 12),
                            Text('2 hari',
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.4,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                            border: Border.all(
                                color:
                                    const Color(0xFFC2C2C2).withOpacity(0.2))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 6,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Jam kerja',
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.35,
                                    color: const Color(0xFF797979),
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 12),
                            Text('20 jam',
                                style: TextStyle(
                                    fontSize:
                                        GeneralUtil.fontSize(context) * 0.4,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Absensi',
                      style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: GeneralUtil.fontSize(context) * 0.4,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  BlocListener(
                      bloc: listBloc,
                      listener: (_, ListState state) async {
                        if (state is ListLoading) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        if (state is ListLoaded) {
                          setState(() {
                            isLoading = false;
                            data.addAll(state.absenListResponseModel.data!);
                          });
                        }
                        if (state is ListError) {
                          GeneralUtil()
                              .showSnackBarError(context, state.error!);
                          setState(() {
                            isLoading = false;
                          });
                        }
                        if (state is ListException) {
                          setState(() {
                            isLoading = false;
                          });
                          _expDialog(context);
                        }
                      },
                      child: BlocBuilder(
                          bloc: listBloc,
                          builder: (_, ListState state) {
                            return isLoading
                                ? const Center(
                                    child: SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: CircularProgressIndicator(),
                                    ),
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
                                              arguments: data[index].id);
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
                                                  offset: const Offset(
                                                      -6, 4), // Shadow position
                                                ),
                                              ],
                                              border: Border.all(
                                                  color: const Color(0xFFC2C2C2)
                                                      .withOpacity(0.1))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 16,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          data[index].status! ==
                                                                  'Masuk'
                                                              ? greenColor
                                                              : redColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(6),
                                                        bottomLeft:
                                                            Radius.circular(6),
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
                                                            GeneralUtil
                                                                .monthCheck2(data[
                                                                        index]
                                                                    .createdAt!),
                                                            style: TextStyle(
                                                                fontSize: GeneralUtil
                                                                        .fontSize(
                                                                            context) *
                                                                    0.4,
                                                                color: const Color(
                                                                    0xFF797979),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      ),
                                                      Text(
                                                          GeneralUtil
                                                              .dateDayCheck(data[
                                                                      index]
                                                                  .createdAt!),
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.4,
                                                              color:
                                                                  Colors.black,
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
                                                          GeneralUtil.dayCheck(
                                                              data[index]
                                                                  .createdAt!),
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.4,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Text(data[index].status!,
                                                          style: TextStyle(
                                                              fontSize: GeneralUtil
                                                                      .fontSize(
                                                                          context) *
                                                                  0.35,
                                                              color: data[index]
                                                                          .status! ==
                                                                      'Masuk'
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
                                                padding: const EdgeInsets.only(
                                                    right: 16.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        '${data[index].checkInTime!.string} - ${data[index].checkOutTime!.string}',
                                                        style: TextStyle(
                                                            fontSize: GeneralUtil
                                                                    .fontSize(
                                                                        context) *
                                                                0.4,
                                                            color: Colors.black,
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
                                                                  .circular(4),
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
                                    itemCount: data.length);
                          })),
                  const SizedBox(height: 16),
                  Text('Acara',
                      style: TextStyle(
                          backgroundColor: Colors.white,
                          fontSize: GeneralUtil.fontSize(context) * 0.4,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                              StringRouterUtil.aktifitasDetailScreenRoute);
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
                                  offset:
                                      const Offset(-6, 4), // Shadow position
                                ),
                              ],
                              border: Border.all(
                                  color: const Color(0xFFC2C2C2)
                                      .withOpacity(0.1))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 35,
                                decoration: const BoxDecoration(
                                  color: yellowColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                  ),
                                ),
                                child: Center(
                                  child: Text('01',
                                      style: TextStyle(
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.4,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Judul',
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.3,
                                            color: const Color(0xFF797979),
                                            fontWeight: FontWeight.w400)),
                                    Text('Alamat',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                GeneralUtil.fontSize(context) *
                                                    0.35,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Senin',
                                      style: TextStyle(
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.3,
                                          color: const Color(0xFF797979),
                                          fontWeight: FontWeight.w400)),
                                  Text('09:00 - 18:00',
                                      style: TextStyle(
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.35,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Text('Upacara',
                                  style: TextStyle(
                                      fontSize:
                                          GeneralUtil.fontSize(context) * 0.3,
                                      color: const Color(0xFF797979),
                                      fontWeight: FontWeight.w400)),
                              Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: SizedBox(
                                  width: 60,
                                  child: Text('Pending',
                                      style: TextStyle(
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.35,
                                          color: yellowColor,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
