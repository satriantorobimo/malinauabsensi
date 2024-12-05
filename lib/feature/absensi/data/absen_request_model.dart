class AbsenRequestModel {
  final String qrContent;
  final String requestType;
  final Location location;

  AbsenRequestModel(
      {required this.qrContent,
      required this.requestType,
      required this.location});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qr_content'] = qrContent;
    data['request_type'] = requestType;
    data['location'] = location.toJson();
    return data;
  }
}

class Location {
  final double? long;
  final double? lat;

  Location({this.long, this.lat});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['long'] = long;
    data['lat'] = lat;
    return data;
  }
}
