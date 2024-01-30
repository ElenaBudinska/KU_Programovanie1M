import 'package:intl/intl.dart';

class Request {
  final int? requestId;
  final int serviceId;
  final String serviceName;
  final String additionalInformation;
  final DateTime dateTime;
  final String phone;
  final String email;

  Request(this.serviceId, this.serviceName, this.additionalInformation,
      this.dateTime, this.phone, this.email, this.requestId);

  // mapovanie z objektu Request na DB objekt 
  Map<String, dynamic> mapToJson() {
    return {
      "serviceId": serviceId,
      "serviceDescription": serviceName,
      "additionalInformation": additionalInformation,
      "requiredDateTime": DateFormat('yyyy/MM/dd HH:mm').format(dateTime),
      "customerPhone": phone,
      "customerEmail": email,
    };
  }

  // mapovanie z DB objektu na objekt Request
  static Request jsonMapToRequest(Map<String, dynamic> json) {
    var dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    int requestId = json['id'];
    int serviceId = json["serviceId"];
    String serviceName = json["serviceDescription"];
    String additionalInformation = json["additionalInformation"];
    DateTime dateTime = dateFormat.parseStrict(json["requiredDateTime"]);
    String phone = json["customerPhone"];
    String email = json["customerEmail"];

    return Request(serviceId, serviceName, additionalInformation, dateTime,
        phone, email, requestId);
  }
}
