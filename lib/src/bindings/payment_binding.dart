import 'package:get/instance_manager.dart';
import 'package:dromedic_health/src/controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PaymentController());
  }
}
