import 'dart:convert';

GantipassResponseModel gantipassResponseModelFromJson(String str) => 
    GantipassResponseModel.fromJson(json.decode(str));

String gantipassResponseModelToJson(GantipassResponseModel data) => 
    json.encode(data.toJson());

class GantipassResponseModel {
  GantipassResponseModel({
    required this.message,
    this.data,
  });

  final String message;
  final String? data;

  factory GantipassResponseModel.fromJson(Map<String, dynamic> json) => 
      GantipassResponseModel(
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
      };
}