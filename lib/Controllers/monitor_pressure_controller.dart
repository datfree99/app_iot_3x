
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:water_report/Configs/api.dart';
import 'package:water_report/Configs/global.dart';
import 'package:http/http.dart' as http;
import 'package:water_report/Models/key_value_model.dart';

import '../Models/measuring_point_model.dart';
import '../Models/monitor_pressure_model.dart';

class MonitorPressureController with ChangeNotifier {
    Timer? _timer;

    String? _errorMessage;
    List<MonitorPressureModel> _monitorPressures = [];

    List<KeyValueModel> pressures = [];
    List<KeyValueModel> waterFlows = [];
    List<KeyValueModel> dailyOutputs = [];
    List<KeyValueModel> mainX = [];


    String? get errorMessage => _errorMessage;
    List<MonitorPressureModel> get monitorPressures => _monitorPressures;

    void loopGetData(Function() fetchDataCallback) async {
        _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {

            await fetchDataCallback();
        });
    }

    Future<void> getMonitorPressures() async{
        print("xxxxxxxxxxxxxxxxxxx");
        try {
            Map<String, String> headers = {'Content-Type': 'application/json', 'Authorization' : 'Bearer $globalToken' };
            final response = await http.get(GenerateApi.getPath('pressure'), headers: headers).timeout(const Duration(seconds: 10));

            if(response.statusCode != 200) {
                throw Exception("Failed to load data");
            }

            final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
            if(jsonResponse['success'] == true) {
                final List<dynamic> dataJson = jsonResponse['data'];
                _monitorPressures = dataJson.map((e) => MonitorPressureModel.fromMap(e)).toList();
            }
        }catch (e) {
            _timer?.cancel();
        }

        notifyListeners();
    }

    Future<void> getMonitorPressureDetail(String id, String date, {bool loading = false}) async {
        try {

            if(loading){
                _errorMessage = null;
                waterFlows = [];
                dailyOutputs = [];
                pressures = [];
                mainX = [];

                notifyListeners();
            }

            Map<String, String> headers = {'Content-Type': 'application/json', 'Authorization' : 'Bearer $globalToken' };

            String params = "?measuring_point=$id&date=$date";
            print(params);
            final response = await http.get(GenerateApi.getPath('pressureDetail', params), headers: headers).timeout(const Duration(seconds: 30));

            if(response.statusCode != 200) {
                throw Exception("Failed to load data");
            }

            final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

            if(jsonResponse['success'] == true) {
                waterFlows = (jsonResponse['data']['m3/h'] as List)
                    .map((data) => KeyValueModel.fromMap(data))
                    .toList();

                dailyOutputs = (jsonResponse['data']['m3'] as List)
                    .map((data) => KeyValueModel.fromMap(data))
                    .toList();

                pressures = (jsonResponse['data']['bar'] as List)
                    .map((data) => KeyValueModel.fromMap(data))
                    .toList();

                mainX = (jsonResponse['data']['main_x'] as List)
                    .map((data) => KeyValueModel.fromMap(data))
                    .toList();

                if(waterFlows.isEmpty || dailyOutputs.isEmpty || pressures.isEmpty || mainX.isEmpty){
                    _errorMessage = "Không có dữ liệu";
                }
            } else {
                _errorMessage = "Không có dữ liệu";
            }
        }catch (e) {
            _errorMessage = "Không có dữ liệu";
            _timer?.cancel();

        }
        notifyListeners();
    }



    void cancelTimer(){
        _errorMessage = null;
        _timer?.cancel();
    }

    @override
    void dispose() {
        _timer?.cancel();
        super.dispose();
    }
}