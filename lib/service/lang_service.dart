import 'package:get/get.dart';

class LangService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'title': 'Hello',
          'change_lang': 'English',
          'welcome':'welcome',
          'email': 'Email',
          'password': 'Password',
          'submit': 'Submit',
          'Attendance': 'Attendance',
          'Student Score': 'Student Score',
          'Permission':'Permission',
          'Student_attendance': 'Student Attendance',
          'Score':'Score',
          'My Profile' : 'My Profile',
        },
        'km': {
          'title': 'សួស្តី',
          'change_lang': 'ភាសាខ្មែរ',
          //'welcome': 'សូមស្វាគមន៍មកកាន់សាលាអែតធិច',
          'welcome': 'សូមស្វាគមន៍',
          'email': 'អ៊ីម៉ែល',
          'password': 'ពាក្យសម្ងាត់',
          'submit': 'បញ្ជូន',
          'Attendance': 'វត្តមាន',
          'Student Score': 'ពិន្ទុសិស្ស',
          'Permission':'សុំំច្បាប់',
          'Student_attendance': 'វត្តមានសិស្ស',
          'Score': 'ពិន្ទុ',
          'My Profile' : 'ប្រវត្តិរូបរបស់ខ្ញុំ',

        },
      };
}
