import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dromedic_health/src/widgets/button_widget.dart';

import '../../servers/repository.dart';
import '../../utils/app_tags.dart';
import '../../utils/app_theme_data.dart';
import '../../widgets/login_edit_textform_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          centerTitle: true,
          title: Text(
            AppTags.forgotPasswordText.tr,
            style: AppThemeData.headerTextStyle_16,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            LoginEditTextField(
              myController: emailController,
              keyboardType: TextInputType.text,
              hintText: AppTags.emailAddress.tr,
              fieldIcon: Icons.email,
              myobscureText: false,
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: InkWell(
                onTap: () async {
                  await Repository()
                      .postForgetPasswordGetData(email: emailController.text);
                },
                child: ButtonWidget(buttonTittle: AppTags.send.tr),
              ),
            ),
          ],
        ));
  }
}
