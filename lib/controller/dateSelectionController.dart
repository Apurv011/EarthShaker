import 'package:get/get.dart';

class DateSelectionController extends GetxController {
  var startDate = "".obs;
  var endDate = "".obs;

  void changeStartDate(sDate) {
    startDate.value = sDate;
  }

  void changeEndDate(eDate) {
    endDate.value = eDate;
  }
}
