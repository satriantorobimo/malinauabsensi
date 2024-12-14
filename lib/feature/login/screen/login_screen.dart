import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/feature/login/bloc/user_detail_bloc/bloc.dart';
import 'package:malinau_absensi/feature/login/data/login_request_model.dart';
import 'package:malinau_absensi/feature/login/domain/login_repo.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/login_bloc/bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isNik = false;
  bool isLoading = false;
  final TextEditingController _nipCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  LoginBloc loginBloc = LoginBloc(loginRepo: LoginRepo());
  UserDetailBloc userDetailBloc = UserDetailBloc(loginRepo: LoginRepo());
  @override
  void initState() {
    GeneralUtil().storeDeviceId();
    super.initState();
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
                padding: const EdgeInsets.only(bottom: 18),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/imgs/header.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(),
                      Image.asset(
                        'assets/imgs/logo.png',
                        width: 60,
                      ),
                      const Column(
                        children: [
                          Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Silahkan masukan informasi dibawah untuk masuk',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    isNik
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFF9E9E9E))),
                                child: TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Masukan email anda',
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
                    isNik
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NIP',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                        width: 1.0, color: Color(0xFF9E9E9E))),
                                child: TextFormField(
                                  controller: _nipCtrl,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Masukan NIP anda',
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
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kata sandi',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xFF9E9E9E))),
                          child: TextFormField(
                            controller: _passwordCtrl,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Masukan kata sandi',
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isNik = !isNik;
                            });
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              isNik ? 'Masuk dengan Email' : 'Masuk dengan NIP',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            GeneralUtil().showSnackBarWarning(context,
                                'Harap menghubungi admin untuk melakukan reset password');
                          },
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Lupa Password',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    MultiBlocListener(
                        listeners: [
                          BlocListener(
                              bloc: loginBloc,
                              listener: (_, LoginState state) async {
                                if (state is LoginLoading) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                                if (state is LoginLoaded) {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  GeneralUtil()
                                      .saveMenuActionsToSharedPreferences(state
                                          .loginResponseModel
                                          .data!
                                          .menuActions!);
                                  if (_emailCtrl.text
                                      .toLowerCase()
                                      .contains('staff')) {
                                    prefs.setString('user', 'staff');
                                  } else {
                                    prefs.setString('user', 'kadiv');
                                  }
                                  prefs.setString('token',
                                      state.loginResponseModel.data!.token!);
                                  prefs.setString('userid',
                                      state.loginResponseModel.data!.userId!);
                                  userDetailBloc.add(UserDetailAttempt());
                                }
                                if (state is LoginError) {
                                  GeneralUtil()
                                      .showSnackBarError(context, state.error!);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                if (state is LoginException) {
                                  GeneralUtil()
                                      .showSnackBarError(context, state.error);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }),
                          BlocListener(
                              bloc: userDetailBloc,
                              listener: (_, UserDetailState state) {
                                if (state is UserDetailLoading) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                                if (state is UserDetailLoaded) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  SharedPrefUtil.saveSharedString(
                                      'nama',
                                      state.userDetailResponseModel.data!
                                          .userName!);

                                  SharedPrefUtil.saveSharedString(
                                      'role',
                                      state.userDetailResponseModel.data!
                                          .roleName!);

                                  if (!context.mounted) return;
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      StringRouterUtil.tabScreenRoute,
                                      (route) => false);
                                }
                                if (state is UserDetailError) {
                                  GeneralUtil()
                                      .showSnackBarError(context, state.error!);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                                if (state is UserDetailException) {
                                  GeneralUtil()
                                      .showSnackBarError(context, state.error);
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }),
                        ],
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (!isNik) {
                                    if (_emailCtrl.text.isEmpty ||
                                        _emailCtrl.text == '' ||
                                        _passwordCtrl.text.isEmpty ||
                                        _passwordCtrl.text == '') {
                                      GeneralUtil().showSnackBarError(context,
                                          'Email dan Password tidak boleh kosong');
                                    } else {
                                      loginBloc.add(LoginAttempt(
                                          loginRequestModel: LoginRequestModel(
                                              isNip: false,
                                              email: _emailCtrl.text,
                                              nip: _nipCtrl.text,
                                              password: _passwordCtrl.text)));
                                    }
                                  } else {
                                    if (_nipCtrl.text.isEmpty ||
                                        _nipCtrl.text == '' ||
                                        _passwordCtrl.text.isEmpty ||
                                        _passwordCtrl.text == '') {
                                      GeneralUtil().showSnackBarError(context,
                                          'NIP dan Password tidak boleh kosong');
                                    } else {
                                      loginBloc.add(LoginAttempt(
                                          loginRequestModel: LoginRequestModel(
                                              isNip: true,
                                              email: _emailCtrl.text,
                                              nip: _nipCtrl.text,
                                              password: _passwordCtrl.text)));
                                    }
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                      child: Text('Masuk',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600))),
                                ),
                              )),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF8F8FB),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(-6, 4), // Shadow position
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFC2C2C2))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/imgs/google.png', width: 22),
                            const SizedBox(width: 8),
                            const Text('Continue with Google',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
