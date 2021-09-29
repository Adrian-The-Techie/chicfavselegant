import 'package:flutter/material.dart';
import 'package:chicfavs_pos/gen_screens_or_widgets/report_details.dart';

class YearlyReport extends StatelessWidget {
  Map<String, dynamic> request = {"apiid": "getYearReport"};
  @override
  Widget build(BuildContext context) {
    return ReportDetails(
      title: "This year's",
      label: "this year's",
      period: "this year",
      request: this.request,
    );
  }
}
