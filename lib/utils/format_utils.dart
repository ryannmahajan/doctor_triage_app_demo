import 'package:intl/intl.dart';

class FormatUtils {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - h:mm a').format(dateTime);
  }
  
  // Add more formatting utilities as needed
}