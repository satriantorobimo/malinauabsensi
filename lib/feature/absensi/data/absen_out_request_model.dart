class AbsenOutRequestModel {
  final String qrContent;
  final String requestType;

  AbsenOutRequestModel({required this.qrContent, required this.requestType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['qr_content'] = qrContent;
    data['request_type'] = requestType;
    return data;
  }
}
