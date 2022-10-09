import 'package:dromedic_health/src/_route/routes.dart';
import 'package:dromedic_health/src/controllers/dashboard_controller.dart';
import 'package:dromedic_health/src/data/local_data_helper.dart';
import 'package:dromedic_health/src/utils/app_tags.dart';
import 'package:dromedic_health/src/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../profile/order_history_screen.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  PaymentConfirmationScreen({Key? key}) : super(key: key);
  final homeScreenController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppTags.confirmation.tr,
          style: AppThemeData.headerTextStyle_16,
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 126.h,
                    width: 126.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        alignment: Alignment.center,
                        matchTextDirection: true,
                        repeat: ImageRepeat.noRepeat,
                        image: AssetImage("assets/images/successful.gif"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    AppTags.successfulPayment.tr,
                    style: AppThemeData.seccessfulPayTextStyle_18,
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text(
                    "${AppTags.orderNumber.tr}: 254154 2554 55412",
                    style: AppThemeData.titleTextStyle_14,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    AppTags.thankYouPurchasing.tr,
                    style: AppThemeData.titleTextStyle_14,
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            //Calculate Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      // width: 160,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          LocalDataHelper().box.remove("trxId");
                          homeScreenController.changeTabIndex(4);
                          Get.offAllNamed(
                            Routes.orderHistory,
                            parameters: {
                              'routeName': RouteCheckofOrderHistory
                                  .paymentCompleteScreen
                                  .toString(),
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          AppTags.getInvoice.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: SizedBox(
                      // width: 160,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          LocalDataHelper().box.remove("trxId");
                          homeScreenController.changeTabIndex(0);
                          Get.offAllNamed(Routes.dashboardScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          AppTags.continueShopping.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
