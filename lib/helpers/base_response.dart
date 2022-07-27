class BaseResponse {
  String? message;
  String? status;
  int? statusCode;
  dynamic data;

  BaseResponse({this.message, this.status, this.statusCode, this.data});

  static BaseResponse fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      data: json['data'],
      message: json['message'],
      status: json['status'],
      statusCode: json['status_code'],
    );
  }
}