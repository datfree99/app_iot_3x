import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water_report/Configs/router.dart';
import 'package:water_report/Controllers/auth_controller.dart';
import 'package:water_report/Controllers/monitor_pressure_controller.dart';
import 'package:water_report/Views/Components/icon_status_component.dart';
import 'package:water_report/Views/Components/layout_component.dart';
import 'package:shimmer/shimmer.dart';
import '../../Configs/constant.dart';
import '../../Models/measuring_point_model.dart';
import '../Components/card_shadow_component.dart';

class MonitorPressureScreen extends StatefulWidget {
  MonitorPressureScreen({super.key});

  @override
  State<MonitorPressureScreen> createState() => _MonitorPressureScreenState();
}

class _MonitorPressureScreenState extends State<MonitorPressureScreen> {
  final monitorPressureController = MonitorPressureController();


  @override
  void initState() {
    monitorPressureController.getMonitorPressures();
    monitorPressureController.loopGetData(() => monitorPressureController.getMonitorPressures());
    super.initState();
  }


  @override
  void dispose() {
    monitorPressureController.cancelTimer();
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
              "GIÁM SÁT ÁP LỰC NƯỚC",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            CardShadow(
              padding: const EdgeInsets.all(5),
              child: ListenableBuilder(
                listenable: monitorPressureController,
                builder: (context, child) {
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
                      if (monitorPressureController.monitorPressures.isEmpty)
                        ..._buildShimmerRows()
                      else
                        for (var monitorPressure in monitorPressureController.monitorPressures)
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
                                    Navigator.of(context).pushNamed(RouteApp.monitorPressureDetail, arguments: monitorPressure.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 10, top: 10, right: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          monitorPressure.measuringPoint!,
                                          style: const TextStyle(
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 3,),
                                        IconStatusComponent(status: monitorPressure.status!),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              _buildCell(monitorPressure.updateTime!, textAlign: TextAlign.start),
                              _buildCell(monitorPressure.pressure!, textAlign: TextAlign.center),
                              _buildCell(monitorPressure.waterFlow!, textAlign: TextAlign.center),
                              _buildCell(monitorPressure.total!, textAlign: TextAlign.center),
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
      5, // Số lượng dòng shimmer
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
    _buildCell('Điểm đo', textAlign: TextAlign.start, fontWeight: FontWeight.bold),
    _buildCell('Thời gian', textAlign: TextAlign.start, fontWeight: FontWeight.bold),
    _buildCell('P(bar)', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('Q(m3/h)', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
    _buildCell('∑Q(m3)', textAlign: TextAlign.center, fontWeight: FontWeight.bold),
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


