import 'package:flutter/material.dart';
import 'package:chicfavs_pos/gen_screens_or_widgets/report_details.dart';

class MonthlyReport extends StatelessWidget {
  Map<String, dynamic> request = {"apiid": "getMonthReport"};
  @override
  Widget build(BuildContext context) {
    return ReportDetails(
      title: "This Month's",
      label: "this month's",
      period: "this month",
      request: this.request,
    );
  }
}
