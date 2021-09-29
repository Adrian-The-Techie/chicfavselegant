import 'package:chicfavs_pos/app-screens/daily_report.dart';
import 'package:chicfavs_pos/app-screens/monthly_report.dart';
import 'package:chicfavs_pos/app-screens/new_stock_take.dart';
import 'package:chicfavs_pos/app-screens/normal-sale.dart';
import 'package:chicfavs_pos/app-screens/specificAllocationHistoryDetails.dart';
import 'package:chicfavs_pos/app-screens/specific_allocation_details.dart';
import 'package:chicfavs_pos/app-screens/specificSalesHistory.dart';
import 'package:chicfavs_pos/app-screens/type-of-sale.dart';
import 'package:chicfavs_pos/app-screens/yearly_report.dart';
import 'package:chicfavs_pos/services/config.dart';
import 'package:chicfavs_pos/services/http.service.dart';
import 'package:flutter/material.dart';
import 'package:chicfavs_pos/app-screens/login.dart';
import 'package:chicfavs_pos/app-screens/home.dart';
import 'package:chicfavs_pos/app-screens/sales-dashboard.dart';
import 'package:chicfavs_pos/app-screens/inventory-dashboard.dart';
import 'package:chicfavs_pos/app-screens/settings-dashboard.dart';
import 'package:chicfavs_pos/app-screens/employees-dashboard.dart';
import 'package:chicfavs_pos/app-screens/employee-levels.dart';
import 'package:chicfavs_pos/gen_screens_or_widgets/new-employee-level.dart';
import 'package:chicfavs_pos/gen_screens_or_widgets/employee-form.screen.dart';
import 'package:chicfavs_pos/app-screens/employees.dart';
import 'package:chicfavs_pos/gen_screens_or_widgets/product-form.screen.dart';
import 'package:chicfavs_pos/app-screens/products.dart';
import 'package:chicfavs_pos/app-screens/branches.dart';
import 'package:chicfavs_pos/gen_screens_or_widgets/branch-form.dart';

import 'app-screens/allocate-stock.dart';
import 'app-screens/allocation-details.dart';
import 'app-screens/allocation-sale.dart';
import 'app-screens/categories.dart';
import 'app-screens/reports-dashboard.dart';
import 'app-screens/saleshistory.dart';
import 'app-screens/stock_take_history.dart';
import 'gen_screens_or_widgets/category-form.dart';

class RouteGenerator {
  static Route<dynamic> routeGenerator(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/salesDashboard":
        return MaterialPageRoute(
            builder: (_) => SalesDashboard(level: routeSettings.arguments));
      case "/inventoryDashboard":
        return MaterialPageRoute(builder: (_) => InventoryDashboard());
      case "/employeesDashboard":
        return MaterialPageRoute(builder: (_) => EmployeesDashboard());
      case "/reportsDashboard":
        return MaterialPageRoute(builder: (_) => ReportsDashboard());
      case "/allEmployeeLevels":
        return MaterialPageRoute(builder: (_) => EmployeeLevels());
      case "/newEmployeeLevel":
        return MaterialPageRoute(
            builder: (_) => NewEmployeeLevel(data: routeSettings.arguments));
      case "/editDeleteEmployeeLevel":
        return MaterialPageRoute(
            builder: (_) => NewEmployeeLevel(data: routeSettings.arguments));
      case "/allEmployees":
        return MaterialPageRoute(builder: (_) => Employees());
      case "/newEmployee":
        return MaterialPageRoute(
            builder: (_) => EmployeeScreen(data: routeSettings.arguments));
      case "/viewSpecificEmployee":
        return MaterialPageRoute(
            builder: (_) => EmployeeScreen(data: routeSettings.arguments));
      case "/allProducts":
        return MaterialPageRoute(builder: (_) => Products());
      case "/addNewProduct":
        return MaterialPageRoute(
            builder: (_) => ProductForm(data: routeSettings.arguments));
      case "/viewSpecificProduct":
        return MaterialPageRoute(
            builder: (_) => ProductForm(data: routeSettings.arguments));
      case "/allBranches":
        return MaterialPageRoute(builder: (_) => Branches());
      case "/newBranch":
        return MaterialPageRoute(
            builder: (_) => BranchForm(
                  data: routeSettings.arguments,
                ));
      case "/editDeleteBranch":
        return MaterialPageRoute(
            builder: (_) => BranchForm(
                  data: routeSettings.arguments,
                ));
      case "/makeASale":
        return MaterialPageRoute(builder: (_) => TypeOfSale());
      case "/normalSale":
        return MaterialPageRoute(builder: (_) => NormalSale());
      case "/allocationSale":
        return MaterialPageRoute(builder: (_) => AllocationSale());
      case "/saleHistory":
        return MaterialPageRoute(builder: (_) => SalesHistory());
      case "/stockTakeHistory":
        return MaterialPageRoute(builder: (_) => StockTakeHistory());
      case "/newStockTake":
        return MaterialPageRoute(builder: (_) => NewStockTake());
      case "/specificStockTakeHistory":
        return MaterialPageRoute(
            builder: (_) => NewStockTake(id: routeSettings.arguments));
      case "/specificSaleHistory":
        return MaterialPageRoute(
            builder: (_) => SpecificSaleHistory(routeSettings.arguments));
      case "/allCategories":
        return MaterialPageRoute(builder: (_) => Categories());
      case "/newCategory":
        return MaterialPageRoute(
            builder: (_) => CategoryForm(
                  data: routeSettings.arguments,
                ));
      case "/allocateStock":
        return MaterialPageRoute(builder: (_) => AllocateStock());
      case "/editDeleteCategory":
        return MaterialPageRoute(
            builder: (_) => CategoryForm(
                  data: routeSettings.arguments,
                ));
      case "/allocationDetails":
        return MaterialPageRoute(builder: (_) => AllocationDetails());
      case "/details":
        return MaterialPageRoute(
            builder: (_) => SpecificAllocationDetails(routeSettings.arguments));
      case "/specificAllocationHistoryDetails":
        return MaterialPageRoute(
            builder: (_) =>
                SpecificAllocationHistoryDetails(routeSettings.arguments));
      case "/dailyReport":
        return MaterialPageRoute(builder: (_) => DailyReport());
      case "/monthlyReport":
        return MaterialPageRoute(builder: (_) => MonthlyReport());
      case "/yearlyReport":
        return MaterialPageRoute(builder: (_) => YearlyReport());
      case "/settingsDashboard":
        return MaterialPageRoute(builder: (_) => SettingsDashboard());
    }
  }
}
