import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dromedic_health/src/_route/routes.dart';
import 'package:dromedic_health/src/controllers/cart_content_controller.dart';
import 'package:dromedic_health/src/controllers/color_selection_controller.dart';
import 'package:dromedic_health/src/controllers/currency_converter_controller.dart';
import 'package:dromedic_health/src/controllers/details_screen_controller.dart';
import 'package:dromedic_health/src/controllers/favourite_controller.dart';
import 'package:dromedic_health/src/controllers/home_screen_controller.dart';
import 'package:dromedic_health/src/controllers/dashboard_controller.dart';
import 'package:dromedic_health/src/models/product_details_model.dart';
import 'package:dromedic_health/src/servers/repository.dart';
import 'package:dromedic_health/src/utils/app_tags.dart';
import 'package:dromedic_health/src/utils/app_theme_data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dromedic_health/src/data/local_data_helper.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:dromedic_health/src/widgets/wholesale_data_widget.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/error_message_widget.dart';
import '../../../widgets/loader/shimmer_details_page.dart';
import '../../dashboard/dashboard_screen.dart';
import 'product_description.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key}) : super(key: key);
  final titleController = TextEditingController();
  final writeReviewController = TextEditingController();
  final writeReviewReplyController = TextEditingController();
  final currencyConverterController = Get.find<CurrencyConverterController>();
  final cartContentController = Get.find<CartContentController>();
  final homeScreenContentController = Get.put(HomeScreenController());
  final homeScreenController = Get.put(DashboardController());
  final detailsController = Get.put(DetailsPageController());
  final _favouriteController = Get.find<FavouriteController>();
  final _cartController = Get.find<CartContentController>();
  final _colorSelectionController = Get.put(ColorSelectionController());

  final productId = Get.parameters['productId'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductDetailsModel>(
        future: detailsController.getProductDetails(
          int.parse(productId!),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              detailsController.isFavoriteLocal.value =
                  snapshot.data!.data!.isFavourite;
              return _detailsPageUI(snapshot.data!, context);
            } else if (snapshot.hasError) {
              // print(snapshot.error);
              print(snapshot.data);
              return ErrorMessageWidget(message: AppTags.somethingWentWrong.tr);
            }
          }
          return const Center(
            child: ShimmerDetailsPage(),
          );
        },
      ),
    );
  }

  mobileAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          if (detailsController.isFavorite.value !=
              detailsController.isFavoriteLocal.value) {
            _favouriteController.addOrRemoveFromFav(productId);
          }
          Get.back();
        },
      ),
      centerTitle: true,
      title: Text(
        AppTags.productDetails.tr,
        style: AppThemeData.headerTextStyle_16,
      ),
      actions: [
        Row(
          children: [
            SizedBox(
              height: 30.h,
              width: 30.w,
              child: Obx(
                () => InkWell(
                  onTap: () {
                    homeScreenController.changeTabIndex(2);
                    Get.offAll(
                      DashboardScreen(),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 700),
                    );
                    if (_favouriteController.token != null) {
                      if (detailsController.isFavorite.value !=
                          detailsController.isFavoriteLocal.value) {
                        _favouriteController.addOrRemoveFromFav(productId);
                        printLog('favourite added');
                      }
                    }
                  },
                  child: Badge(
                    animationDuration: const Duration(milliseconds: 300),
                    animationType: BadgeAnimationType.slide,
                    badgeContent: Text(
                      cartContentController
                          .addToCartListModel.data!.carts!.length
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/shopping_bag.svg",
                      color: const Color(0xff333333),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Obx(
              () => Material(
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async {
                    if (_favouriteController.token != null) {
                      detailsController.isFavoriteLocalUpdate();
                    } else {
                      Get.snackbar(
                        AppTags.login.tr,
                        AppTags.pleaseLoginFirst.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 3),
                        colorText: Colors.white,
                        backgroundColor: Colors.black,
                        forwardAnimationCurve: Curves.decelerate,
                        shouldIconPulse: false,
                      );
                    }
                  },
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    margin: EdgeInsets.all(7.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff404040).withOpacity(0.13),
                          spreadRadius: 1,
                          blurRadius: 10.r,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: detailsController.isFavoriteLocal.value
                          ? SvgPicture.asset("assets/icons/heart_on.svg")
                          : SvgPicture.asset("assets/icons/heart_off.svg"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  tabAppbar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      toolbarHeight: 60.h,
      leadingWidth: 40.w,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          size: 25.r,
          color: Colors.black,
        ),
        onPressed: () {
          if (detailsController.isFavorite.value !=
              detailsController.isFavoriteLocal.value) {
            _favouriteController.addOrRemoveFromFav(productId);
          }
          Get.back();
        },
      ),
      centerTitle: true,
      title: Text(
        AppTags.productDetails.tr,
        style: AppThemeData.headerTextStyle_16,
      ),
      actions: [
        Row(
          children: [
            SizedBox(
              height: 30.h,
              width: 30.w,
              child: Obx(
                () => InkWell(
                  onTap: () {
                    homeScreenController.changeTabIndex(2);
                    Get.offAll(
                      DashboardScreen(),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 700),
                    );
                    if (_favouriteController.token != null) {
                      if (detailsController.isFavorite.value !=
                          detailsController.isFavoriteLocal.value) {
                        _favouriteController.addOrRemoveFromFav(productId);
                        printLog('favourite added');
                      }
                    }
                  },
                  child: Badge(
                    animationDuration: const Duration(milliseconds: 300),
                    animationType: BadgeAnimationType.slide,
                    badgeContent: Text(
                      cartContentController
                          .addToCartListModel.data!.carts!.length
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/shopping_bag.svg",
                      color: const Color(0xff333333),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Obx(
              () => Material(
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async {
                    if (_favouriteController.token != null) {
                      detailsController.isFavoriteLocalUpdate();
                    } else {
                      Get.snackbar(
                        AppTags.login.tr,
                        AppTags.pleaseLoginFirst.tr,
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 3),
                        colorText: Colors.white,
                        backgroundColor: Colors.black,
                        forwardAnimationCurve: Curves.decelerate,
                        shouldIconPulse: false,
                      );
                    }
                  },
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    margin: EdgeInsets.all(7.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff404040).withOpacity(0.13),
                          spreadRadius: 1,
                          blurRadius: 10.r,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: detailsController.isFavoriteLocal.value
                          ? SvgPicture.asset("assets/icons/heart_on.svg")
                          : SvgPicture.asset("assets/icons/heart_off.svg"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _detailsPageUI(ProductDetailsModel detailsModel, context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: isMobile(context) ? mobileAppbar() : tabAppbar(),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  //image Slide
                  LimitedBox(
                    maxHeight: 200.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        PageView.builder(
                          itemCount: detailsModel.data!.images!.length,
                          controller: detailsController.pageController,
                          onPageChanged: (index) {
                            detailsController.itemCounterUpdate(index);
                          },
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.network(
                                  detailsModel.data!.images![index],
                                ),
                              ),
                            );
                          },
                        ),

                        //Discount Percentage
                        Positioned(
                          top: 0,
                          left: 20,
                          child: Padding(
                            padding: EdgeInsets.all(5.0.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    detailsModel.data!.specialDiscountType ==
                                            'flat'
                                        ? double.parse(detailsModel
                                                    .data!.specialDiscount) ==
                                                0.000
                                            ? const SizedBox()
                                            : Container(
                                                height: 20.h,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF51E46)
                                                      .withOpacity(0.06),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(3.r),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${currencyConverterController.convertCurrency(detailsModel.data!.specialDiscount)} OFF",
                                                    style: AppThemeData
                                                        .todayDealNewStyle,
                                                  ),
                                                ),
                                              )
                                        : detailsModel.data!
                                                    .specialDiscountType ==
                                                'percentage'
                                            ? double.parse(detailsModel.data!
                                                        .specialDiscount) ==
                                                    0.000
                                                ? const SizedBox()
                                                : Container(
                                                    height: 20.h,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                              0xFFF51E46)
                                                          .withOpacity(0.06),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(3.r),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${homeScreenContentController.removeTrailingZeros(detailsModel.data!.specialDiscount)}% OFF",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppThemeData
                                                            .todayDealNewStyle,
                                                      ),
                                                    ),
                                                  )
                                            : Container(),
                                  ],
                                ),
                                detailsModel.data!.specialDiscount == 0
                                    ? const SizedBox()
                                    : SizedBox(width: 5.w),
                                detailsModel.data!.currentStock == 0
                                    ? Container(
                                        height: 20.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF51E46)
                                              .withOpacity(0.06),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(3.r),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppTags.stockOut.tr,
                                            style:
                                                AppThemeData.todayDealNewStyle,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Positioned(
                            left: 20.w,
                            bottom: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFF),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 16.r,
                                    color: const Color(0xff333333)
                                        .withOpacity(0.01),
                                    offset: const Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 8.0),
                                child: Text(
                                    "${detailsController.productImageNumber.value + 1}/${detailsModel.data!.images!.length}"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  //Timer CountDown
                  Container(
                    child: detailsModel.data!.specialDiscountEnd!.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: CountdownTimer(
                                endTime: detailsModel
                                            .data!.specialDiscountEnd !=
                                        null
                                    ? DateTime.now().millisecondsSinceEpoch +
                                        DateTime.parse(detailsModel
                                                .data!.specialDiscountEnd!)
                                            .difference(DateTime.now())
                                            .inMilliseconds
                                    : DateTime.now().microsecondsSinceEpoch,
                                widgetBuilder: (_, time) {
                                  if (time == null) {
                                    return Center(
                                      child: Text(
                                        AppTags.campaignOver.tr,
                                        style:
                                            AppThemeData.timeDateTextStyle_12,
                                      ),
                                    );
                                  } else {
                                    return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 44,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF51E46)
                                                  .withOpacity(0.10),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(3)),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${time.days ?? 0}"
                                                      .padLeft(2, "0"),
                                                  style: AppThemeData
                                                      .timeDateTextStyle_13,
                                                ),
                                                Text(
                                                  AppTags.days.tr,
                                                  style: AppThemeData
                                                      .timeDateTextStyle_10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 5.w),
                                          Container(
                                            width: 44.w,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF51E46)
                                                  .withOpacity(0.10),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(3)),
                                              boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 30.r,
                                                  blurRadius: 5.r,
                                                  color: const Color(0xff404040)
                                                      .withOpacity(0.01),
                                                  offset: const Offset(0, 15),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "${time.hours ?? 0}"
                                                      .padLeft(2, "0"),
                                                  style: AppThemeData
                                                      .timeDateTextStyle_13,
                                                ),
                                                Text(
                                                  AppTags.hrs.tr,
                                                  style: AppThemeData
                                                      .timeDateTextStyle_10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            width: 44,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF51E46)
                                                  .withOpacity(0.10),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(3)),
                                              boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 30.r,
                                                  blurRadius: 5.r,
                                                  color: const Color(0xff404040)
                                                      .withOpacity(0.01),
                                                  offset: const Offset(0, 15),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  " ${time.min ?? 0}"
                                                      .padLeft(2, "0"),
                                                  style: AppThemeData
                                                      .timeDateTextStyle_13,
                                                ),
                                                Text(
                                                  AppTags.minutes.tr,
                                                  style: AppThemeData
                                                      .timeDateTextStyle_10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Container(
                                            width: 44,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF51E46)
                                                  .withOpacity(0.10),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(3)),
                                              boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 30.r,
                                                  blurRadius: 5.r,
                                                  color: const Color(0xff404040)
                                                      .withOpacity(0.01),
                                                  offset: const Offset(0, 15),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                    "${time.sec ?? 0}"
                                                        .padLeft(2, "0"),
                                                    style: AppThemeData
                                                        .timeDateTextStyle_13),
                                                Text(
                                                  AppTags.secs.tr,
                                                  style: AppThemeData
                                                      .timeDateTextStyle_10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]);
                                  }
                                }),
                          )
                        : Container(),
                  ),
                  SizedBox(height: 20.h),

                  //Product Details
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15.0.w, vertical: 7.5.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 30.r,
                            blurRadius: 5.r,
                            color: const Color(0xff404040).withOpacity(0.01),
                            offset: const Offset(0, 15),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Resting Product Tittle
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    detailsModel.data!.title.toString(),
                                    maxLines: 2,
                                    style: isMobile(context)
                                        ? AppThemeData.labelTextStyle_16
                                        : AppThemeData.labelTextStyle_16tab,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  height: isMobile(context) ? 18.h : 28.h,
                                  width: isMobile(context) ? 40.w : 60.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffFFFFFF),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 0,
                                          blurRadius: 10,
                                          color: const Color(0xff404040)
                                              .withOpacity(0.1),
                                          offset: const Offset(0, 1))
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isMobile(context)
                                          ? SvgPicture.asset(
                                              "assets/icons/reting_icon.svg")
                                          : SvgPicture.asset(
                                              "assets/icons/reting_icon.svg",
                                              width: 15.w,
                                              height: 15.h),
                                      SizedBox(width: 4.w),
                                      Text(
                                        detailsModel.data!.rating.toString(),
                                        style: AppThemeData.reatingTextStyle_12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 13.h),

                            // Price Increment/Decrement
                            detailsModel.data!.isClassified!
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffF4F4F4),
                                      ),
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3.r),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10.w),
                                        SvgPicture.asset(
                                            "assets/icons/details_call_button.svg"),
                                        SizedBox(width: 32.w),
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              detailsController
                                                  .isObsecureUpdate();
                                            },
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    detailsController
                                                            .isObsecure.value
                                                        ? "XXXXXXXXXXX"
                                                        : detailsModel
                                                            .data!
                                                            .classifiedContactInfo!
                                                            .phone
                                                            .toString(),
                                                    style: AppThemeData
                                                        .detailsScreenPhoneNumber,
                                                  ),
                                                  Text(
                                                    AppTags
                                                        .clickHereToSeePhone.tr,
                                                    style: AppThemeData
                                                        .detailsScreenPhoneNumberShow,
                                                  ),
                                                ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      detailsModel.data!.specialDiscount ==
                                              "0.000"
                                          ? Row(
                                              children: [
                                                Text(
                                                  "${currencyConverterController.convertCurrency(detailsModel.data!.price)}",
                                                  style: AppThemeData
                                                      .seccessfulPayTextStyle_18,
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Text(
                                                  "${currencyConverterController.convertCurrency(detailsModel.data!.discountPrice)}",
                                                  style: AppThemeData
                                                      .seccessfulPayTextStyle_18,
                                                ),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  "${currencyConverterController.convertCurrency(detailsModel.data!.price)}",
                                                  style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 14,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                              ],
                                            ),
                                      detailsModel.data!.isCatalog!
                                          ? const SizedBox()
                                          : Obx(
                                              () => SizedBox(
                                                width: 75.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        detailsController
                                                            .decrementProductQuantity();
                                                      },
                                                      child: Container(
                                                        height: 23.h,
                                                        width: 23.w,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xffF4F4F4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(3),
                                                          ),
                                                        ),
                                                        child: const Icon(
                                                            Icons.remove,
                                                            size: 16),
                                                      ),
                                                    ),
                                                    AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      transitionBuilder:
                                                          (Widget child,
                                                              Animation<double>
                                                                  animation) {
                                                        return ScaleTransition(
                                                          scale: animation,
                                                          child: child,
                                                        );
                                                      },
                                                      child: Text(
                                                        detailsController
                                                            .productQuantity
                                                            .value
                                                            .toString(),
                                                        style: isMobile(context)
                                                            ? const TextStyle()
                                                            : AppThemeData
                                                                .labelTextStyle_16tab
                                                                .copyWith(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 20,
                                                              ),
                                                        key: ValueKey(
                                                            detailsController
                                                                .productQuantity
                                                                .value),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        detailsController
                                                            .incrementProductQuantity();
                                                      },
                                                      child: Container(
                                                          height: 23.h,
                                                          width: 23.w,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xffF4F4F4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  3),
                                                            ),
                                                          ),
                                                          child: const Icon(
                                                            Icons.add,
                                                            size: 16,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                            const SizedBox(height: 20),

                            // Delivery Time
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffF4F4F4),
                                ),
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3.r),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("${AppTags.delivery.tr}:",
                                            style:
                                                AppThemeData.titleTextStyle_13),
                                        const SizedBox(width: 5),
                                        Text(
                                          "${detailsModel.data!.delivery.toString()} days, ${detailsModel.data!.returnData.toString()} days return",
                                          style: AppThemeData.titleTextStyle_13,
                                        ),
                                      ],
                                    ),
                                    // const Icon(Icons.arrow_forward_ios_rounded,size: 16,color:  Color(0xff999999))
                                  ],
                                ),
                              ),
                            ),
                            detailsModel.data!.hasVariant!
                                ? const SizedBox(height: 10)
                                : const SizedBox(),

                            //Color Attribute
                            detailsModel.data!.hasVariant!
                                ? InkWell(
                                    onTap: () => showCupertinoModalBottomSheet(
                                      expand: false,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => Material(
                                        child: SafeArea(
                                          top: false,
                                          child: sizeColorSheet(detailsModel),
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffF4F4F4),
                                        ),
                                        color: const Color(0xffFFFFFF),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(3.r),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${AppTags.colorSize.tr}:",
                                                  style: AppThemeData
                                                      .titleTextStyle_13,
                                                ),
                                                SizedBox(width: 5.w),
                                                Obx(
                                                  () => SizedBox(
                                                    width: 200.w,
                                                    child: Text(
                                                      "${_colorSelectionController.selectedAttrName}",
                                                      style: AppThemeData
                                                          .titleTextStyle_13,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 16,
                                              color: Color(0xff999999),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(height: 10.h),
                            //Specification
                            detailsModel.data!.isClassified!
                                ? const SizedBox()
                                : Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffF4F4F4),
                                      ),
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(3)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Obx(
                                            () => InkWell(
                                              onTap: () async {
                                                detailsController.openFile(
                                                    detailsModel
                                                        .data!.specifications);
                                                detailsController
                                                    .isSpecificUpdate();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "${AppTags.specifications.tr}:",
                                                      style: AppThemeData
                                                          .titleTextStyle_14),
                                                  detailsController
                                                          .isSpecific.value
                                                      ? const Icon(Icons.remove,
                                                          size: 16,
                                                          color:
                                                              Color(0xff999999))
                                                      : const Icon(Icons.add,
                                                          size: 16,
                                                          color:
                                                              Color(0xff999999))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => detailsController
                                                    .isSpecific.value
                                                ? Column(
                                                    children: [
                                                      detailsModel
                                                              .data!
                                                              .specifications!
                                                              .isNotEmpty
                                                          ? SizedBox(
                                                              height: 400,
                                                              child: SfPdfViewer
                                                                  .network(detailsModel
                                                                      .data!
                                                                      .specifications!
                                                                      .toString()),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.r),
                                                              child: Text(
                                                                AppTags
                                                                    .noSpecifications
                                                                    .tr,
                                                                style: AppThemeData
                                                                    .labelTextStyle_16tab
                                                                    .copyWith(
                                                                        fontFamily:
                                                                            "Poppins"),
                                                              ),
                                                            )
                                                    ],
                                                  )
                                                : Row(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 10),

                            //Description
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffF4F4F4),
                                ),
                                color: const Color(0xffFFFFFF),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(3),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Obx(
                                      () => InkWell(
                                        onTap: () {
                                          detailsController.isDeliveryUpdate();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${AppTags.description.tr}:",
                                              style: AppThemeData
                                                  .titleTextStyle_14,
                                            ),
                                            detailsController
                                                    .isDescription.value
                                                ? const Icon(Icons.remove,
                                                    size: 16,
                                                    color: Color(0xff999999))
                                                : const Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Color(0xff999999),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () =>
                                          detailsController.isDescription.value
                                              ? Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 4.h,
                                                    ),
                                                    detailsModel.data!.details!
                                                            .isNotEmpty
                                                        ? SizedBox(
                                                            height: 400,
                                                            child:
                                                                ProductDescription(
                                                              details:
                                                                  detailsModel
                                                                      .data!
                                                                      .details!,
                                                            ),
                                                          )
                                                        : Text(
                                                            AppTags
                                                                .noDescription
                                                                .tr,
                                                          ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            //wholesale Data Table
                            detailsController
                                    .productDetail.value.data!.isWholesale
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffF4F4F4),
                                      ),
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(AppTags.minQtn.tr,
                                                      style: AppThemeData
                                                          .titleTextStyle_13),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(AppTags.maxQtn.tr,
                                                      style: AppThemeData
                                                          .titleTextStyle_13),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(AppTags.price.tr,
                                                      style: AppThemeData
                                                          .titleTextStyle_13),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Flexible(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: 3,
                                              itemBuilder: (context, index) =>
                                                  WholesaleDataWidget(
                                                wholesalePrice:
                                                    detailsController
                                                            .productDetail
                                                            .value
                                                            .data!
                                                            .wholesalePrices![
                                                        index],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            detailsController
                                    .productDetail.value.data!.isWholesale
                                ? const SizedBox(height: 10)
                                : const SizedBox(),

                            //Why Us section
                            detailsController.hassleFree.value
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffF4F4F4),
                                      ),
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0,
                                                    right: 8.0,
                                                    top: 4),
                                                child: Container(
                                                    height: 16,
                                                    width: 16,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      //color: const Color(0xff56A8C7),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffD16D86)),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      size: 12,
                                                      color: Color(0xffD16D86),
                                                    )),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      AppTags
                                                          .hassleFreeReturns.tr,
                                                      style: AppThemeData
                                                          .whyUsTextStyle_13,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  Text(AppTags.returnPolicy.tr,
                                                      style: AppThemeData
                                                          .titleTextStyle_13,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0,
                                                    right: 8.0,
                                                    top: 4),
                                                child: Container(
                                                    height: 16,
                                                    width: 16,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      //color: const Color(0xff56A8C7),
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xffD16D86)),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      size: 12,
                                                      color: Color(0xffD16D86),
                                                    )),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      AppTags
                                                          .hassleFreeReturns.tr,
                                                      style: AppThemeData
                                                          .whyUsTextStyle_13,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                  Text(AppTags.returnPolicy.tr,
                                                      style: AppThemeData
                                                          .titleTextStyle_13,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            detailsController.hassleFree.value
                                ? const SizedBox(
                                    height: 10,
                                  )
                                : const SizedBox(),

                            //Card section
                            detailsController.groupProduct.value
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffF4F4F4),
                                      ),
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 44,
                                                  width: 44,
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xffF5F5F5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.image,
                                                    size: 30,
                                                  )),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "Classic T-shirt Sleeves and Formal",
                                                          style: AppThemeData
                                                              .whyUsTextStyle_13,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("\$230.00",
                                                              style: AppThemeData
                                                                  .priceTextStyle_13),
                                                          Container(
                                                              height: 24,
                                                              width: 80,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                //color: const Color(0xff56A8C7),
                                                                border: Border.all(
                                                                    color: const Color(
                                                                        0xffF4F4F4)),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          3),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: const [
                                                                  Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 14,
                                                                      color: Color(
                                                                          0xff333333)),
                                                                  Text("1"),
                                                                  Icon(
                                                                      Icons.add,
                                                                      size: 14,
                                                                      color: Color(
                                                                          0xff333333)),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  height: 44,
                                                  width: 44,
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xffF5F5F5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.image,
                                                    size: 30,
                                                  )),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "Classic T-shirt Sleeves and Formal",
                                                          style: AppThemeData
                                                              .whyUsTextStyle_13,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("\$230.00",
                                                              style: AppThemeData
                                                                  .priceTextStyle_13),
                                                          Container(
                                                              height: 24,
                                                              width: 80,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                //color: const Color(0xff56A8C7),
                                                                border: Border.all(
                                                                    color: const Color(
                                                                        0xffF4F4F4)),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          3),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: const [
                                                                  Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 14,
                                                                      color: Color(
                                                                          0xff333333)),
                                                                  Text("1"),
                                                                  Icon(
                                                                      Icons.add,
                                                                      size: 14,
                                                                      color: Color(
                                                                          0xff333333)),
                                                                ],
                                                              ))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            detailsController.groupProduct.value
                                ? const SizedBox(height: 10)
                                : const SizedBox(),

                            //Refund section
                            LocalDataHelper().isRefundAddonAvailable()
                                ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffF4F4F4),
                                      ),
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(3.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 44,
                                                width: 44,
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  //color: Color(0xffF5F5F5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: LocalDataHelper()
                                                    .getRefundIcon(),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    LocalDataHelper()
                                                                    .getRefundAddon() !=
                                                                null &&
                                                            LocalDataHelper()
                                                                    .getRefundAddon()!
                                                                    .addonData !=
                                                                null
                                                        ? LocalDataHelper()
                                                            .getRefundAddon()!
                                                            .addonData!
                                                            .title!
                                                        : "",
                                                    style: AppThemeData
                                                        .titleTextStyle_13,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                      LocalDataHelper()
                                                                      .getRefundAddon() !=
                                                                  null &&
                                                              LocalDataHelper()
                                                                      .getRefundAddon()!
                                                                      .addonData !=
                                                                  null
                                                          ? LocalDataHelper()
                                                              .getRefundAddon()!
                                                              .addonData!
                                                              .subTitle!
                                                          : "",
                                                      style: AppThemeData
                                                          .whyUsTextStyle_13,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            LocalDataHelper().isRefundAddonAvailable()
                                ? const SizedBox(height: 10)
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            //Social shear
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffF4F4F4),
                                ),
                                color: const Color(0xffFFFFFF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3.r),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.wvScreen,
                                              parameters: {
                                                'url': detailsModel
                                                    .data!.links!.facebook
                                                    .toString(),
                                                'title': "Facebook",
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: isMobile(context) ? 38 : 40,
                                            width: isMobile(context) ? 38 : 40,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffF5F5F5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: SvgPicture.asset(
                                                "assets/icons/details/facebook.svg"),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.wvScreen,
                                              parameters: {
                                                'url': detailsModel
                                                    .data!.links!.linkedin
                                                    .toString(),
                                                'title': "Linkedin",
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: isMobile(context) ? 38 : 40,
                                            width: isMobile(context) ? 38 : 40,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffF5F5F5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: SvgPicture.asset(
                                              "assets/icons/details/linkedin.svg",
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.h),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.wvScreen,
                                              parameters: {
                                                'url': detailsModel
                                                    .data!.links!.twitter
                                                    .toString(),
                                                'title': "Twitter",
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: isMobile(context) ? 38 : 40,
                                            width: isMobile(context) ? 38 : 40,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffF5F5F5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: SvgPicture.asset(
                                                "assets/icons/details/twitter.svg"),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                              Routes.wvScreen,
                                              parameters: {
                                                'url': detailsModel
                                                    .data!.links!.whatsapp
                                                    .toString(),
                                                'title': "WhatsApp",
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: isMobile(context) ? 38 : 40,
                                            width: isMobile(context) ? 38 : 40,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffF5F5F5),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: SvgPicture.asset(
                                                "assets/icons/details/whatsapp.svg"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //Review
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 7.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFFFF),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 30.r,
                              blurRadius: 5.r,
                              color: const Color(0xff404040).withOpacity(0.01),
                              offset: const Offset(0, 15))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${AppTags.review.tr} (${detailsModel.data!.reviews!.length})",
                                  style: AppThemeData.priceTextStyle_14,
                                ),
                                InkWell(
                                    onTap: () {
                                      showCupertinoModalBottomSheet(
                                        expand: false,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) => Material(
                                          child: SafeArea(
                                            top: false,
                                            child: buildSheet(detailsModel),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      AppTags.writeReview.tr,
                                      style:
                                          AppThemeData.writeReviewTextStyle_13,
                                    )),
                              ],
                            ),
                            //Review Product
                            detailsModel.data!.reviews!.isNotEmpty
                                ? reviewWidget(detailsModel, context)
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Add to Cart Button

            detailsModel.data!.isClassified!
                ? const SizedBox()
                : detailsModel.data!.isCatalog!
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 7.5.h),
                        child: InkWell(
                          onTap: () {
                            launchUrl(
                              Uri.parse(
                                  detailsModel.data!.catalogExternalLink!),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: ButtonWidget(
                              buttonTittle: AppTags.learnMore.tr,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                  border: Border.all(
                                    color: const Color(0xff333333),
                                    width: 1.r,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() => RichText(
                                            text: TextSpan(
                                              text: "${AppTags.total.tr}: ",
                                              style: AppThemeData
                                                  .detailsScreenTotal,
                                              children: [
                                                TextSpan(
                                                  text:
                                                      currencyConverterController
                                                          .convertCurrency(
                                                              detailsController
                                                                  .totalPrice
                                                                  .toString()),
                                                  style: AppThemeData
                                                      .detailsScreenTotalPrice,
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _cartController.addToCart(
                                    productId: productId.toString(),
                                    quantity: detailsController.productQuantity
                                        .toString(),
                                    variantsIds: _colorSelectionController
                                        .selectedAttrId.value,
                                    variantsNames: _colorSelectionController
                                        .selectedAttrName.value,
                                  );
                                },
                                child: Container(
                                  height: 48.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff333333),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SvgPicture.asset(
                                              "assets/icons/sopping_bag.svg"),
                                        ),
                                        Text(
                                          AppTags.addToCart.tr,
                                          style:
                                              AppThemeData.buttonTextStyle_14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  //Color Attribute
  Widget sizeColorSheet(ProductDetailsModel data) {
    return SizedBox(
      height: 406.h,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTags.color.tr,
                        style: AppThemeData.titleTextStyle_14,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.data!.colors!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Obx(
                            () => InputChip(
                              padding: const EdgeInsets.only(right: 8),
                              elevation: 1,
                              showCheckmark: true,
                              backgroundColor: const Color(0xffF4F4F4),
                              checkmarkColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              label: Text(
                                data.data!.colors![index].name!,
                                style: AppThemeData.categoryTitleTextStyle_12,
                              ),
                              selected: _colorSelectionController
                                      .selectedIndex.value ==
                                  index,
                              selectedColor: Colors.green,
                              onSelected: (value) {
                                _colorSelectionController.changeColorSelection(
                                  index: index,
                                  colorName:
                                      data.data!.colors![index].name.toString(),
                                  colorId:
                                      data.data!.colors![index].id.toString(),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 10.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.data!.attributes!.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.data!.attributes![i].title!.toString(),
                            style: AppThemeData.titleTextStyle_14,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          SizedBox(
                            height: 40.h,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(right: 15),
                              scrollDirection: Axis.horizontal,
                              itemCount: data
                                  .data!.attributes![i].attributeValue!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: Obx(
                                    () => InputChip(
                                      padding: const EdgeInsets.all(4.0),
                                      elevation: 1,
                                      showCheckmark: true,
                                      backgroundColor: const Color(0xffF4F4F4),
                                      checkmarkColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        side: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                      ),
                                      label: Text(
                                        data.data!.attributes![i]
                                            .attributeValue![index].value!,
                                        style: AppThemeData
                                            .categoryTitleTextStyle_12,
                                      ),
                                      selected: _colorSelectionController
                                              .selectedArray[i] ==
                                          index,
                                      selectedColor: Colors.green,
                                      onSelected: (value) {
                                        _colorSelectionController
                                            .changeAttrSelection(
                                                attrIndex: i, value: index);
                                        _colorSelectionController
                                            .insertAttrNameToList(
                                                name: data
                                                    .data!
                                                    .attributes![i]
                                                    .attributeValue![index]
                                                    .value!,
                                                index: i);
                                        _colorSelectionController
                                            .insertAttrIdToList(
                                                id: data.data!.attributes![i]
                                                    .attributeValue![index].id!
                                                    .toString(),
                                                index: i);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget reviewWidget(detailsModel, context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: detailsModel.data!.reviews!.length,
        itemBuilder: (_, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 35.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 5))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(detailsModel
                                .data!.reviews![index].user!.image
                                .toString()))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detailsModel.data!.reviews![index].user!.name
                                  .toString(),
                              style: AppThemeData.titleTextStyle_14,
                            ),
                            Text(
                              detailsModel.data!.reviews![index].date
                                  .toString(),
                              style: AppThemeData.dateTextStyle_12,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        RatingBarIndicator(
                          rating: double.parse(
                            detailsModel.data!.reviews![index].rating
                                .toString(),
                          ),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                detailsModel.data!.reviews![index].comment.toString(),
                style: isMobile(context)
                    ? const TextStyle()
                    : AppThemeData.labelTextStyle_16tab.copyWith(
                        fontFamily: "Poppins",
                        fontSize: 20,
                      ),
              ),
              SizedBox(height: 5.h),
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10.r,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 5))
                            ],
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(detailsModel
                                  .data!.reviews![index].image
                                  .toString()),
                              matchTextDirection: true,
                            ),
                          ),
                          //child: Image.asset("assets/images/_8.png")
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 8.0),
                child: replyReview(index, detailsModel, context),
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        // Repository()
                        //     .getLikeAndUnlike(reviewId: 10)
                        //     .then((value) => getProductDetails());

                        Repository().getLikeAndUnlike(reviewId: 10);
                      },
                      child: detailsModel.data!.reviews![index].isLiked!
                          ? SvgPicture.asset(
                              "assets/icons/like.svg",
                              color: Colors.blue,
                            )
                          : SvgPicture.asset("assets/icons/like.svg")),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        //contentPadding: const EdgeInsets.all(10),
                        actions: <Widget>[
                          buildReplyReview(index, detailsModel),
                        ],
                      ),
                    ),
                    child: SvgPicture.asset("assets/icons/comment.svg"),
                  ),
                ],
              )
            ],
          );
        });
  }

  Widget replyReview(int indexId, detailsModel, context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: detailsModel.data!.reviews![indexId].replies!.length,
        itemBuilder: (_, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 25.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 5))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(detailsModel.data!
                                .reviews![indexId].replies![index].user!.image
                                .toString()))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detailsModel.data!.reviews![indexId]
                                  .replies![index].user!.name
                                  .toString(),
                              style: AppThemeData.titleTextStyle_14,
                            ),
                            Text(
                              detailsModel
                                  .data!.reviews![indexId].replies![index].date
                                  .toString(),
                              style: AppThemeData.dateTextStyle_12,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(detailsModel.data!.reviews![indexId].replies![index].reply
                  .toString()),
              SizedBox(height: 5.h),
            ],
          );
        });
  }

  Widget buildSheet(detailsModel) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTags.rating.tr,
                        style: AppThemeData.detwailsScreenBottomSheetTitle,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8.7,
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    unratedColor: Colors.amber.withAlpha(50),
                    itemCount: 5,
                    itemSize: 20.0,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => Icon(
                      detailsController.selectedIcon ?? Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      detailsController.ratingUpdate(rating);
                    },
                    updateOnDrag: true,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppTags.uploadImage.tr,
                    style: AppThemeData.detwailsScreenBottomSheetTitle,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                      height: 53.h,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              detailsController.chooseImage("Gallery");
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                  color: Color(0xfff4f4f4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SvgPicture.asset(
                                    "assets/icons/bx_camera.svg"),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppTags.reviewTitle.tr,
                        style: AppThemeData.detwailsScreenBottomSheetTitle,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: titleController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.r),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xfff4f4f4),
                          width: 1.w,
                        ),
                      ),
                      hintText: AppTags
                          .returnPolicy.tr, // pass the hint text parameter here
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppTags.writeReview.tr,
                        style: AppThemeData.detwailsScreenBottomSheetTitle,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  TextField(
                    controller: writeReviewController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.r),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xfff4f4f4), width: 1.w),
                      ),
                      hintText: AppTags
                          .review.tr, // pass the hint text parameter here
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: InkWell(
                  onTap: () async {
                    await Repository().postReviewSubmit(
                        productId:
                            detailsModel.data!.form!.productId!.toString(),
                        title: titleController.text,
                        comment: writeReviewController.text,
                        rating: detailsController.rating.toString(),
                        image: detailsController.selectedImage.value);
                    //.then((value) => getProductDetails());
                    Get.back();
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PaymentMethod()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 315.w,
                    decoration: const BoxDecoration(
                      color: Color(0xff333333),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        AppTags.postReview.tr,
                        style: AppThemeData.detwailsScreenBottomSheetTitle
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildReplyReview(int index, detailsModel) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTags.replyReview.tr,
                        style: AppThemeData.titleTextStyle_14,
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 22,
                          ))
                    ],
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: writeReviewReplyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.r),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.greenAccent, width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: const Color(0xfff4f4f4), width: 1.w),
                      ),
                      hintText: AppTags.writeSomething
                          .tr, // pass the hint text parameter here
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
                child: InkWell(
                  onTap: () async {
                    await Repository().postReviewReply(
                      reviewId:
                          detailsModel.data!.reviews![index].id.toString(),
                      reply: writeReviewReplyController.text,
                    );
                    //.then((value) => getProductDetails());
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 315.w,
                    decoration: const BoxDecoration(
                      color: Color(0xff333333),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        AppTags.replyReview.tr,
                        style: AppThemeData.buttonTextStyle_14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
