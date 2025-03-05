import 'package:intl/intl.dart';

class FormatUtils {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - h:mm a').format(dateTime);
  }
  
  static String formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMMM dd, yyyy').format(dateTime);
  }
  
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }
}