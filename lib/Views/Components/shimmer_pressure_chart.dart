import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water_report/Configs/constant.dart';

class ShimmerPressureChart extends StatelessWidget {
  const ShimmerPressureChart({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 300,
      child: const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
    );
  }

}