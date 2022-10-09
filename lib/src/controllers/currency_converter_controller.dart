import 'package:dromedic_health/src/data/local_data_helper.dart';
import 'package:dromedic_health/src/models/config_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

class CurrencyConverterController extends GetxController {
  late String appCurrencyCode = "USD";
  late String appCurrencySymbol = "\$";

  late String decimalSeparator = ".";
  late String numberOfDecimals = '2';
  late int currencyIndex = 0;

  late NumberFormat formatter;

  void fetchCurrencyData() {
    ConfigModel data = LocalDataHelper().getConfigData();
    appCurrencyCode = LocalDataHelper().getCurrCode() ?? "USD";
    currencyIndex = data.data!.currencies!
        .indexWhere(((currIndex) => currIndex.code == appCurrencyCode));
    appCurrencySymbol = newMethod(data)[currencyIndex].symbol!;
    // currencySymbolFormat = data.data!.currencyConfig!.currencySymbolFormat!;
    decimalSeparator = data.data!.currencyConfig!.decimalSeparator!;
    numberOfDecimals = data.data!.currencyConfig!.noOfDecimals!;
  }

  List<Currencies> newMethod(ConfigModel data) => data.data!.currencies!;

  convertCurrency(price) {
    ConfigModel data = LocalDataHelper().getConfigData();
    if (appCurrencyCode == "USD") {
      MoneyFormatter formatter = MoneyFormatter(
        amount: double.parse(price),
        settings: MoneyFormatterSettings(
          symbol: appCurrencySymbol,
          thousandSeparator: decimalSeparator == "." ? ',' : ".",
          decimalSeparator: decimalSeparator,
          symbolAndNumberSeparator: symbolNumberSeparator(),
          fractionDigits: int.parse(numberOfDecimals),
        ),
      );
      if (symblePosition() == "right") {
        return formatter.output.symbolOnRight;
      } else {
        return formatter.output.symbolOnLeft;
      }
    } else {
      final convertedPrice = double.parse(price) *
          data.data!.currencies![currencyIndex].exchangeRate!;
      MoneyFormatter formatter = MoneyFormatter(
        amount: convertedPrice,
        settings: MoneyFormatterSettings(
          symbol: appCurrencySymbol,
          thousandSeparator: decimalSeparator == "." ? ',' : ".",
          decimalSeparator: decimalSeparator,
          symbolAndNumberSeparator: symbolNumberSeparator(),
          fractionDigits: int.parse(numberOfDecimals),
        ),
      );
      if (symblePosition() == "right") {
        return formatter.output.symbolOnRight;
      } else {
        return formatter.output.symbolOnLeft;
      }
    }
  }

  symbolNumberSeparator() {
    ConfigModel data = LocalDataHelper().getConfigData();
    if (data.data!.currencyConfig!.currencySymbolFormat! == "amount_symbol" ||
        data.data!.currencyConfig!.currencySymbolFormat! == "symbol_amount") {
      return "";
    } else {
      return " ";
    }
  }

  symblePosition() {
    ConfigModel data = LocalDataHelper().getConfigData();
    if (data.data!.currencyConfig!.currencySymbolFormat! == "amount_symbol" ||
        data.data!.currencyConfig!.currencySymbolFormat! == "amount__symbol") {
      return "right";
    } else {
      return "left";
    }
  }
}
