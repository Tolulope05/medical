import 'package:get/get.dart';
import 'package:dromedic_health/src/_route/routes.dart';
import 'package:dromedic_health/src/servers/repository.dart';
import 'package:dromedic_health/src/utils/app_tags.dart';
import 'package:dromedic_health/src/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:dromedic_health/src/widgets/button_widget.dart';

import '../../widgets/loader/loader_widget.dart';
import '../../widgets/login_edit_textform_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var currentPassController = TextEditingController();
  var newPassController = TextEditingController();
  var confirmPassController = TextEditingController();
  bool _isVisibleA = true;
  bool _isVisibleB = true;
  bool _isVisibleC = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          AppTags.changePassword.tr,
          style: AppThemeData.headerTextStyle_16,
        ),
      ),
      body: isLoading
          ? const LoaderWidget()
          : SizedBox(
              height: size.height,
              width: size.width,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      LoginEditTextField(
                        myController: currentPassController,
                        keyboardType: TextInputType.text,
                        hintText: AppTags.currentPassword.tr,
                        fieldIcon: Icons.lock,
                        myobscureText: _isVisibleA,
                        sufficon: InkWell(
                          onTap: () {
                            setState(() {
                              _isVisibleA = !_isVisibleA;
                            });
                          },
                          child: Icon(
                            _isVisibleA
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF666666),
                            //size: defaultIconSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      LoginEditTextField(
                        myController: newPassController,
                        keyboardType: TextInputType.text,
                        hintText: AppTags.newPassword.tr,
                        fieldIcon: Icons.lock,
                        myobscureText: _isVisibleB,
                        sufficon: InkWell(
                          onTap: () {
                            setState(() {
                              _isVisibleB = !_isVisibleB;
                            });
                          },
                          child: Icon(
                            _isVisibleB
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF666666),
                            //size: defaultIconSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      LoginEditTextField(
                        myController: confirmPassController,
                        keyboardType: TextInputType.text,
                        hintText: AppTags.confirmNewPassword.tr,
                        fieldIcon: Icons.lock,
                        myobscureText: _isVisibleC,
                        sufficon: InkWell(
                          onTap: () {
                            setState(() {
                              _isVisibleC = !_isVisibleC;
                            });
                          },
                          child: Icon(
                            _isVisibleC
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF666666),
                            //size: defaultIconSize,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await Repository()
                                .postChangePassword(
                                    currentPass: currentPassController.text,
                                    newPass: newPassController.text,
                                    confirmPass: confirmPassController.text)
                                .then((value) {
                              if (value) {
                                Get.toNamed(Routes.dashboardScreen);
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                          },
                          child: ButtonWidget(
                              buttonTittle: AppTags.saveAndChange.tr),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
