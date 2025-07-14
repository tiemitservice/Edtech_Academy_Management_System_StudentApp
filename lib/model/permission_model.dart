class PermissionModel {
  final String reason;
  final String startDate;
  final String endDate;
  final String sentTo;
  final String permissionStatus;

  PermissionModel({
    required this.reason,
    required this.startDate,
    required this.endDate,
    required this.sentTo,
    this.permissionStatus = 'pending',
  });

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "start_date": startDate,
        "end_date": endDate,
        "sent_to": sentTo,
        "permission_status": permissionStatus,
      };
}
