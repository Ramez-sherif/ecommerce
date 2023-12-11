class ResponseModel {
  final bool status;
  final String message;
  final dynamic data;

  ResponseModel({required this.status, required this.message, this.data});
}
