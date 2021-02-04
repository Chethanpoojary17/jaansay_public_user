import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaansay_public_user/models/grievance_test.dart';
import 'package:jaansay_public_user/utils/conn_utils.dart';
import 'package:jaansay_public_user/utils/firebase_util.dart';

class GrievanceService {
  Future<void> addGrievance(
      {String official_id,
      String latitude,
      String longitude,
      String message,
      var files,
      String typename}) async {
    GetStorage box = GetStorage();
    List _media = [];

    for (var i = 0; i < files.length; i++) {
      File file = File(files[i].path);

      _media.add(
        {
          "file_name": files[i].name,
          "file": base64Encode(
            file.readAsBytesSync(),
          ),
        },
      );
    }

    Dio dio = Dio();

    Response response = await dio.post("${ConnUtils.url}grievances",
        data: {
          "official_id": "$official_id",
          "user_id": "${box.read("user_id")}",
          "grievance_message": "$message",
          "lattitude": "$latitude",
          "longitude": "$longitude",
          "status_id": typename == "Business" ? "1" : "4",
          "updated_at": "${DateTime.now()}",
          "is_feedback": "0",
          "doc_id": "2",
          "media": (_media.length == 0 || _media == null) ? "no media" : _media,
        },
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
        }));
    if (response.data["success"]) {
      FirebaseUtil feedUtil = FirebaseUtil();
      await feedUtil.addNotification(
          "New Message", "You have received one new message", "$official_id");
    }
    print(response.data);
  }

  Future<List<GrievanceTest>> getAllUserGrievances() async {
    List<GrievanceTest> grievances = [];
    Dio dio = new Dio();
    GetStorage box = GetStorage();
    final userId = box.read("user_id");

    try {
      Response response = await dio.get(
        "${ConnUtils.url}grievances/users/$userId",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
          },
        ),
      );
      if (response.data['success']) {
        response.data['data'].map((val) {
          grievances.add(GrievanceTest.fromJson(val));
        }).toList();
      } else {
        print("Failed");
      }
    } catch (e) {}
    return grievances;
  }

  Future<bool> addDocument(var file) async {
    GetStorage box = GetStorage();

    Dio dio = Dio();

    Response response = await dio.patch("${ConnUtils.url}publicusers/document",
        data: {
          "user_id": box.read("user_id"),
          "user_document": {
            "file_name": box.read("user_id").toString(),
            "file": base64Encode(
              file.readAsBytesSync(),
            ),
          },
        },
        options: Options(headers: {
          HttpHeaders.authorizationHeader: "Bearer ${box.read("token")}",
        }));
    if (response.data["success"]) {
      return true;
    } else {
      return false;
    }
  }
}