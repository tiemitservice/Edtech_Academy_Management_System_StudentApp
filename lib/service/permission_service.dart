// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../model/permission_model.dart';


// class PermissionService {
//   static const String _url =
//       'http://188.166.242.109:5000/api/student_permissions';

//   static Future<bool> submitPermission(PermissionModel data) async {
//     try {
//       final response = await http.post(
//         Uri.parse(_url),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(data.toJson()),
//       );

//       print("Response: ${response.statusCode} - ${response.body}");

//       return response.statusCode == 200 || response.statusCode == 201;
//     } catch (e) {
//       print("Error: $e");
//       return false;
//     }
//   }
// }
