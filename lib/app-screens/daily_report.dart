import 'package:flutter/material.dart';
import 'package:chicfavs_pos/gen_screens_or_widgets/report_details.dart';

class DailyReport extends StatelessWidget {
  Map<String, dynamic> request = {"apiid": "getTodaysReport"};
  @override
  Widget build(BuildContext context) {
    return ReportDetails(
      title: "Today's",
      label: "today's",
      period: "today",
      request: this.request,
    );
  }
}
