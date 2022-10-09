import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:dromedic_health/src/controllers/color_selection_controller.dart';
import 'package:dromedic_health/src/models/product_details_model.dart';
import 'package:dromedic_health/src/servers/repository.dart';
import 'package:dromedic_health/src/utils/analytics_helper.dart';
import 'package:dromedic_health/src/utils/validators.dart';

class DetailsPageController extends GetxController {
  PageController pageController = PageController();
  TextEditingController ratingController = TextEditingController();
  final _colorSelectionController = Get.put(ColorSelectionController());
  late double rating;
  double initialRating = 2.0;

  var isDescription = false.obs;
  var isSpecific = false.obs;
  var isFavorite = false.obs;
  var isFavoriteLocal = false.obs;

  var hassleFree = false.obs;
  var groupProduct = false.obs;

  var isObsecure = true.obs;

  late Rx<AppLifecycleState> appState;

  IconData? selectedIcon;
  var productImageNumber = 0.obs;
  Rx<ProductDetailsModel> productDetail = ProductDetailsModel().obs;

  var openResult = 'Unknown'.obs;
  final _minimumOrderQuantity = 1.obs;
  var productQuantity = 1.obs;
  var totalPrice = 0.0.obs;

  String colorId = '';
  String colorValue = '';

  late Rx<File> selectedImage;
  var base64Image = "".obs;

  var productId = Get.parameters['productId'];

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   setState(() {
  //     appState = state;
  //     if (appState == AppLifecycleState.inactive) {
  //       if (_isFavorite != apiFavData) {
  //         _favouriteController.addOrRemoveFromFav(widget.productId);
  //       }
  //     }
  //   });
  // }

  //PDf File Reader
  Future<void> openFile(var url) async {
    final result = await OpenFile.open(url);
    openResult.value = result.toString();
  }

  //Image Picked
  Future<void> chooseImage(type) async {
    XFile? image;
    if (type == "camera") {
      image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
    } else {
      image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 25);
    }
    if (image != null) {
      selectedImage.value = File(image.path);
      base64Image.value = base64Encode(selectedImage.value.readAsBytesSync());
    }
  }

  isObsecureUpdate() {
    isObsecure.value = !isObsecure.value;
  }

  isFavoriteUpdate() {
    isFavorite.value = !isFavorite.value;
  }

  isFavoriteLocalUpdate() {
    isFavoriteLocal.value = !isFavoriteLocal.value;
  }

  itemCounterUpdate(value) {
    productImageNumber.value = value;
  }

  isDeliveryUpdate() {
    isDescription.value = !isDescription.value;
  }

  ratingUpdate(double value) {
    rating = value;
  }

  isSpecificUpdate() {
    isSpecific.value = !isSpecific.value;
  }

  Future setProductDetailsData(ProductDetailsModel data) async {
    if (data.data!.hasVariant!) {
      _colorSelectionController.setAttrData(
          data.data!.attributes!.length,
          data.data!.form!.variantsName!,
          data.data!.form!.variantsIds!,
          data.data!.attributes!,
          data.data!.colors!);
    }
  }

  Future<ProductDetailsModel> getProductDetails(int proId) async {
    return await Repository().getProductDetails(proId).then((value) {
      productDetail.value = value;
      _minimumOrderQuantity.value = value.data!.minimumOrderQuantity ?? 1;
      productQuantity.value = _minimumOrderQuantity.value;
      //calculate total price
      calculateTotalPrice();
      setProductDetailsData(value);
      isFavorite(value.data!.isFavourite);
      AnalyticsHelper().setAnalyticsData(
          screenName: "ProductDetailsScreen",
          eventTitle: "ProductDetails",
          additionalData: {
            "productId": proId,
            "price": value.data != null ? value.data!.price : null,
          });
      return productDetail.value;
    });
  }

  incrementProductQuantity() {
    if (productQuantity.value < productDetail.value.data!.currentStock!) {
      productQuantity.value++;
      calculateTotalPrice();
    } else {
      showErrorToast("No more product in stock");
    }
    update();
  }

  decrementProductQuantity() {
    if (productQuantity.value > _minimumOrderQuantity.value) {
      productQuantity.value--;
      calculateTotalPrice();
    } else {
      showErrorToast(
          "Please order a minium amount of ${_minimumOrderQuantity.value}");
    }
    update();
  }

  bool isValidToAddToCart() {
    if (productQuantity.value >= _minimumOrderQuantity.value) {
      return true;
    } else {
      showErrorToast(
          "Please order a minium amount of ${_minimumOrderQuantity.value}");
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    productImageNumber = 0.obs;
    ratingController = TextEditingController(text: '3.0');
    rating = initialRating;
  }

  updateColorId(String value) {
    colorId = value;
    update();
  }

  updateColorValue(String value) {
    colorValue = value;
    update();
  }

  void calculateTotalPrice() {
    double price =
        productQuantity.value * double.parse(productDetail.value.data!.price);
    if (productDetail.value.data != null) {
      if (productDetail.value.data!.isWholesale &&
          productDetail.value.data!.wholesalePrices != null) {
        for (var wholesale in productDetail.value.data!.wholesalePrices!) {
          if (productQuantity.value >= wholesale.minQty &&
              productQuantity.value <= wholesale.maxQty) {
            price = productQuantity.value * double.parse(wholesale.price);
          }
        }
      }
    }
    totalPrice.value = price;
    update();
  }

  @override
  void onClose() {
    Get.delete<ColorSelectionController>();
    super.onClose();
  }
}
