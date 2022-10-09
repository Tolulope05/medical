import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dromedic_health/src/controllers/currency_converter_controller.dart';
import 'package:dromedic_health/src/models/edit_view_model.dart';
import 'package:dromedic_health/src/models/shipping_address_model/country_list_model.dart';
import 'package:dromedic_health/src/models/shipping_address_model/get_city_model.dart';
import 'package:dromedic_health/src/models/shipping_address_model/shipping_address_model.dart';
import 'package:dromedic_health/src/models/shipping_address_model/state_list_model.dart';
import 'package:dromedic_health/src/servers/repository.dart';
import 'package:dromedic_health/src/utils/app_tags.dart';
import 'package:dromedic_health/src/data/local_data_helper.dart';
import 'package:dromedic_health/src/utils/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/loader/loader_widget.dart';

class Addresses extends StatefulWidget {
  const Addresses({
    Key? key,
  }) : super(key: key);

  @override
  State<Addresses> createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final postalCodeController = TextEditingController();
  final addressController = TextEditingController();
  final currencyConverterController = Get.find<CurrencyConverterController>();
  int? shippingIndex = 0;
  String? token = LocalDataHelper().getUserToken();
  void onShippingTapped(int? index) {
    setState(() {
      shippingIndex = index!;
    });
  }

  int? billingIndex = 0;
  void onBillingTapped(int? index) {
    setState(() {
      billingIndex = index!;
    });
  }

  String? phoneCode = "880";
  dynamic selectPickUpAddress;
  dynamic _selectedCountry; // Option 2
  dynamic _selectedState; // Option 2// Option 2
  dynamic _selectedCity; // Option 2

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    getCountryList();
    getShippingAddress();
    super.initState();
  }

  ShippingAddressModel shippingAddressModel = ShippingAddressModel();
  Future getShippingAddress() async {
    shippingAddressModel = await Repository().getShippingAddress();
    setState(() {});
  }

  CountryListModel countryListModel = CountryListModel();
  Future getCountryList() async {
    countryListModel = await Repository().getCountryList();
    setState(() {});
  }

  StateListModel stateListModel = StateListModel();
  Future getStateList(int? countryId) async {
    stateListModel = await Repository().getStateList(countryId: countryId);
    setState(() {});
  }

  GetCitisModel cityModel = GetCitisModel();
  Future getCityList(int? stateId) async {
    cityModel = await Repository().getCityList(stateId: stateId);
    setState(() {});
  }

  EditViewModel editViewModel = EditViewModel();
  Future getEditViewAddress(int addressId) async {
    editViewModel = await Repository().getEditViewAddress(addressId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return shippingAddressModel.data != null
        ? Scaffold(
            key: _scaffoldkey,
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
                }, // null disables the button
              ),
              centerTitle: true,
              title: Text(
                AppTags.addAddress.tr,
                style: AppThemeData.headerTextStyle_16,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextButton(
                    child: Text(
                      "+ ${AppTags.add.tr}",
                      style: AppThemeData.addAddressTextStyle_13,
                    ),
                    onPressed: () {
                      if (token != null) {
                        createAddress();
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
                  ),
                )
              ],
            ),
            body: SizedBox(
              height: size.height,
              width: size.width,
              child: token != null ? shippingAddress() : const SizedBox(),
            ),
          )
        : const Scaffold(body: Center(child: LoaderWidget()));
  }

  // Shipping Address
  Widget shippingAddress() {
    return ListView.builder(
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        itemCount: shippingAddressModel.data!.addresses!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFFFFF),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 30,
                      blurRadius: 5,
                      color: const Color(0xff404040).withOpacity(0.01),
                      offset: const Offset(0, 15))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTags.home_.tr,
                          style: AppThemeData.headerTextStyle_14,
                        ),
                        InkWell(
                            onTap: () {
                              onShippingTapped(index);
                              setState(() {});
                            },
                            child: shippingAddressModel.data!.addresses![index]
                                            .defaultBilling !=
                                        0 ||
                                    shippingAddressModel.data!.addresses![index]
                                            .defaultShipping !=
                                        0
                                ? Container(
                                    height: 20,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF4F4F4),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: Text(
                                      AppTags.defaultAddress.tr,
                                      style: AppThemeData
                                          .addressDefaultTextStyle_10,
                                    ))
                                : const SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${AppTags.name.tr}: ${shippingAddressModel.data!.addresses![index].name.toString()}",
                      style: AppThemeData.profileTextStyle_13,
                    ),
                    const SizedBox(height: 8),
                    Text(
                        "${AppTags.email.tr}: ${shippingAddressModel.data!.addresses![index].email.toString()}",
                        style: AppThemeData.profileTextStyle_13),
                    const SizedBox(height: 8),
                    Text(
                        "${AppTags.phone.tr}: ${shippingAddressModel.data!.addresses![index].phoneNo.toString()}",
                        style: AppThemeData.profileTextStyle_13),
                    const SizedBox(height: 8),
                    Text(
                        "${AppTags.country.tr}: ${shippingAddressModel.data!.addresses![index].country.toString()}",
                        style: AppThemeData.profileTextStyle_13),
                    const SizedBox(height: 8),
                    Text(
                        "${AppTags.state.tr}: ${shippingAddressModel.data!.addresses![index].state.toString()}",
                        style: AppThemeData.profileTextStyle_13),
                    const SizedBox(height: 8),
                    Text(
                        "${AppTags.city.tr}: ${shippingAddressModel.data!.addresses![index].city.toString()}",
                        style: AppThemeData.profileTextStyle_13),
                    const SizedBox(height: 8),
                    Text(
                        "${AppTags.address.tr}: ${shippingAddressModel.data!.addresses![index].address.toString()}",
                        style: AppThemeData.profileTextStyle_13),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(AppTags.confirmation.tr),
                                  content:
                                      Text(AppTags.doYouWantToDeleteAddress.tr),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(
                                                false); // dismisses only the dialog and returns false
                                      },
                                      child: Text(AppTags.no.tr),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Repository()
                                            .deleteUserAddress(
                                                addressId: shippingAddressModel
                                                    .data!.addresses![index].id
                                                    .toString())
                                            .then((value) =>
                                                getShippingAddress());
                                        setState(() {});
                                        if (!mounted) return;
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(
                                                true); // dismisses only the dialog and returns true
                                      },
                                      child: Text(AppTags.yes.tr),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xffF4F4F4), width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(AppTags.delete.tr,
                                  style: AppThemeData.buttonDltTextStyle_13),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            await getEditViewAddress(shippingAddressModel
                                    .data!.addresses![index].id!)
                                .then((value) => editAddress(
                                    shippingAddressModel
                                        .data!.addresses![index].id,
                                    editViewModel));
                          },
                          child: Container(
                            width: 80,
                            //   height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xffF4F4F4), width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(AppTags.edit.tr,
                                  style: AppThemeData.buttonTextStyle_13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //Create Address
  Future createAddress() {
    return showDialog(
      //barrierColor: Colors.red,
      barrierDismissible: false,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return WillPopScope(
              onWillPop: () => Future.value(true),
              child: AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppTags.addAddress.tr,
                      style: AppThemeData.priceTextStyle_14,
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 18,
                        width: 18,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xff56A8C7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(2.5),
                          child: Icon(
                            Icons.clear,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.zero,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTags.name.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextFormField(
                            controller: nameController,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.name,
                            validator: (value) => textFieldValidator(
                              AppTags.name.tr,
                              nameController,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppTags.name.tr,
                              hintStyle: AppThemeData.hintTextStyle_13,
                              contentPadding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 5.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppTags.email.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => textFieldValidator(
                              AppTags.email.tr,
                              emailController,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppTags.email.tr,
                              hintStyle: AppThemeData.hintTextStyle_13,
                              contentPadding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 5.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppTags.phone.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 12, right: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: CountryPickerDropdown(
                                  isFirstDefaultIfInitialValueNotProvided:
                                      false,
                                  initialValue: 'BD',
                                  isExpanded: true,
                                  itemBuilder: (Country country) => Row(
                                    children: <Widget>[
                                      CountryPickerUtils.getDefaultFlagImage(
                                          country),
                                      Text("+${country.phoneCode}"),
                                    ],
                                  ),
                                  onValuePicked: (Country country) {
                                    phoneCode = country.phoneCode;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) => textFieldValidator(
                                    AppTags.phone.tr,
                                    phoneController,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 5.0,
                                    ),
                                    border: InputBorder.none,
                                    hintText: AppTags.phone.tr,
                                    hintStyle: AppThemeData.hintTextStyle_13,
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppTags.country.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 12, right: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text(
                                AppTags.selectCountry.tr,
                                style: AppThemeData.hintTextStyle_13,
                              ),
                              value: _selectedCountry,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCountry = newValue;
                                });
                              },
                              items: countryListModel.data!.countries!
                                  .map((country) {
                                return DropdownMenuItem(
                                  onTap: () async {
                                    await getStateList(country.id);
                                    setState(() {});
                                  },
                                  value: country.id,
                                  child: Text(country.name.toString()),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppTags.state.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        stateListModel.data != null
                            ? Container(
                                height: 42,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.only(left: 12, right: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffF4F4F4)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(
                                      AppTags.selectState.tr,
                                      style: AppThemeData.hintTextStyle_13,
                                    ),
                                    value: _selectedState,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          _selectedState = newValue!;
                                        },
                                      );
                                    },
                                    items: stateListModel.data!.states!
                                        .map((state) {
                                      return DropdownMenuItem(
                                        onTap: () async {
                                          await getCityList(state.id);
                                          setState(() {});
                                        },
                                        value: state.id,
                                        child: Text(state.name.toString()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            : Container(
                                height: 42,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.only(left: 12, right: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffF4F4F4)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Text(AppTags.selectState.tr,
                                        style: AppThemeData.hintTextStyle_13),
                                    value: _selectedState,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          _selectedState = newValue!;
                                        },
                                      );
                                    },
                                    items: null,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTags.city.tr,
                              style: AppThemeData.titleTextStyle_13,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            cityModel.data != null
                                ? Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xffF4F4F4)),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        hint: Text(
                                          AppTags.selectCity.tr,
                                          style: AppThemeData.hintTextStyle_13,
                                        ),
                                        value: _selectedCity,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedCity = newValue;
                                          });
                                        },
                                        items:
                                            cityModel.data!.cities!.map((city) {
                                          return DropdownMenuItem(
                                            onTap: () {},
                                            value: city.id,
                                            child: Text(city.name.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xffF4F4F4)),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text(AppTags.selectCity.tr,
                                              style: AppThemeData
                                                  .hintTextStyle_13),
                                          value: _selectedCity,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedCity = newValue;
                                            });
                                          },
                                          items: null),
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppTags.postalCode.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextFormField(
                            controller: postalCodeController,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.name,
                            validator: (value) => textFieldValidator(
                              AppTags.postalCode.tr,
                              postalCodeController,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppTags.postalCode.tr,
                              hintStyle: AppThemeData.hintTextStyle_13,
                              contentPadding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 5.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppTags.address.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 65,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextFormField(
                            controller: addressController,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.name,
                            validator: (value) => textFieldValidator(
                              AppTags.address.tr,
                              addressController,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppTags.streetAddress.tr,
                              hintStyle: AppThemeData.hintTextStyle_13,
                              contentPadding: const EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: 5.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, bottom: 15.0, right: 15.0),
                    child: InkWell(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await Repository()
                              .postCreateAddress(
                                name: nameController.text.toString(),
                                email: emailController.text.toString(),
                                phoneNo:
                                    "+$phoneCode ${phoneController.text.toString()}",
                                countryId: _selectedCountry,
                                stateId: _selectedState,
                                cityId: _selectedCity,
                                postalCode:
                                    postalCodeController.text.toString(),
                                address: addressController.text.toString(),
                              )
                              .then((value) => getShippingAddress());
                          Get.back();
                        }
                      },
                      child: Container(
                        alignment: Alignment.bottomRight,
                        width: 80,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xffF4F4F4)),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            AppTags.add.tr,
                            style: AppThemeData.buttonTextStyle_13,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //Edit Address
  Future editAddress(int? addressId, EditViewModel editViewModel) {
    return showDialog(
      //barrierColor: Colors.red,
      barrierDismissible: false,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return WillPopScope(
                onWillPop: () => Future.value(true),
                child: AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppTags.addAddress.tr,
                        style: AppThemeData.priceTextStyle_14,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                            height: 18,
                            width: 18,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xff56A8C7),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(2.5),
                              child: Icon(
                                Icons.clear,
                                size: 12,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.zero,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTags.name.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextField(
                            controller: nameController,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              // label: Text(editViewModel.data!.address!.name.toString()),
                              border: InputBorder.none,
                              hintText:
                                  editViewModel.data!.address!.name.toString(),
                              hintStyle: AppThemeData.hintTextStyle_13,
                              contentPadding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppTags.email.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextField(
                            controller: emailController,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  editViewModel.data!.address!.email.toString(),
                              hintStyle: AppThemeData.hintTextStyle_13,
                              contentPadding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppTags.phone.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: CountryPickerDropdown(
                                  isFirstDefaultIfInitialValueNotProvided:
                                      false,
                                  initialValue: 'BD',
                                  isExpanded: true,
                                  itemBuilder: _buildDropdownItem,
                                  onValuePicked: (Country country) {},
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: TextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: editViewModel
                                        .data!.address!.phoneNo
                                        .toString(),
                                  ),
                                  onChanged: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppTags.country.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  editViewModel.data!.address!.country!
                                      .toString(),
                                  style: AppThemeData.hintTextStyle_13,
                                ),
                              ),
                              // Not necessary for Option 1
                              value: _selectedCountry,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCountry = newValue;
                                });
                              },
                              items: countryListModel.data!.countries!
                                  .map((country) {
                                return DropdownMenuItem(
                                  onTap: () async {
                                    await getStateList(country.id);
                                    setState(() {});
                                  },
                                  value: country.id,
                                  child: Text(country.name.toString()),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppTags.state.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        stateListModel.data != null
                            ? Container(
                                height: 42,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffF4F4F4)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Text(
                                        editViewModel.data!.address!.state!
                                            .toString(),
                                        style: AppThemeData.hintTextStyle_13,
                                      ),
                                    ),
                                    value: _selectedState,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          _selectedState = newValue!;
                                        },
                                      );
                                    },
                                    items: stateListModel.data!.states!
                                        .map((state) {
                                      return DropdownMenuItem(
                                        onTap: () async {
                                          await getCityList(state.id);
                                          setState(() {});
                                        },
                                        value: state.id,
                                        child: Text(state.name.toString()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            : Container(
                                height: 42,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffF4F4F4)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Text(
                                        editViewModel.data!.address!.state!
                                            .toString(),
                                        style: AppThemeData.hintTextStyle_13,
                                      ),
                                    ),
                                    // Not necessary for Option 1
                                    value: _selectedState,
                                    onChanged: (newValue) {
                                      setState(
                                        () {
                                          _selectedState = newValue!;
                                        },
                                      );
                                    },
                                    items: null,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 73.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppTags.city.tr,
                                      style: AppThemeData.titleTextStyle_13,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    cityModel.data != null
                                        ? Container(
                                            height: 42,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffF4F4F4)),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                hint: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0),
                                                  child: Text(
                                                    editViewModel
                                                        .data!.address!.city!
                                                        .toString(),
                                                    style: AppThemeData
                                                        .hintTextStyle_13,
                                                  ),
                                                ),
                                                value: _selectedCity,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _selectedCity = newValue;
                                                  });
                                                },
                                                items: cityModel.data!.cities!
                                                    .map((city) {
                                                  return DropdownMenuItem(
                                                    onTap: () {},
                                                    value: city.id,
                                                    child: Text(
                                                        city.name.toString()),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 42,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xffF4F4F4)),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                  isExpanded: true,
                                                  hint: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Text(
                                                      editViewModel
                                                          .data!.address!.city!
                                                          .toString(),
                                                      style: AppThemeData
                                                          .hintTextStyle_13,
                                                    ),
                                                  ),
                                                  value: _selectedCity,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _selectedCity = newValue;
                                                    });
                                                  },
                                                  items: null),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                  flex: 0,
                                  child: SizedBox(
                                    width: 15,
                                  )),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppTags.postalCode.tr,
                                      style: AppThemeData.titleTextStyle_13,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      height: 42,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffF4F4F4)),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: postalCodeController,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: editViewModel
                                              .data!.address!.postalCode!
                                              .toString(),
                                          hintStyle:
                                              AppThemeData.hintTextStyle_13,
                                          contentPadding: const EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 8.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          AppTags.address.tr,
                          style: AppThemeData.titleTextStyle_13,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 42,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextField(
                            controller: addressController,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: editViewModel.data!.address!.address!
                                  .toString(),
                              hintStyle: AppThemeData.hintTextStyle_13,
                              contentPadding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, bottom: 15.0, right: 15.0),
                      child: InkWell(
                        onTap: () async {
                          await Repository()
                              .updateEditAddress(
                                name: nameController.text.toString(),
                                email: emailController.text.toString(),
                                phoneNo: phoneController.text.toString(),
                                countryId: _selectedCountry,
                                stateId: _selectedState,
                                cityId: _selectedCity,
                                postalCode:
                                    postalCodeController.text.toString(),
                                address: addressController.text.toString(),
                                addressId: addressId!,
                              )
                              .then((value) => getShippingAddress());
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.bottomRight,
                          width: 80,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffF4F4F4)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              AppTags.add.tr,
                              style: AppThemeData.buttonTextStyle_13,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }

  textFieldValidator(name, textController) {
    if (textController.text.isEmpty) {
      return "$name ${AppTags.required.tr}";
    }
  }

  Widget _buildDropdownItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Text("+${country.phoneCode}"),
        ],
      );
}
