import 'package:get/get.dart';
import 'package:dromedic_health/src/controllers/auth_controller.dart';
import 'package:dromedic_health/src/controllers/currency_converter_controller.dart';
import 'package:dromedic_health/src/data/data_storage_service.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
    Get.put(StorageService());
    Get.lazyPut(() => CurrencyConverterController(), fenix: true);
  }
}
