import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDetailsPage extends StatelessWidget {
  const ShimmerDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 5),
            child: Shimmer.fromColors(
              highlightColor: Colors.grey[300]!,
              baseColor: Colors.grey[200]!,
              child: Container(
                height: 10.h,
                width: 30.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.all(
                    Radius.circular(
                        4.r),),),
              ),
            ),
          ),
          centerTitle: true,
          title: Shimmer.fromColors(
            highlightColor: Colors.grey[300]!,
            baseColor: Colors.grey[200]!,
            child: Container(
              height: 25.h,
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.all(
                  Radius.circular(
                      4.r),),),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only( top: 10.h, bottom: 10.h, right: 15.w),
              child: Shimmer.fromColors(
                highlightColor: Colors.grey[300]!,
                baseColor: Colors.grey[200]!,
                child: Container(
                  height: 30.h,
                  width: 30.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(
                              15.r))),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: SizedBox(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Shimmer.fromColors(
                        highlightColor: Colors.grey[300]!,
                        baseColor: Colors.grey[200]!,
                        child: Container(
                          height: size.height / 4.5,
                          width: size.width - 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4.r))),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Shimmer.fromColors(
                        highlightColor: Colors.grey[300]!,
                        baseColor: Colors.grey[200]!,
                        child: Container(
                          height: size.height / 15,
                          width: size.width - 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(4.r))),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
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
                                color:
                                const Color(0xff404040).withOpacity(0.01),
                                offset: const Offset(0, 15))
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0.r),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Shimmer.fromColors(
                                    highlightColor: Colors.grey[300]!,
                                    baseColor: Colors.grey[200]!,
                                    child: Container(
                                      height: 25.h,
                                      width: 150.w,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.r))),
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    highlightColor: Colors.grey[300]!,
                                    baseColor: Colors.grey[200]!,
                                    child: Container(
                                        height: 15.h,
                                        width: 30.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFFFFF),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
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
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Shimmer.fromColors(
                                              highlightColor: Colors.grey[300]!,
                                              baseColor: Colors.grey[200]!,
                                              child: Container(
                                                height: 30.h,
                                                width: 30.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.r))),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 13.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Shimmer.fromColors(
                                        highlightColor: Colors.grey[300]!,
                                        baseColor: Colors.grey[200]!,
                                        child: Container(
                                          height: 25.h,
                                          width: 120.w,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.r))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 65.w,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Shimmer.fromColors(
                                          highlightColor: Colors.grey[300]!,
                                          baseColor: Colors.grey[200]!,
                                          child: Container(
                                            height: 23.h,
                                            width: 23.w,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffF4F4F4),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Shimmer.fromColors(
                                        //   highlightColor: Colors.grey[300]!,
                                        //   baseColor: Colors.grey[200]!,
                                        //   child: Container(
                                        //     height: 20.h,
                                        //     width: 25.w,
                                        //     decoration: BoxDecoration(
                                        //         color: Colors.white,
                                        //         borderRadius: BorderRadius.all(
                                        //             Radius.circular(4.r))),
                                        //   ),
                                        // ),
                                        Shimmer.fromColors(
                                          highlightColor: Colors.grey[300]!,
                                          baseColor: Colors.grey[200]!,
                                          child: Container(
                                            height: 23.h,
                                            width: 23.w,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffF4F4F4),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(3),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                //height: 23,
                                // width: 23,
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
                                    padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Shimmer.fromColors(
                                              highlightColor: Colors.grey[300]!,
                                              baseColor: Colors.grey[200]!,
                                              child: Container(
                                                height: 20.h,
                                                width: 180.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.r))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // const Icon(Icons.arrow_forward_ios_rounded,size: 16,color:  Color(0xff999999))
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                //height: 23,
                                // width: 23,
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
                                    padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Shimmer.fromColors(
                                              highlightColor: Colors.grey[300]!,
                                              baseColor: Colors.grey[200]!,
                                              child: Container(
                                                height: 20.h,
                                                width: 140.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.r))),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              highlightColor: Colors.grey[300]!,
                                              baseColor: Colors.grey[200]!,
                                              child: Container(
                                                height: 20.h,
                                                width: 15.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.r))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                //height: 23,
                                // width: 23,
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
                                    padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Shimmer.fromColors(
                                              highlightColor: Colors.grey[300]!,
                                              baseColor: Colors.grey[200]!,
                                              child: Container(
                                                height: 22.h,
                                                width: 120.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.r))),
                                              ),
                                            ),
                                            Shimmer.fromColors(
                                              highlightColor: Colors.grey[300]!,
                                              baseColor: Colors.grey[200]!,
                                              child: Container(
                                                height: 20.h,
                                                width: 15.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            4.r))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Shimmer.fromColors(
                        highlightColor: Colors.grey[300]!,
                        baseColor: Colors.grey[200]!,
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width / 1.6,
                          height: size.height / 18,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
