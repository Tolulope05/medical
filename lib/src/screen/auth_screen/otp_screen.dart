import 'package:dromedic_health/src/servers/repository.dart';
import 'package:dromedic_health/src/utils/app_tags.dart';
import 'package:dromedic_health/src/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({Key? key, this.phoneNumber, this.screen}) : super(key: key);
  final TextEditingController otpController = TextEditingController();
  final String? phoneNumber;
  final String? screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          AppTags.verifyNumber.tr,
          style: AppThemeData.headerTextStyle_16,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 54.h,
                  ),
                  Text(
                    AppTags.verifyYourNumber.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    AppTags.fiveDigitCodeSent.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: PinCodeTextField(
                  controller: otpController,
                  appContext: context,
                  length: 5,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(color: Colors.black),
                  animationType: AnimationType.fade,
                  enableActiveFill: true,
                  cursorColor: Colors.black,
                  boxShadows: [
                    BoxShadow(
                      color: const Color(0xFF404040).withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    selectedColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    fieldHeight: 48.h,
                    fieldWidth: 48.w,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                  ),
                  onChanged: (String value) {},
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (screen == "loginOTPScreen") {
                      Repository().postPhoneLoginOTP(
                          phoneNumber: phoneNumber, otp: otpController.text);
                    } else if (screen == "registrationOTpScreen") {
                      Repository().postPhoneRegistrationOTP(
                          phoneNumber: phoneNumber, otp: otpController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.r),
                    child: Text(
                      AppTags.verify.tr,
                      style: AppThemeData.buttonTextStyle_14,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
