// lib/models/gantipass_response_model.dart

import 'dart:convert';

GantipassResponseModel gantipassResponseModelFromJson(String str) => GantipassResponseModel.fromJson(json.decode(str));

String gantipassResponseModelToJson(GantipassResponseModel data) => json.encode(data.toJson());

class GantipassResponseModel {
    String? message;
    Data? data;

    GantipassResponseModel({
        this.message,
        this.data,
    });

    factory GantipassResponseModel.fromJson(Map<String, dynamic> json) => GantipassResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? message;
    String? hash; // <-- Definisikan 'hash' sebagai String di sini

    Data({
        this.message,
        this.hash,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"],
        hash: json["hash"], // <-- Ambil 'hash' dari JSON
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "hash": hash,
    };
}