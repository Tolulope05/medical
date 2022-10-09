import 'package:get/get.dart';
import 'package:dromedic_health/src/models/order_list_model.dart';
import 'package:dromedic_health/src/servers/repository.dart';

class OrderHistoryController extends GetxController {
  var isLoading = true.obs;
  OrderListModel orderListModel = OrderListModel();

  Future getOrderList() async {
    orderListModel = await Repository().getOrderList();
    isLoading.value = false;
  }

  @override
  void onInit() {
    getOrderList();
    super.onInit();
  }
}
