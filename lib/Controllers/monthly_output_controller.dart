
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:water_report/Configs/api.dart';
import 'package:water_report/Configs/global.dart';
import 'package:http/http.dart' as http;
import 'package:water_report/Models/key_value_model.dart';
import 'package:water_report/Models/monitor_quality_model.dart';
import 'package:water_report/Models/monthly_output_model.dart';

import '../Models/monitor_pressure_model.dart';

class MonthlyOutputController with ChangeNotifier {
  Timer? _timer;

  String? _errorMessage;
  List<MonthlyOutputModel> _monthlyOutputs = [];
  double yieldMaxChart = 100;

  String? get errorMessage => _errorMessage;
  List<MonthlyOutputModel> get monthlyOutputs => _monthlyOutputs;

  void loopGetData(Function() fetchDataCallback) async {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {

      await fetchDataCallback();
    });
  }

  Future<void> getMonthlyOutput(String? id, String? month, {bool loading = false}) async{
    try {
      if(loading) {
        _errorMessage = null;
        _monthlyOutputs = [];
        notifyListeners();
      }

      Map<String, String> headers = {'Content-Type': 'application/json', 'Authorization' : 'Bearer $globalToken' };
      String params = "?measuring_point=$id&month=$month";
      print(GenerateApi.getPath('outputChart', params));
      final response = await http.get(GenerateApi.getPath('outputChart', params), headers: headers).timeout(const Duration(seconds: 10));

      if(response.statusCode != 200) {
        throw Exception("Failed to load data");
      }

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if(jsonResponse['success'] == true) {
        final List<dynamic> dataJson = jsonResponse['data'];
        _monthlyOutputs = dataJson.map((e) => MonthlyOutputModel.fromMap(e)).toList();
        yieldMaxChart = jsonResponse['quantity']['total'].toDouble();
        if(_monthlyOutputs.isEmpty){
          _errorMessage = "Không có dữ liệu";
        }

      } else{
        _errorMessage = "Không có dữ liệu";
      }
    }catch (e) {
      print(e);
      _errorMessage = "Không có dữ liệu";
      _timer?.cancel();
    }
    print(_monthlyOutputs);
    notifyListeners();
  }

  void cancelTimer(){
    _errorMessage = "";
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}