import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:dromedic_health/src/screen/auth_screen/login_screen.dart';
import 'package:dromedic_health/src/servers/repository.dart';
import 'package:dromedic_health/src/utils/app_tags.dart';
import 'package:dromedic_health/src/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:dromedic_health/src/widgets/button_widget.dart';

import '../../widgets/login_edit_textform_field.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({Key? key, this.email, this.code})
      : super(key: key);
  final String? email;
  final String? code;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPassController = TextEditingController();
  bool _isVisibleB = true;
  bool _isVisibleC = true;

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
          AppTags.setPassword.tr,
          style: AppThemeData.headerTextStyle_16,
        ),
      ),
      body: SizedBox(
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
                  isReadonly: true,
                  myController: emailController,
                  keyboardType: TextInputType.text,
                  hintText: widget.email,
                  fieldIcon: Icons.email,
                  myobscureText: false,
                ),
                const SizedBox(
                  height: 5,
                ),
                LoginEditTextField(
                  myController: passwordController,
                  keyboardType: TextInputType.text,
                  hintText: AppTags.password.tr,
                  fieldIcon: Icons.lock,
                  myobscureText: _isVisibleB,
                  sufficon: InkWell(
                    onTap: () {
                      setState(() {
                        _isVisibleB = !_isVisibleB;
                      });
                    },
                    child: Icon(
                      _isVisibleB ? Icons.visibility_off : Icons.visibility,
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
                  hintText: AppTags.confirmPassword.tr,
                  fieldIcon: Icons.lock,
                  myobscureText: _isVisibleC,
                  sufficon: InkWell(
                    onTap: () {
                      setState(() {
                        _isVisibleC = !_isVisibleC;
                      });
                    },
                    child: Icon(
                      _isVisibleC ? Icons.visibility_off : Icons.visibility,
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
                      await Repository()
                          .postForgetPassword(
                              code: widget.code,
                              email: widget.email,
                              password: passwordController.text,
                              confirmPassword: confirmPassController.text)
                          .then((value) => LoginScreen());
                      setState(() {});
                    },
                    child: ButtonWidget(buttonTittle: AppTags.saveAndChange.tr),
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
