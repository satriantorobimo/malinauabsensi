import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/feature/laporan/bloc/tunjangan_kerja_bloc/bloc.dart';
import 'package:malinau_absensi/feature/laporan/domain/tunjangan_kinerja_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_list_response_model.dart'
    as tunj;
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

class WidgetTunjanganKerja extends StatefulWidget {
  const WidgetTunjanganKerja({super.key});

  @override
  State<WidgetTunjanganKerja> createState() => _WidgetTunjanganKerjaState();
}

class _WidgetTunjanganKerjaState extends State<WidgetTunjanganKerja> {
  bool isLoadingTunj = true;
  TunjanganKerjaBloc tunjanganKerjaBloc =
      TunjanganKerjaBloc(tunjanganKinerjaRepo: TunjanganKinerjaRepo());
  List<tunj.Data> dataListTunj = [];
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
    tunjanganKerjaBloc.add(TunjanganKerjaListAttempt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tunjangan yang sudah dicapai',
            style: TextStyle(
                backgroundColor: Colors.white,
                fontSize: GeneralUtil.fontSize(context) * 0.4,
                color: Colors.black,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        MultiBlocListener(
          listeners: [
            BlocListener(
                bloc: tunjanganKerjaBloc,
                listener: (_, TunjanganKerjaState state) async {
                  if (state is TunjanganKerjaLoading) {}
                  if (state is TunjanganKerjaListLoaded) {
                    setState(() {
                      isLoadingTunj = false;
                      dataListTunj
                          .addAll(state.tunjanganKinerjaListResponseModel);
                    });
                  }

                  if (state is TunjanganKerjaError) {
                    setState(() {
                      isLoadingTunj = false;
                    });
                    if (state.error! == 'Token is expired') {
                      _expDialog(context);
                    } else {
                      GeneralUtil().showSnackBarError(context, state.error!);
                    }
                  }
                  if (state is TunjanganKerjaException) {
                    setState(() {
                      isLoadingTunj = false;
                    });
                    if (state.error == 'Token is expired') {
                      _expDialog(context);
                    } else {
                      GeneralUtil().showSnackBarError(context, state.error);
                    }
                  }
                }),
          ],
          child: isLoadingTunj
              ? GeneralUtil().loadingRow(context)
              : dataListTunj.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Periode',
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.25,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                  Text(dataListTunj[index].periode ?? '-',
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.3,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tunjangan Pokok',
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.25,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      GeneralUtil.convertToIdr(
                                          dataListTunj[index].tunjanganPokok!,
                                          0),
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.3,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Total Tunjangan (${dataListTunj[index].tunjanganTotalPersen!}%)',
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.25,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      GeneralUtil.convertToIdr(
                                          dataListTunj[index].tunjanganTotalRp!,
                                          0),
                                      style: TextStyle(
                                          backgroundColor: Colors.white,
                                          fontSize:
                                              GeneralUtil.fontSize(context) *
                                                  0.3,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context,
                                      StringRouterUtil
                                          .tunjanganDetailScreenRoute,
                                      arguments:
                                          dataListTunj[index].id.toString());
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Center(
                                      child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                      itemCount: dataListTunj.length)
                  : Center(
                      child: Text('Data tunjangan belum tersedia',
                          style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: GeneralUtil.fontSize(context) * 0.35,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500)),
                    ),
        ),
      ],
    );
  }
}
