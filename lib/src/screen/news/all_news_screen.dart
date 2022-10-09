// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:dromedic_health/src/_route/routes.dart';
import 'package:dromedic_health/src/models/all_news_model.dart';
import 'package:dromedic_health/src/utils/app_tags.dart';
import 'package:dromedic_health/src/utils/app_theme_data.dart';
import 'package:flutter/material.dart';

import '../../servers/repository.dart';
import '../../utils/responsive.dart';
import '../../widgets/loader/shimmer_all_news.dart';

class AllNews extends StatefulWidget {
  const AllNews({Key? key}) : super(key: key);

  @override
  _AllNewsState createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  int page = 0;
  PaginationViewType paginationViewType = PaginationViewType.gridView;
  GlobalKey<PaginationViewState> key = GlobalKey<PaginationViewState>();

  Future<List<Data>> getData(int offset) async {
    //page = (offset / 1).round();
    page++;
    return await Repository().getAllNews(page: page);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                }, // null disables the button
              ),
              centerTitle: true,
              title: Text(
                AppTags.allNews.tr,
                style: AppThemeData.headerTextStyle_16,
              ),
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 60.h,
              leadingWidth: 40.w,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 25.r,
                ),

                onPressed: () {
                  Get.back();
                }, // null disables the button
              ),
              centerTitle: true,
              title: Text(
                AppTags.allNews.tr,
                style: AppThemeData.headerTextStyle_14,
              ),
            ),
      body: PaginationView<Data>(
        key: key,
        paginationViewType: paginationViewType,
        pageFetch: getData,
        pullToRefresh: false,
        onError: (dynamic error) => Center(
          child: Text(AppTags.someErrorOccurred.tr),
        ),
        onEmpty: const Center(
          child: Text(AppTags.noProduct),
        ),
        bottomLoader: const Center(
          child: CircularProgressIndicator(),
        ),
        initialLoader: const ShimmerAllNews(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile(context) ? 2 : 3,
          childAspectRatio: 0.85,
          mainAxisSpacing: isMobile(context) ? 15 : 20,
          crossAxisSpacing: isMobile(context) ? 15 : 20,
        ),
        itemBuilder: (BuildContext context, Data news, int index) {
          return InkWell(
            onTap: () {
              Get.toNamed(
                Routes.newsScreen,
                parameters: {
                  'title': news.title!,
                  'url': news.url!,
                  'image': news.thumbnail!
                },
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  //height: 200,
                  //width: 165,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7.r)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff404040).withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10.r,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                news.thumbnail!,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r)),
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 4.w, bottom: 4.h, top: 4.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                news.title!,
                                style: isMobile(context)
                                    ? AppThemeData.titleTextStyle_14
                                    : AppThemeData.titleTextStyle_11Tab,
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Text(
                                news.shortDescription!,
                                style: isMobile(context)
                                    ? AppThemeData.qsTextStyle_12
                                    : AppThemeData.qsTextStyle_9Tab,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        shrinkWrap: true,
      ),
    );
  }
}
