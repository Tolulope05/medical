class CountryListModel {
  CountryListModel({
      this.success, 
      this.message, 
      this.data,});

  CountryListModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.countries,});

  Data.fromJson(dynamic json) {
    if (json['countries'] != null) {
      countries = [];
      json['countries'].forEach((v) {
        countries?.add(Countries.fromJson(v));
      });
    }
  }
  List<Countries>? countries;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (countries != null) {
      map['countries'] = countries?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Countries {
  Countries({
      this.id, 
      this.name, 
      this.iso3, 
      this.iso2, 
      this.phonecode, 
      this.currency, 
      this.currencySymbol, 
      this.latitude, 
      this.longitude, 
      this.status, 
      this.createdAt, 
      this.updatedAt,});

  Countries.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    phonecode = json['phonecode'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? name;
  String? iso3;
  String? iso2;
  String? phonecode;
  String? currency;
  String? currencySymbol;
  String? latitude;
  String? longitude;
  int? status;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['iso3'] = iso3;
    map['iso2'] = iso2;
    map['phonecode'] = phonecode;
    map['currency'] = currency;
    map['currency_symbol'] = currencySymbol;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}