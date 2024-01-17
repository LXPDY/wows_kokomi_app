class ErrorHttpModel {
  String? status;
  String? message;
  String? error;
  ErrorHttpModel(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
  }
}