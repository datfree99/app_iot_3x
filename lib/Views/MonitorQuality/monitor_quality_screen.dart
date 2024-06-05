import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water_report/Views/Components/layout_component.dart';

import '../../Configs/constant.dart';
import '../../Configs/router.dart';
import '../../Controllers/monitor_quality_controller.dart';
import '../Components/card_shadow_component.dart';
import '../Components/icon_status_component.dart';
import '../Components/show_error_component.dart';

class MonitorQualityScreen extends StatefulWidget {
  const MonitorQualityScreen({super.key});

  @override
  State<MonitorQualityScreen> createState() => _MonitorQualityScreenState();
}

class _MonitorQualityScreenState extends State<MonitorQualityScreen> {
  final monitorQualityController = MonitorQualityController();


  @override
  void initState() {
    monitorQualityController.getMonitorPressures();
    monitorQualityController.loopGetData(() => monitorQualityController.getMonitorPressures());
    super.initState();
  }

  @override
  void dispose() {
    monitorQualityController.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutComponent(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          children: [
            const Text(
              "GIÁM SÁT CHẤT LƯỢNG NƯỚC",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            CardShadow(
              padding: const EdgeInsets.all(5),
              child: ListenableBuilder(
                listenable: monitorQualityController,
                builder: (context, child) {
                  if(monitorQualityController.errorMessage != null){
                    return ShowErrorComponent(text: monitorQualityController.errorMessage.toString(), height: 200,);
                  }

                  return Table(
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: borderColor),
                          ),
                        ),
                        children: _buildColumns(),
                      ),
                      if (monitorQualityController.monitorQualities.isEmpty)
                        ..._buildShimmerRows()
                      else
                        for (var monitorQuality in monitorQualityController.monitorQualities)
                          TableRow(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 1.0, color: borderColor),
                              ),
                            ),
                            children: [
                              TableCell(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(RouteApp.monitorQualityDetail, arguments: monitorQuality.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10, right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconStatusComponent(status: monitorQuality.status!),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          monitorQuality.quality_criteria!,
                                          style: const TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _buildCell(monitorQuality.update_time!, textAlign: TextAlign.center),
                              _buildCell(monitorQuality.unit!, textAlign: TextAlign.center),
                              _buildCell(monitorQuality.measured_value!, textAlign: TextAlign.center),
                            ],
                          ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TableRow> _buildShimmerRows() {
    return List.generate(
      3, // Số lượng dòng shimmer
      (index) => TableRow(
        children: [
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
          TableCell(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(3, 3, 0, 0),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _buildColumns() {
  return [
    _buildCell('Chỉ tiêu chất lượng', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Thời gian', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Đơn vị', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Giá trị đo', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
  ];
}

TableCell _buildCell(String label, {TextAlign? textAlign, FontWeight? fontWeight}) {
  return TableCell(
    child: Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.w400,
          color: textColor,
        ),
        textAlign: textAlign,
      ),
    ),
  );
}
