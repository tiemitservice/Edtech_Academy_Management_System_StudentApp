import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/permission_controller.dart';

class Permission_Status extends StatefulWidget {
  const Permission_Status({Key? key, required String email}) : super(key: key);

  @override
  State<Permission_Status> createState() => _Permission_StatusState();
}

class _Permission_StatusState extends State<Permission_Status> {
  final permissionController = Get.find<PermissionController>();

  @override
  void initState() {
    super.initState();
    permissionController.fetchStudentPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "permissionStatusTitle".tr,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (permissionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (permissionController.permissions.isEmpty) {
          return Center(child: Text("noPermissionRequests".tr));
        }

        return ListView.builder(
          itemCount: permissionController.permissions.length,
          itemBuilder: (context, index) {
            final permission = permissionController.permissions[index];
            final reason = permission['reason'] ?? 'noReason'.tr;
            final statusKey =
                (permission['permissent_status'] ?? 'pending').toLowerCase();

            final holdDates = (permission['hold_date'] as List<dynamic>)
                .map((d) => d.toString().split("T").first)
                .join(" → ");

            Color statusColor;
            String statusText;

            switch (statusKey) {
              case 'accepted':
                statusColor = Colors.green;
                statusText = 'statusAccepted'.tr;
                break;
              case 'rejected':
                statusColor = Colors.red;
                statusText = 'statusRejected'.tr;
                break;
              default:
                statusColor = Colors.orange;
                statusText = 'statusPending'.tr;
            }

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text("${'reasonLabel'.tr}: $reason"),
                subtitle: Text("${'dateLabel'.tr}: $holdDates"),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
